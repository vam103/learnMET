#' @rdname fit_cv_split
#' @export
fit_cv_split.stacking_reg_3 <- function (object,
                                         seed,
                                         inner_cv_reps = 1,
                                         inner_cv_folds = 5,
                                         kernel_G = 'linear',
                                         kernel_E = 'polynomial',
                                         kernel_GE = 'polynomial',
                                         compute_vip = F,
                                         ...) {
  cat('Kernel for G is', kernel_G,'\n')
  cat('Kernel for E is', kernel_E,'\n')
  cat('Kernel for GE is', kernel_GE,'\n')
  
  
  training = object[['training']]
  test = object[['test']]
  
  rec_G = object[['rec_G']]
  rec_E = object[['rec_E']]
  rec_GE = object[['rec_GE']]
  
  trait = as.character(rec_G$var_info[rec_G$var_info$role == 'outcome', 'variable'])
  
  env_predictors = colnames(
    recipes::bake(recipes::prep(rec_E), new_data = training) %>%
      dplyr::select(-IDenv, -tidyselect::all_of(trait))
  )
  
  
  
  # Some settings common for all kernels to be trained
  
  metric <- yardstick::metric_set(yardstick::rmse)
  
  ctrl_res <- stacks::control_stack_resamples()
  
  # Inner CV
  
  set.seed(seed)
  folds <-
    rsample::vfold_cv(training, repeats = inner_cv_reps, v = inner_cv_folds)
  
  # Define the prediction model to use: support vector machine with 3 different
  # subset features.
  # Define the space-filling design for grid search.
  
  svm_spec_rbf <-
    parsnip::svm_rbf(cost = tune("cost"),
                     rbf_sigma = tune("sigma")) %>%
    parsnip::set_engine("kernlab") %>%
    parsnip::set_mode("regression")
  
  svm_spec_polynomial <-
    parsnip::svm_poly(
      cost = tune("cost"),
      degree = tune("degree"),
      scale_factor = tune('scale_factor')
    ) %>%
    parsnip::set_engine("kernlab") %>%
    parsnip::set_mode("regression")
  
  svm_spec_linear <-
    parsnip::svm_linear(cost = tune("cost")) %>%
    parsnip::set_engine("LiblineaR") %>%
    parsnip::set_mode("regression")
  
  
  if (kernel_G == 'rbf') {
    svm_spec_G <- svm_spec_rbf
    grid_model_G <- 8
  } else if (kernel_G == 'polynomial') {
    svm_spec_G <- svm_spec_polynomial
    grid_model_G <- 10
  } else{
    svm_spec_G <- svm_spec_linear
    grid_model_G <- 6
  }
  
  if (kernel_E == 'rbf') {
    svm_spec_E <- svm_spec_rbf
    grid_model_E <- 8
  } else if (kernel_E == 'polynomial') {
    svm_spec_E <- svm_spec_polynomial
    grid_model_E <- 10
  } else{
    svm_spec_E <- svm_spec_linear
    grid_model_E <- 6
  }
  
  if (kernel_GE == 'rbf') {
    svm_spec_GE <- svm_spec_rbf
    grid_model_GE <- 8
  } else if (kernel_GE == 'polynomial') {
    svm_spec_GE <- svm_spec_polynomial
    grid_model_GE <- 10
  } else{
    svm_spec_GE <- svm_spec_linear
    grid_model_GE <- 6
  }
  
  
  # Add recipe and model definition to a workflow, for each of the kernel
  
  svm_wflow_G <-
    workflows::workflow() %>%
    workflows::add_model(svm_spec_G) %>%
    workflows::add_recipe(rec_G)
  
  svm_wflow_E <-
    workflows::workflow() %>%
    workflows::add_model(svm_spec_E) %>%
    workflows::add_recipe(rec_E)
  
  svm_wflow_GE <-
    workflows::workflow() %>%
    workflows::add_model(svm_spec_GE) %>%
    workflows::add_recipe(rec_GE)
  
  # tune cost and sigma with the inner CV for each of the kernels
  
  set.seed(seed)
  
  set.seed(seed)
  svm_res_E <-
    tune::tune_grid(
      svm_wflow_E,
      resamples = folds,
      grid = grid_model_E,
      metrics = metric,
      control = tune::control_grid(
        save_pred = TRUE,
        save_workflow = TRUE,
        verbose = FALSE
      )
    )
  cat('Support vector regression with env. kernel done!')
  
  
  set.seed(seed)
  svm_res_G <-
    tune::tune_grid(
      svm_wflow_G,
      resamples = folds,
      grid = grid_model_G,
      metrics = metric,
      control = tune::control_grid(
        save_pred = TRUE,
        save_workflow = TRUE,
        verbose = FALSE
      )
    )
  cat('Support vector regression with genomic kernel done!')
  
  
  
  set.seed(seed)
  svm_res_GE <-
    tune::tune_grid(
      svm_wflow_GE,
      resamples = folds,
      grid = grid_model_GE,
      metrics = metric,
      control = tune::control_grid(
        save_pred = TRUE,
        save_workflow = TRUE,
        verbose = FALSE
      )
    )
  cat('Support vector regression with GxE kernel done!')
  
  # Initialize a data stack using the stacks() function.
  
  METData_data_st <-
    stacks::stacks() %>%
    stacks::add_candidates(svm_res_G) %>%
    stacks::add_candidates(svm_res_E) %>%
    stacks::add_candidates(svm_res_GE)
  
  # Fit the stack
  
  METData_model_st <-
    METData_data_st %>%
    stacks::blend_predictions()
  
  METData_model_st <-
    METData_model_st %>%
    stacks::fit_members()
  
  # Identify which model configurations were assigned what stacking coefficients
  parameters_collection_G <-
    METData_model_st %>% stacks::collect_parameters('svm_res_G')
  parameters_collection_E <-
    METData_model_st %>% stacks::collect_parameters('svm_res_E')
  parameters_collection_GE <-
    METData_model_st %>% stacks::collect_parameters('svm_res_GE')
  
  
  # Predictions and metrics calculated on a per-environment basis
  
  predictions_test <-
    as.data.frame(METData_model_st %>% predict(new_data = test) %>% bind_cols(test))
  
  cor_pred_obs <-
    METData_model_st %>% predict(new_data = test) %>% bind_cols(test) %>%
    group_by(IDenv) %>% summarize(COR = cor(.pred, get(trait), method = 'pearson'))
  print(cor_pred_obs)
  
  #cor_pred_obs <-
  #  cor(predictions_test[, '.pred'], predictions_test[, trait], method = 'pearson')
  
  rmse_pred_obs <-
    METData_model_st %>% predict(new_data = test) %>% dplyr::bind_cols(test) %>%
    dplyr::group_by(IDenv) %>% dplyr::summarize(RMSE = sqrt(mean((get(
      trait
    ) - .pred) ^ 2)))
  
  
  # Apply the trained data recipe
  rec_GE <- recipes::prep(rec_GE)
  train_GE = recipes::bake(rec_GE, training)
  test_GE = recipes::bake(rec_GE, test)
  
  # Return final list of class res_fitted_split
  res_fitted_split <- structure(
    list(
      'prediction_method' = class(object),
      'parameters_collection_G' = as.data.frame(parameters_collection_G),
      'parameters_collection_E' = as.data.frame(parameters_collection_E),
      'parameters_collection_GE' = as.data.frame(parameters_collection_GE),
      'predictions_df' = predictions_test,
      'cor_pred_obs' = cor_pred_obs,
      'rmse_pred_obs' = rmse_pred_obs,
      'training_GE_transformed' = as.data.frame(train_GE),
      'test_GE_transformed' = as.data.frame(test_GE),
      'vip' = data.frame()
    ),
    class = 'res_fitted_split'
  )
  
  
  
  if (compute_vip) {
    fitted_obj_for_vip <- structure(
      list(
        model = METData_model_st,
        x_train = as.data.frame(training %>%
                                  dplyr::select(-all_of(trait))),
        y_train = as.data.frame(training %>%
                                  dplyr::select(all_of(trait))),
        
        trait = trait,
        env_predictors = env_predictors
      ),
      class = c('fitted_stacking_reg_3', 'list')
    )
    
    # Obtain the variable importance
    
    variable_importance_vip <-
      variable_importance_split(fitted_obj_for_vip)
    
    
    
    # Return final list of class res_fitted_split
    res_fitted_split <- structure(
      list(
        'prediction_method' = class(object),
        'parameters_collection_G' = as.data.frame(parameters_collection_G),
        'parameters_collection_E' = as.data.frame(parameters_collection_E),
        'parameters_collection_GE' = as.data.frame(parameters_collection_GE),
        'predictions_df' = predictions_test,
        'cor_pred_obs' = cor_pred_obs,
        'rmse_pred_obs' = rmse_pred_obs,
        'training_GE_transformed' = as.data.frame(train_GE),
        'test_GE_transformed' = as.data.frame(test_GE),
        'vip' = variable_importance_vip
      ),
      class = 'res_fitted_split'
    )
  }
  
  
  
  
  
  return(res_fitted_split)
  
  
}

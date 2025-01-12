% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predict_trait_MET.R
\name{predict_trait_MET}
\alias{predict_trait_MET}
\title{Phenotypic prediction of unobserved data.}
\usage{
predict_trait_MET(
  METData_training,
  METData_new,
  trait,
  prediction_method = "xgb_reg",
  use_selected_markers = F,
  list_selected_markers_manual = NULL,
  geno_information = "PCs",
  lat_lon_included = F,
  year_included = F,
  include_env_predictors = T,
  list_env_predictors = NULL,
  seed = NULL,
  save_processing = T,
  path_folder,
  compute_vip = TRUE,
  ...
)
}
\arguments{
\item{trait}{\code{character} Name of the trait to predict. An ordinal trait
should be encoded as \code{integer}.}

\item{prediction_method}{\code{character} specifying the predictive model to use.
Options are \code{xgb_reg} (gradient boosted trees),
(stacking of support vector machines with LASSO as meta-learner).}

\item{use_selected_markers}{A \code{Logical} indicating whether to use a
subset of markers obtained from a previous step
(see \code{\link[=function select_markers]{function select_markers()}}).}

\item{geno_information}{indicating how the complete genotypic matrix should
be used in predictions. Options are \code{SNPs} (all
of the markers will be individually used), \code{PCs} (PCA will be applied on
each genotype matrix for the training set for dimensionality reduction)
or \code{PCs_G} (decomposition of the genomic relationship matrix via PCA -- not
yet implemented).}

\item{lat_lon_included}{\code{logical} indicates if longitude and latitude
data should be used as numeric predictors. Default is \code{TRUE}.}

\item{year_included}{\code{logical} indicates if year factor should be used
as predictor variable. Default is \code{FALSE}.}

\item{include_env_predictors}{A \code{logical} indicating whether
environmental covariates characterizing each environment should be used in
predictions.}

\item{list_env_predictors}{A \code{character} vector containing the names
of the environmental predictors which should be used in predictions. By
default \code{NULL}: all environmental predictors included in the env_data table
of the \code{METData} object will be used.}

\item{seed}{\code{integer} Seed value. Default is \code{NULL}. By default, a
random seed will be generated.}

\item{save_processing}{a \code{logical} indicating whether the processing
steps obtained from the \code{\link[=processing_train_test_split]{processing_train_test_split()}} or
\code{\link[=processing_train_test_split_kernel]{processing_train_test_split_kernel()}} functions should be saved in a .RDS
object. Default is \code{FALSE}.}

\item{path_folder}{a \code{character} indicating the full path where the .RDS
object and plots generated during the analysis should be saved (do not use
a Slash after the name of the last folder). Default is \code{NULL}.}

\item{...}{Arguments passed to the \code{\link[=processing_train_test_split]{processing_train_test_split()}},
\code{\link[=processing_train_test_split_kernel]{processing_train_test_split_kernel()}}, \code{\link[=reg_fitting_train_test_split]{reg_fitting_train_test_split()}},
\code{\link[=reg_fitting_train_test_split_kernel]{reg_fitting_train_test_split_kernel()}} functions.}

\item{METData}{\code{list} An object created by the initial function of the
package create_METData().}

\item{cv_type}{A \code{character} with one out of \code{cv0} (prediction of new
environments), \code{cv00} (prediction of new genotypes in new environments),
\code{cv1} (prediction of new genotypes) or \code{cv2} (prediction of incomplete
field trials). Default is \code{cv0}.}

\item{cv0_type}{A \code{character} with one out of
\code{leave-one-environment-out}, \code{leave-one-site-out},\code{leave-one-year-out},
\code{forward-prediction}. Default is \code{leave-one-environment-out}.}

\item{nb_folds_cv1}{A \code{numeric} Number of folds used in the CV1 scheme.
Default is 5.}

\item{repeats_cv1}{A \code{numeric} Number of repeats in the CV1 scheme.
Default is 50.}

\item{nb_folds_cv2}{A \code{numeric} Number of folds used in the CV2 scheme.
Default is 5.}

\item{repeats_cv2}{A \code{numeric} Number of repeats in the CV2 scheme.
Default is 50.}
}
\value{
A \code{list} object of class \code{met_cv} with the following items:
\describe{
\item{list_results_cv}{\code{list} of \code{res_fitted_split} elements.
Detailed prediction results for each split of the
data within each element of this list.}
\item{seed_used}{\code{integer} Seed used to generate the
cross-validation splits.}
}
}
\description{
Implement trait prediction based on SNP and environmental data
with selection of prediction methods among Machine Learning approaches.

This function should be used to assess the predictive ability according to
a cross-validation scheme determined by the user.
}
\author{
Cathy C. Westhues \email{cathy.jubin@uni-goettingen.de}
}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fit_DL_reg_1.R, R/fit_DL_reg_2.R,
%   R/fit_DL_reg_3.R, R/fit_cv_split.R, R/fit_rf_reg_1.R, R/fit_rf_reg_2.R,
%   R/fit_rf_reg_3.R, R/fit_stacking_reg_1.R, R/fit_stacking_reg_2.R,
%   R/fit_stacking_reg_3.R, R/fit_xgb_reg_1.R, R/fit_xgb_reg_2.R,
%   R/fit_xgb_reg_3.R
\name{fit_cv_split}
\alias{fit_cv_split}
\alias{fit_cv_split.DL_reg_1}
\alias{fit_cv_split.DL_reg_2}
\alias{fit_cv_split.DL_reg_3}
\alias{fit_cv_split.default}
\alias{fit_cv_split.rf_reg_1}
\alias{fit_cv_split.rf_reg_2}
\alias{fit_cv_split.rf_reg_3}
\alias{fit_cv_split.stacking_reg_1}
\alias{fit_cv_split.stacking_reg_2}
\alias{fit_cv_split.stacking_reg_3}
\alias{fit_cv_split.xgb_reg_1}
\alias{fit_cv_split.xgb_reg_2}
\alias{fit_cv_split.xgb_reg_3}
\title{S3 method used to fit an object of class \code{xgb_reg_1}, \code{xgb_reg_2},
\code{xgb_reg_3},\code{DL_reg},\code{DL_reg_1},\code{DL_reg_2},\code{DL_reg_3},\code{stacking_reg_1},
\code{stacking_reg_2} or \code{stacking_reg_3}.}
\usage{
\method{fit_cv_split}{DL_reg_1}(object, seed, inner_cv_reps = 1, inner_cv_folds = 3, ...)

\method{fit_cv_split}{DL_reg_2}(
  object,
  seed,
  inner_cv_reps = 1,
  inner_cv_folds = 3,
  compute_vip = F,
  ...
)

\method{fit_cv_split}{DL_reg_3}(
  object,
  seed,
  inner_cv_reps = 1,
  inner_cv_folds = 3,
  compute_vip = F,
  ...
)

fit_cv_split(object, ...)

\method{fit_cv_split}{default}(x, ...)

\method{fit_cv_split}{rf_reg_1}(
  object,
  seed,
  inner_cv_reps = 1,
  inner_cv_folds = 5,
  compute_vip = F,
  ...
)

\method{fit_cv_split}{rf_reg_2}(
  object,
  seed,
  inner_cv_reps = 1,
  inner_cv_folds = 5,
  compute_vip = F,
  ...
)

\method{fit_cv_split}{rf_reg_3}(object, seed, inner_cv_reps = 1, inner_cv_folds = 5, ...)

\method{fit_cv_split}{stacking_reg_1}(
  object,
  seed,
  inner_cv_reps = 1,
  inner_cv_folds = 5,
  kernel_G = "linear",
  kernel_E = "polynomial",
  path_folder,
  compute_vip = F,
  ...
)

\method{fit_cv_split}{stacking_reg_2}(
  object,
  seed,
  inner_cv_reps = 1,
  inner_cv_folds = 5,
  kernel_G = "linear",
  kernel_E = "polynomial",
  kernel_GE = "polynomial",
  ...
)

\method{fit_cv_split}{stacking_reg_3}(
  object,
  seed,
  inner_cv_reps = 1,
  inner_cv_folds = 5,
  kernel_G = "linear",
  kernel_E = "polynomial",
  kernel_GE = "polynomial",
  compute_vip = F,
  ...
)

\method{fit_cv_split}{xgb_reg_1}(
  object,
  seed,
  inner_cv_reps = 1,
  inner_cv_folds = 5,
  compute_vip = F,
  ...
)

\method{fit_cv_split}{xgb_reg_2}(
  object,
  seed,
  inner_cv_reps = 1,
  inner_cv_folds = 5,
  compute_vip = F,
  ...
)

\method{fit_cv_split}{xgb_reg_3}(object, seed, inner_cv_reps = 1, inner_cv_folds = 5, ...)
}
\arguments{
\item{object}{an object of class \code{xgb_reg_3}}

\item{seed}{\code{integer} Seed value.}

\item{inner_cv_reps}{\code{integer} Number of repeats of the k-folds CV
for hyperparameter optimization.}

\item{inner_cv_folds}{\code{integer} Number k in the k-folds CV used for
hyperparameter optimization.}
}
\value{











}
\description{
S3 dispatching method for objects of class \code{xgb_reg_1}, \code{xgb_reg_2},
\code{xgb_reg_3},\code{DL_reg},\code{DL_reg_1},\code{DL_reg_2},\code{DL_reg_3},\code{stacking_reg_1},
\code{stacking_reg_2} or \code{stacking_reg_3}.

Fit a random forest model on an object of class \code{rf_reg_1}.
Three hyperparameters (number of iterations = number of trees ; tree depth ;
learning rate) are tuned using the training set via Bayesian
optimization with 5-folds cross-validation (k-folds CV). A model is fitted on
the training set using the best hyperparameters and model performance is evaluated on the
test set.

Fit a gradient boosted trees model on an object of class \code{rf_reg_2}.
Three hyperparameters (number of iterations = number of trees ; tree depth ;
learning rate) are tuned using the training set via Bayesian
optimization with 5-folds cross-validation (k-folds CV). A model is fitted on
the training set using the best hyperparameters and model performance is evaluated on the
test set.

Fit a gradient boosted trees model on an object of class \code{rf_reg_3}.
Three hyperparameters (number of iterations = number of trees ; tree depth ;
learning rate) are tuned using the training set via Bayesian
optimization with 5-folds cross-validation (k-folds CV). A model is fitted on
the training set using the best hyperparameters and model performance is evaluated on the
test set.

Fit a gradient boosted trees model on an object of class \code{xgb_reg_1}.
Three hyperparameters (number of iterations = number of trees ; tree depth ;
learning rate) are tuned using the training set via Bayesian
optimization with 5-folds cross-validation (k-folds CV). A model is fitted on
the training set using the best hyperparameters and model performance is evaluated on the
test set.

Fit a gradient boosted trees model on an object of class \code{xgb_reg_2}.
Three hyperparameters (number of iterations = number of trees ; tree depth ;
learning rate) are tuned using the training set via Bayesian
optimization with 5-folds cross-validation (k-folds CV). A model is fitted on
the training set using the best hyperparameters and model performance is evaluated on the
test set.

Fit a gradient boosted trees model on an object of class \code{xgb_reg_3}.
Three hyperparameters (number of iterations = number of trees ; tree depth ;
learning rate) are tuned using the training set via Bayesian
optimization with 5-folds cross-validation (k-folds CV). A model is fitted on
the training set using the best hyperparameters and model performance is evaluated on the
test set.
}
\author{
Cathy C. Westhues \email{cathy.jubin@uni-goettingen.de}
}

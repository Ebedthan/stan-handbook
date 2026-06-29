// stan/multiple_regression.stan
// Bayesian multiple linear regression with K predictors.
//
//   y_i ~ Normal(alpha + X[i,] * beta, sigma)
//
// X is an N x K matrix of predictors (centred and scaled recommended).
// beta is a K-vector of slopes.

data {
  int<lower=1> N;           // number of observations
  int<lower=1> K;           // number of predictors
  matrix[N, K] X;           // predictor matrix (N rows, K columns)
  vector[N] y;              // outcome
}

parameters {
  real alpha;               // intercept
  vector[K] beta;           // slopes (one per predictor)
  real<lower=0> sigma;      // residual SD
}

model {
  // --- Priors ----------------------------------------------------------
  alpha ~ normal(0, 10);
  beta  ~ normal(0, 5);     // same prior applied independently to each beta[k]
  sigma ~ exponential(1);

  // --- Likelihood ------------------------------------------------------
  y ~ normal(alpha + X * beta, sigma);
}

generated quantities {
  vector[N] y_rep;
  vector[N] log_lik;

  for (i in 1:N) {
    real mu_i    = alpha + dot_product(X[i], beta);
    y_rep[i]    = normal_rng(mu_i, sigma);
    log_lik[i]  = normal_lpdf(y[i] | mu_i, sigma);
  }
}

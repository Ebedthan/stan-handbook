// stan/simple_regression.stan
// Simple Bayesian linear regression:
//   y_i ~ Normal(alpha + beta * x_i, sigma)
//
// Parameters
//   alpha : intercept
//   beta  : slope
//   sigma : residual standard deviation (constrained > 0)

data {
  int<lower=1> N;          // number of observations
  vector[N] x;             // predictor (centred recommended)
  vector[N] y;             // outcome
}

parameters {
  real alpha;              // intercept
  real beta;               // slope
  real<lower=0> sigma;     // residual SD
}

model {
  // --- Priors ----------------------------------------------------------
  alpha ~ normal(0, 10);   // weakly informative: intercept
  beta  ~ normal(0, 5);    // weakly informative: slope
  sigma ~ exponential(1);  // residual SD: positive, moderate values

  // --- Likelihood ------------------------------------------------------
  y ~ normal(alpha + beta * x, sigma);
}

generated quantities {
  // Posterior predictive draws (one per observation)
  vector[N] y_rep;
  // Point-wise log-likelihood (needed for LOO-CV in Chapter 14)
  vector[N] log_lik;

  for (i in 1:N) {
    y_rep[i]   = normal_rng(alpha + beta * x[i], sigma);
    log_lik[i] = normal_lpdf(y[i] | alpha + beta * x[i], sigma);
  }
}

// stan/anova_treatment.stan
// One-way ANOVA — treatment (dummy) coding.
//
// Model:
//   y_i ~ Normal(mu[group[i]], sigma)
//
// mu[1] is the reference group mean (alpha).
// mu[k] = alpha + tau[k-1] for k = 2,...,K
// tau[k] is the deviation of group k from the reference.

data {
  int<lower=1> N;              // total observations
  int<lower=2> K;              // number of groups
  array[N] int<lower=1, upper=K> group;  // group index for each observation
  vector[N] y;                 // outcome
}

parameters {
  real alpha;                  // reference group mean (group 1)
  vector[K-1] tau;             // deviations from reference (groups 2..K)
  real<lower=0> sigma;         // within-group SD (homoscedastic)
}

transformed parameters {
  // Assemble the full vector of group means
  vector[K] mu;
  mu[1] = alpha;
  for (k in 2:K)
    mu[k] = alpha + tau[k-1];
}

model {
  // --- Priors ----------------------------------------------------------
  alpha ~ normal(0, 10);       // reference group mean
  tau   ~ normal(0, 5);        // treatment effects vs reference
  sigma ~ exponential(1);

  // --- Likelihood ------------------------------------------------------
  for (i in 1:N)
    y[i] ~ normal(mu[group[i]], sigma);
}

generated quantities {
  vector[N] y_rep;
  vector[N] log_lik;

  for (i in 1:N) {
    y_rep[i]   = normal_rng(mu[group[i]], sigma);
    log_lik[i] = normal_lpdf(y[i] | mu[group[i]], sigma);
  }
}

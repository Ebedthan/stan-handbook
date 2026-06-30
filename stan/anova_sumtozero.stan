// stan/anova_sumtozero.stan
// One-way ANOVA — sum-to-zero (effects) coding.
//
// Model:
//   y_i ~ Normal(mu + tau[group[i]], sigma)
//
// Constraint: sum(tau) = 0
// The last effect tau[K] is derived: tau[K] = -sum(tau[1..K-1])

data {
  int<lower=1> N;
  int<lower=2> K;
  array[N] int<lower=1, upper=K> group;
  vector[N] y;
}

parameters {
  real mu;                     // grand mean
  vector[K-1] tau_raw;         // free effects for groups 1..K-1
  real<lower=0> sigma;
}

transformed parameters {
  // Reconstruct the full effects vector with the sum-to-zero constraint
  vector[K] tau;
  tau[1:(K-1)] = tau_raw;
  tau[K]       = -sum(tau_raw);  // derived so that sum(tau) == 0
}

model {
  // --- Priors ----------------------------------------------------------
  mu      ~ normal(0, 10);
  tau_raw ~ normal(0, 5);
  sigma   ~ exponential(1);

  // --- Likelihood ------------------------------------------------------
  for (i in 1:N)
    y[i] ~ normal(mu + tau[group[i]], sigma);
}

generated quantities {
  vector[N] y_rep;
  vector[N] log_lik;

  for (i in 1:N) {
    y_rep[i]   = normal_rng(mu + tau[group[i]], sigma);
    log_lik[i] = normal_lpdf(y[i] | mu + tau[group[i]], sigma);
  }
}

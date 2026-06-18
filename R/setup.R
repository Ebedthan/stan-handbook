# R/setup.R
# Loaded at the top of every chapter via source("R/setup.R")
# Keep this file lean: only universal options and package loading.

# Packages
suppressPackageStartupMessages({
  library(cmdstanr)    # Stan interface
  library(posterior)   # draws_df, summarise_draws, etc.
  library(bayesplot)   # mcmc_trace, ppc_dens_overlay, etc.
  library(loo)         # LOO-CV, WAIC
  library(ggplot2)     # all plots
  library(dplyr)       # data wrangling
  library(tidyr)       # pivot_longer / wider
  library(patchwork)   # combining ggplots
})

# Global ggplot2 theme
theme_set(
  theme_classic(base_size = 12) +
    theme(
      plot.title = element_text(face = "bold", size = 13),
      plot.subtitle = element_text(colour = "grey40"),
      axis.line = element_line(colour = "grey60"),
      strip.background = element_blank(),
      strip.text = element_text(face = "bold")
    )
)

# bayesplot colour scheme
color_scheme_set("teal")

# Reproducibility
set.seed(2026)

# CmdStan options
# Suppress verbose Stan output in rendered documents
options(cmdstanr_verbose = FALSE)

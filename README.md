# Writing Statistical Models in Stan — Source

Quarto book source for *Writing Statistical Models in Stan: A Practical Handbook for Life Scientists*.

## Project layout

```
stan-handbook/
├── _quarto.yml          # Book configuration (structure, formats, execute options)
├── index.qmd            # Preface / landing page
├── references.bib       # BibTeX database
├── references.qmd       # References page (auto-populated by Quarto)
│
├── chapters/            # One .qmd per chapter
│   ├── 01-why-stan.qmd
│   ├── 02-setup.qmd
│   └── ...
│
├── appendices/          # Appendix .qmd files
│   ├── A-stan-reference.qmd
│   └── ...
│
├── R/
│   └── setup.R          # Shared setup: packages, theme, seeds
│
└── assets/
    ├── custom.scss      # HTML theme overrides
    ├── preamble.tex     # PDF / LaTeX extras
    ├── apa.csl          # Citation style (download separately)
    ├── img/             # Figures and cover image
    └── data/            # Shared datasets
```

## Prerequisites

```r
install.packages(c("cmdstanr", "posterior", "bayesplot", "loo",
                   "ggplot2", "dplyr", "tidyr", "patchwork"),
                 repos = c("https://mc-stan.org/r-packages/",
                           getOption("repos")))
cmdstanr::install_cmdstan()
```

## Rendering

```bash
# HTML (default)
quarto render

# Specific format
quarto render --to pdf
quarto render --to html

# Single chapter (fast iteration)
quarto render chapters/04-simple-linear-regression.qmd
```

## Citation style

Download `apa.csl` from <https://github.com/citation-style-language/styles>
and place it in `assets/apa.csl`, or replace with any other CSL file and
update `_quarto.yml` accordingly.

## Freezing computations

Stan models can be slow. Quarto's `freeze: auto` (set in `_quarto.yml`) means
chapters are only re-executed when their source changes. Delete `_freeze/` to
force a full rebuild.

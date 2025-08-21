## ----setup--------------------------------------------------------------------
library(fluxtools)

## -----------------------------------------------------------------------------
# tiny demo dataset with a few out-of-range values
set.seed(1)
df <- tibble::tibble(
  TIMESTAMP_START = seq.POSIXt(as.POSIXct("2024-01-01", tz = "UTC"),
                               length.out = 10, by = "30 min"),
  SWC_1_1_1 = c(10, 20, 150, NA, 0.5, 99, 101, 50, 80, -3),  # bad: 150, 101, -3; 0.5 triggers SWC unit note
  P         = c(0, 10, 60, NA, 51, 3, 0, 5, 100, -1),        # bad: 60, 51, 100, -1
  RH_1_1_1  = c(10, 110, 50, NA, 0, 100, -5, 101, 75, 30),   # bad: 110, -5, 101
  SWC_QC    = sample(0:2, 10, replace = TRUE)                # QC col should be ignored
)

# To see the Physical Boundary Module (PRM) rules:
get_prm_rules()

#Apply filter to all relevant variables
res <- apply_prm(df)

# PRM summary (counts and % replaced per column)
res$summary

# Only set range for SWC 
df_filtered_swc <- apply_prm(df, include = "SWC")

# Only set range for SWC + P 
df_filtered_swc_P <- apply_prm(df, include = c("SWC", "P"))


## ----prm-rules-table, echo=FALSE, message=FALSE-------------------------------
library(dplyr)
library(knitr)

rules_tbl <- get_prm_rules() |>
  transmute(
    Variable    = variable,
    Description = description,
    Units       = units,
    'Min to Max' = sprintf("%s to %s",
                           ifelse(is.na(min), "NA", min),
                           ifelse(is.na(max), "NA", max))
  ) |>
  arrange(Variable)

note_txt <- if (knitr::is_latex_output()) {
  "\\emph{Source: AmeriFlux Technical Documents}"
} else {
  "<em>Source: AmeriFlux Technical Documents</em>"
}

use_kableExtra <- requireNamespace("kableExtra", quietly = TRUE)
tbl <- fluxtools::get_prm_rules()
if (use_kableExtra) {
  kableExtra::kbl(tbl, booktabs = TRUE) |>
    kableExtra::kable_styling(full_width = FALSE)
} else {
  knitr::kable(tbl)
}


# kbl(rules_tbl,
#     caption = "Physical Range Module (PRM) bounds",
#     booktabs = TRUE, escape = FALSE) |>
#   kable_styling(full_width = FALSE, latex_options = c("threeparttable")) |>
#   footnote(general = note_txt, general_title = "", escape = FALSE)



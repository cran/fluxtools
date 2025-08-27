## ----setup--------------------------------------------------------------------
library(fluxtools)

## ----eval=FALSE---------------------------------------------------------------
# # Install from CRAN
# install.packages("fluxtools")
# 
# # Install from GitHub
# library(devtools)
# devtools::install_github("kesondrakey/fluxtools")
# 

## ----eval=FALSE---------------------------------------------------------------
# library(fluxtools)
# 
# # Run the app
# run_fluxtools()

## ----eval=FALSE---------------------------------------------------------------
#    df <- df %>%
#      mutate(
#        FC_1_1_1 = case_when(
#          TIMESTAMP_START == '202401261830' ~ NA_real_,
#          TIMESTAMP_START == '202401270530' ~ NA_real_,
#          …
#          TRUE ~ FC_1_1_1
#        )
#      )

## ----eval=FALSE---------------------------------------------------------------
#    df <- df %>%
#      mutate(
#        FC_1_1_1 = case_when(
#          TIMESTAMP_START == '202401261830' ~ NA_real_,
#          TIMESTAMP_START == '202401270530' ~ NA_real_,
#          …
#          TRUE ~ FC_1_1_1
#        )
#      )
# 
#    df <- df %>%
#      mutate(
#        SWC_1_1_1 = case_when(
#          TIMESTAMP_START == '202403261130' ~ NA_real_,
#          TIMESTAMP_START == '202403270800' ~ NA_real_,
#          …
#          TRUE ~ SWC_1_1_1
#        )
#      )

## ----eval=FALSE---------------------------------------------------------------
# # tiny demo dataset with a few out-of-range values
# set.seed(1)
# df <- tibble::tibble(
#   TIMESTAMP_START = seq.POSIXt(as.POSIXct("2024-01-01", tz = "UTC"),
#                                length.out = 10, by = "30 min"),
#   SWC_1_1_1 = c(10, 20, 150, NA, 0.5, 99, 101, 50, 80, -3),  # bad: 150, 101, -3; 0.5 triggers SWC unit note
#   P         = c(0, 10, 60, NA, 51, 3, 0, 5, 100, -1),        # bad: 60, 51, 100, -1
#   RH_1_1_1  = c(10, 110, 50, NA, 0, 100, -5, 101, 75, 30),   # bad: 110, -5, 101
#   SWC_QC    = sample(0:2, 10, replace = TRUE)                # QC col should be ignored
# )
# 
# # To see the Physical Boundary Module (PRM) rules:
# get_prm_rules()
# 
# #Apply filter to all relevant variables
# res <- apply_prm(df)
# 
# # PRM summary (counts and % replaced per column)
# res$summary
# 
# # Only set range for SWC
# df_filtered_swc <- apply_prm(df, include = "SWC")
# 
# # Only set range for SWC + P
# df_filtered_swc_P <- apply_prm(df, include = c("SWC", "P"))
# 

## ----prm_rules_table_final, echo=FALSE, message=FALSE, warning=FALSE, results='asis'----
# Force kable to emit HTML
old <- options(knitr.table.format = "html"); on.exit(options(old), add = TRUE)

tbl <- fluxtools::get_prm_rules()

# Drop the regex column that causes the | escaping mess
tbl <- tbl[, c("variable", "min", "max", "description", "units")]
names(tbl) <- c("Variable", "Min", "Max", "Description", "Units")

# Plain HTML table from knitr (no extra packages)
knitr::kable(tbl, format = "html", escape = TRUE)




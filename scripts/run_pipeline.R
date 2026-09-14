#!/usr/bin/env Rscript
# Intelpress Pipeline Runner - Rutas Normadas
suppressPackageStartupMessages({
  library(jsonlite)
})

cat("[INTELPRESS] Iniciando pipeline de procesamiento...\n")

json_path <- "data/processed/metricas_intelpress.json"
output_reports_dir <- "output/reports"
output_plots_dir <- "output/plots"
template_out <- "distribution/templates/executive_briefing.md"

dir.create(output_reports_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(output_plots_dir, showWarnings = FALSE, recursive = TRUE)
dir.create(dirname(template_out), showWarnings = FALSE, recursive = TRUE)

# 1. Ejecutar motor analítico
if (file.exists("scripts/analytics_engine.R")) {
  cat("[INTELPRESS] Ejecutando analytics_engine.R...\n")
  source("scripts/analytics_engine.R")
}

# 2. Ejecutar construccion de newsletter vía CLI con argumentos requeridos
if (file.exists("scripts/build_newsletter.R") && file.exists(json_path)) {
  cat("[INTELPRESS] Ejecutando build_newsletter.R con parametros normados...\n")
  system2("Rscript", args = c("scripts/build_newsletter.R", json_path, template_out))
} else {
  cat("[INTELPRESS] Aviso: No se hallo archivo de metricas o script newsletter.\n")
}

cat("[INTELPRESS] Pipeline finalizado con éxito.\n")

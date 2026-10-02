#!/usr/bin/env Rscript
# ==============================================================================
# Intelpress Pipeline Runner — v2 (Mini Lakehouse)
# ------------------------------------------------------------------------------
# Flujo:
#   data/raw/eclip/*.csv  ->  [analytics_engine.R]  ->  metricas_intelpress.json
#                                                     ->  plots/sov_medios.png
#                                                     ->  reports/briefing.md
# ==============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(jsonlite)
  library(lubridate)
})

cat("[INTELPRESS] Iniciando pipeline v2...\n")

# ------------------------------------------------------------------------------
# 0. Rutas
# ------------------------------------------------------------------------------
dir_bronze    <- "data/raw/eclip"
dir_processed <- "data/processed"
dir_plots     <- "output/plots"
dir_reports   <- "output/reports"

json_path    <- file.path(dir_processed, "metricas_intelpress.json")
plot_sov     <- file.path(dir_plots, "sov_medios.png")
briefing_out <- file.path(dir_reports, "briefing.md")

walk(c(dir_processed, dir_plots, dir_reports), dir.create,
     showWarnings = FALSE, recursive = TRUE)

# ------------------------------------------------------------------------------
# 1. Cargar engine de analítica
# ------------------------------------------------------------------------------
if (!file.exists("scripts/analytics_engine.R")) {
  stop("No existe scripts/analytics_engine.R")
}
source("scripts/analytics_engine.R")

# ------------------------------------------------------------------------------
# 2. Leer todos los CSVs de la capa Bronze
# ------------------------------------------------------------------------------
cat(sprintf("[PIPELINE] Buscando CSVs en %s...\n", dir_bronze))
csvs <- list.files(dir_bronze, pattern = "^noticias_.*\\.csv$", full.names = TRUE)

if (length(csvs) == 0) {
  stop(sprintf("No hay CSVs en %s. Corre Eclip primero.", dir_bronze))
}

cat(sprintf("[PIPELINE] Archivos encontrados: %d\n", length(csvs)))
for (f in basename(csvs)) cat(sprintf("           - %s\n", f))

# Cargar cada CSV con el engine y agregar campo source_file
df <- map_dfr(csvs, function(f) {
  cargar_datos_prensa(f) %>%
    mutate(source_file = basename(f))
})

cat(sprintf("[PIPELINE] Total de notas cargadas: %d\n", nrow(df)))

# ------------------------------------------------------------------------------
# 3. Calcular métricas
# ------------------------------------------------------------------------------
sov    <- calcular_sov_medios(df)
taxo   <- calcular_distribucion_taxonomia(df)
framing <- extraer_terminos_framing(df, top_n = 30)

# ------------------------------------------------------------------------------
# 4. Escribir JSON de métricas
# ------------------------------------------------------------------------------
metricas <- list(
  metadata = list(
    fecha_ejecucion = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
    total_notas     = nrow(df),
    total_archivos  = length(csvs),
    archivos        = basename(csvs),
    rango_inicio    = if (all(is.na(df$fecha_parsed))) NA_character_
                      else format(min(df$fecha_parsed, na.rm = TRUE), "%Y-%m-%d"),
    rango_fin       = if (all(is.na(df$fecha_parsed))) NA_character_
                      else format(max(df$fecha_parsed, na.rm = TRUE), "%Y-%m-%d")
  ),
  share_of_voice = sov,
  taxonomia      = taxo,
  framing        = framing
)

write_json(metricas, json_path,
           auto_unbox = TRUE, pretty = TRUE, dataframe = "rows")
cat(sprintf("[PIPELINE] JSON escrito: %s\n", json_path))

# ------------------------------------------------------------------------------
# 5. Generar gráfico de Share of Voice
# ------------------------------------------------------------------------------
if (nrow(sov) > 0) {
  generar_grafico_sov(sov, plot_sov)
  cat(sprintf("[PIPELINE] Gráfico SoV generado: %s\n", plot_sov))
}

# ------------------------------------------------------------------------------
# 6. Construir briefing en Markdown
# ------------------------------------------------------------------------------
if (file.exists("scripts/build_newsletter.R")) {
  cat("[PIPELINE] Construyendo briefing ejecutivo...\n")
  status <- system2("Rscript",
                    args = c("scripts/build_newsletter.R", json_path, briefing_out))
  if (status != 0) warning("build_newsletter.R terminó con código ", status)
  else cat(sprintf("[PIPELINE] Briefing generado: %s\n", briefing_out))
} else {
  cat("[PIPELINE] Aviso: scripts/build_newsletter.R no existe, saltando briefing.\n")
}

cat("[INTELPRESS] Pipeline completado.\n")

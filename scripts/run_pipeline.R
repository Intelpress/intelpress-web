#!/usr/bin/env Rscript
# ==============================================================================
# Intelpress — Pipeline Orchestrator CLI (Fase 2)
# Uso: Rscript scripts/run_pipeline.R <ruta_al_csv> [directorio_salida]
# ==============================================================================

suppressPackageStartupMessages({
  library(jsonlite)
})

# Cargar motor de analítica
source("scripts/analytics_engine.R")

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 1) {
  cat("Error: Debe proporcionar la ruta del archivo CSV de prensa.\n")
  cat("Uso: Rscript scripts/run_pipeline.R <ruta_al_csv> [directorio_salida]\n")
  quit(status = 1)
}

ruta_csv <- args[1]
dir_salida <- if (length(args) >= 2) args[2] else "."

if (!dir.exists(dir_salida)) {
  dir.create(dir_salida, recursive = TRUE)
}

cat("=== Intelpress Engine: Iniciando Pipeline ===\n")
cat(sprintf("-> Procesando dataset: %s\n", ruta_csv))

# 1. Ingesta
df <- cargar_datos_prensa(ruta_csv)
cat(sprintf("-> Notas procesadas correctamente: %d\n", nrow(df)))

# 2. Métricas Quant
sov <- calcular_sov_medios(df)
dist_tax <- calcular_distribucion_taxonomia(df)

# 3. Framing Analytics
terms_framing <- extraer_terminos_framing(df, top_n = 20)
cooc_tax <- extraer_coocurrencia_taxonomia(df, top_n_palabras = 5)

# 4. Generación de Artefactos Visuales
ruta_grafico_sov <- file.path(dir_salida, "sov_medios.png")
generar_grafico_sov(head(sov, 10), ruta_salida = ruta_grafico_sov)
cat(sprintf("-> Gráfico SoV generado: %s\n", ruta_grafico_sov))

# 5. Exportación JSON para consumo del Newsletter Builder / TUI
resultado_json <- list(
  metadata = list(
    fecha_ejecucion = as.character(Sys.time()),
    total_notas = nrow(df),
    fuente_csv = ruta_csv
  ),
  share_of_voice = sov,
  distribucion_taxonomia = dist_tax,
  framing_terminos = terms_framing,
  framing_coocurrencia = cooc_tax
)

ruta_json <- file.path(dir_salida, "metricas_intelpress.json")
write_json(resultado_json, path = ruta_json, pretty = TRUE, auto_unbox = TRUE)
cat(sprintf("-> Métricas JSON exportadas: %s\n", ruta_json))

cat("=== Pipeline Intelpress finalizado con éxito ===\n")

#!/usr/bin/env Rscript
# ==============================================================================
# Intelpress — Newsletter & Executive Briefing Builder (Fase 3)
# Uso: Rscript scripts/build_newsletter.R <ruta_json> <ruta_plantilla> <ruta_salida>
# ==============================================================================

suppressPackageStartupMessages({
  library(jsonlite)
  library(tidyverse)
  library(knitr)
})

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 3) {
  cat("Error: Argumentos insuficientes.\n")
  cat("Uso: Rscript scripts/build_newsletter.R <ruta_json> <ruta_plantilla> <ruta_salida>\n")
  quit(status = 1)
}

ruta_json <- args[1]
ruta_plantilla <- args[2]
ruta_salida <- args[3]

if (!file.exists(ruta_json)) stop(paste("No existe el archivo JSON:", ruta_json))
if (!file.exists(ruta_plantilla)) stop(paste("No existe la plantilla:", ruta_plantilla))

# 1. Cargar Datos y Métricas
datos <- read_json(ruta_json, simplifyVector = TRUE)
plantilla <- readLines(ruta_plantilla, warn = FALSE) %>% paste(collapse = "\n")

# 2. Formatear Tablas Markdown
tabla_taxonomia <- datos$distribucion_taxonomia %>%
  rename(Taxonomía = taxonomia, `Total Notas` = total_notas, `% Cobertura` = porcentaje) %>%
  kable(format = "markdown") %>%
  paste(collapse = "\n")

tabla_sov <- datos$share_of_voice %>%
  head(10) %>%
  rename(Medio = medio, `Total Notas` = total_notas, `% SoV` = porcentaje) %>%
  kable(format = "markdown") %>%
  paste(collapse = "\n")

tabla_framing_terms <- datos$framing_terminos %>%
  rename(Concepto = word, Frecuencia = frecuencia) %>%
  kable(format = "markdown") %>%
  paste(collapse = "\n")

tabla_framing_cooc <- datos$framing_coocurrencia %>%
  rename(Taxonomía = taxonomia, Término = word, Frecuencia = frecuencia) %>%
  kable(format = "markdown") %>%
  paste(collapse = "\n")

# 3. Inyección de Variables en Plantilla
briefing_renderizado <- plantilla %>%
  str_replace_all("\\{\\{FECHA_EJECUCION\\}\\}", datos$metadata$fecha_ejecucion) %>%
  str_replace_all("\\{\\{TOTAL_NOTAS\\}\\}", as.character(datos$metadata$total_notas)) %>%
  str_replace_all("\\{\\{FUENTE_CSV\\}\\}", datos$metadata$fuente_csv) %>%
  str_replace_all("\\{\\{TABLA_TAXONOMIA\\}\\}", tabla_taxonomia) %>%
  str_replace_all("\\{\\{TABLA_SOV\\}\\}", tabla_sov) %>%
  str_replace_all("\\{\\{TABLA_FRAMING_TERMINOS\\}\\}", tabla_framing_terms) %>%
  str_replace_all("\\{\\{TABLA_FRAMING_COOCURRENCIA\\}\\}", tabla_framing_cooc)

# 4. Exportar Briefing Final
writeLines(briefing_renderizado, con = ruta_salida)
cat(sprintf("-> Executive Briefing generado exitosamente en: %s\n", ruta_salida))

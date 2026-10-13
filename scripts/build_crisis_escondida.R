#!/usr/bin/env Rscript
# ==============================================================================
# Construye el dataset del evento "Accidente fatal en Minera Escondida"
# Período: 23-25 sep 2026
# ==============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(jsonlite)
})

source("scripts/analytics_engine.R")

cat("[CRISIS] Cargando capa Bronze...\n")

csvs <- c(
  "data/raw/eclip/noticias_2026-09-23.csv",
  "data/raw/eclip/noticias_2026-09-24.csv",
  "data/raw/eclip/noticias_2026-09-25.csv"
)

# Para el dashboard incluimos OK + PENDIENTE (las pendientes tienen
# cuerpo válido pero alguna alerta editorial; sirven para análisis).
leer_sin_filtro <- function(ruta) {
  read_csv(ruta, show_col_types = FALSE,
           col_types = cols(fecha = col_character(), .default = col_guess())) %>%
    mutate(
      fecha_parsed = suppressWarnings(as.Date(substr(coalesce(fecha, ""), 1, 10))),
      medio = coalesce(medio, "Desconocido"),
      taxonomia = coalesce(taxonomia, "SIN_TAXONOMIA"),
      titulo = coalesce(titulo, ""),
      bajada = coalesce(bajada, ""),
      cuerpo_completo = coalesce(cuerpo_completo, "")
    )
}

df <- map_dfr(csvs, leer_sin_filtro)
cat(sprintf("[CRISIS] Notas en el período: %d\n", nrow(df)))

# ------------------------------------------------------------------------------
# Filtro: notas del evento (Escondida + palabras clave del accidente)
# ------------------------------------------------------------------------------
crisis <- df %>%
  mutate(txt = paste(titulo, bajada, cuerpo_completo, sep = " ")) %>%
  filter(
    str_detect(txt, regex("escondida", ignore_case = TRUE)),
    str_detect(txt, regex(
      "accidente|fatal|muere|muerte|fallece|suspend|paraliz|retoma|reanud|sernageomin|sindicato",
      ignore_case = TRUE
    ))
  )

cat(sprintf("[CRISIS] Notas del evento: %d\n", nrow(crisis)))

# ------------------------------------------------------------------------------
# Clasificación por ángulo (priority-based)
# ------------------------------------------------------------------------------
clasificar <- function(titulo, bajada, cuerpo) {
  txt <- tolower(paste(titulo, bajada, substr(cuerpo, 1, 1500)))

  if (str_detect(txt, "sernageomin|investigaci|fiscaliz|contralor"))
    return("Regulatorio")
  if (str_detect(txt, "sindicato|trabajadores|gesti|cuestionan|piden"))
    return("Sindical")
  if (str_detect(txt, "retoma|reanud|reinicia|vuelve a operar"))
    return("Reanudación")
  if (str_detect(txt, "suspend|paraliz|detiene|detenid"))
    return("Paralización")
  if (str_detect(txt, "muere|muerte|fallece|fatal|accidente"))
    return("Hecho")
  return("Contexto")
}

crisis <- crisis %>%
  mutate(
    angulo = pmap_chr(list(titulo, bajada, cuerpo_completo), clasificar),
    fecha_dia = as.Date(fecha_parsed),
    titulo_corto = str_trunc(titulo, 80)
  ) %>%
  select(medio, fecha_dia, angulo, titulo, titulo_corto, url, taxonomia, status_scraping)

# ------------------------------------------------------------------------------
# Guardar
# ------------------------------------------------------------------------------
dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)

write_csv(crisis, "data/processed/crisis_escondida.csv")

resumen <- list(
  evento       = "Accidente fatal en Minera Escondida",
  rango_inicio = as.character(min(crisis$fecha_dia)),
  rango_fin    = as.character(max(crisis$fecha_dia)),
  total_notas  = nrow(crisis),
  por_dia      = crisis %>% count(fecha_dia, sort = TRUE),
  por_angulo   = crisis %>% count(angulo, sort = TRUE),
  por_medio    = crisis %>% count(medio, sort = TRUE)
)

write_json(resumen, "data/processed/crisis_escondida.json",
           auto_unbox = TRUE, pretty = TRUE, dataframe = "rows")

cat("\n=== RESUMEN ===\n")
print(resumen$por_dia)
cat("\n")
print(resumen$por_angulo)
cat("\n")
print(resumen$por_medio)
cat("\n[CRISIS] Dataset guardado en data/processed/crisis_escondida.csv\n")

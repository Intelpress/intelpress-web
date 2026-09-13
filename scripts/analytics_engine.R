# ==============================================================================
# Intelpress — Engine de Analitica & Media Intelligence
# Modulo: Engine Backend (Fase 2)
# ==============================================================================

suppressPackageStartupMessages({
  library(tidyverse)
  library(lubridate)
})

# 1. Ingesta y Validacion de Datos
# ------------------------------------------------------------------------------
cargar_datos_prensa <- function(ruta_csv) {
  if (!file.exists(ruta_csv)) {
    stop(paste("Error: El archivo no existe en la ruta especificada:", ruta_csv))
  }
  
  df <- read_csv(
    file = ruta_csv,
    col_types = cols(
      id = col_integer(),
      titulo = col_character(),
      bajada = col_character(),
      imagen_path = col_character(),
      url = col_character(),
      taxonomia = col_character(),
      medio = col_character(),
      autor = col_character(),
      fecha = col_character(),
      cuerpo_completo = col_character(),
      status_scraping = col_character()
    ),
    show_col_types = FALSE
  )
  
  # Tratamiento explicito de valores NA y parseo de fechas ISO 8601
  df_clean <- df %>%
    mutate(
      fecha_parsed = suppressWarnings(ymd_hms(fecha)),
      medio = coalesce(medio, "Desconocido"),
      taxonomia = coalesce(taxonomia, "SIN_TAXONOMIA"),
      titulo = coalesce(titulo, ""),
      bajada = coalesce(bajada, "")
    ) %>%
    filter(status_scraping == "OK" | is.na(status_scraping))
  
  return(df_clean)
}

# 2. Metricas: Share of Voice (SoV) por Medio
# ------------------------------------------------------------------------------
calcular_sov_medios <- function(df) {
  df %>%
    count(medio, sort = TRUE, name = "total_notas") %>%
    mutate(porcentaje = (total_notas / sum(total_notas)) * 100)
}

# 3. Metricas: Distribucion por Taxonomia (Bloques/Clientes)
# ------------------------------------------------------------------------------
calcular_distribucion_taxonomia <- function(df) {
  df %>%
    count(taxonomia, sort = TRUE, name = "total_notas") %>%
    mutate(porcentaje = (total_notas / sum(total_notas)) * 100)
}

# 4. Visualizacion: Tema Oficial Intelpress (ggplot2)
# ------------------------------------------------------------------------------
tema_intelpress <- function() {
  theme_minimal() +
    theme(
      plot.background = element_rect(fill = "#0d1117", color = NA),
      panel.background = element_rect(fill = "#161b22", color = NA),
      text = element_text(color = "#e6edf3"),
      axis.text = element_text(color = "#8b949e"),
      axis.title = element_text(color = "#e6edf3", face = "bold"),
      panel.grid.major = element_line(color = "#21262d"),
      panel.grid.minor = element_line(color = "#161b22"),
      plot.title = element_text(color = "#bc8cff", face = "bold", size = 14),
      plot.subtitle = element_text(color = "#8b949e", size = 10)
    )
}

# 5. Generacion de Grafico Vectorial de Share of Voice
# ------------------------------------------------------------------------------
generar_grafico_sov <- function(df_sov, ruta_salida = "sov_medios.png") {
  p <- ggplot(df_sov, aes(x = reorder(medio, total_notas), y = total_notas)) +
    geom_col(fill = "#a371f7", width = 0.7) +
    coord_flip() +
    labs(
      title = "Intelpress — Share of Voice por Medio",
      subtitle = "Volumen total de cobertura de prensa minada",
      x = "Medio / Fuente",
      y = "Cantidad de Notas"
    ) +
    tema_intelpress()
  
  ggsave(ruta_salida, plot = p, width = 8, height = 4.5, dpi = 300)
  return(ruta_salida)
}

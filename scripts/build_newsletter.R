#!/usr/bin/env Rscript
# ==============================================================================
# INTELPRESS — Executive Briefing Markdown Builder (Clean Markdown)
# Uso: Rscript scripts/build_newsletter.R <metrics.json> <output.md>
# ==============================================================================

suppressPackageStartupMessages({
  library(jsonlite)
})

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 2) {
  stop("Uso correcto: Rscript scripts/build_newsletter.R <metrics.json> <output.md>")
}

json_path <- args[1]
output_md <- args[2]

if (!file.exists(json_path)) {
  stop(paste("Error: El archivo JSON no existe:", json_path))
}

data <- jsonlite::fromJSON(json_path)

# Extracción segura de métricas desde el JSON del motor de analítica
fecha_str     <- ifelse(!is.null(data$metadata$fecha_ejecucion), substr(data$metadata$fecha_ejecucion, 1, 10), format(Sys.Date(), "%Y-%m-%d"))
total_notas   <- ifelse(!is.null(data$metadata$total_notas), data$metadata$total_notas, 0)

# Obtener medio principal del share of voice si existe
sov_df <- data$share_of_voice
if (!is.null(sov_df) && nrow(sov_df) > 0) {
  top_medio     <- sov_df$medio[1]
  pct_top_medio <- sov_df$porcentaje[1]
} else {
  top_medio     <- "N/A"
  pct_top_medio <- 0.0
}

md <- c()

# Cabecera limpia en Markdown
md <- c(md, sprintf("# ◆ INTELPRESS :: Reporte Ejecutivo de Prensa"))
md <- c(md, sprintf("*Fecha de Emisión: %s | Cobertura: Chile*\n", fecha_str))

md <- c(md, "---")
md <- c(md, "## 📊 Métricas Clave de la Jornada\n")
md <- c(md, sprintf("- **Menciones Totales:** %s", format(total_notas, big.mark = ",")))
md <- c(md, sprintf("- **Medio Principal:** %s (%.1f%% Share of Voice)", top_medio, pct_top_medio))
md <- c(md, "- **Estado de Procesamiento:** 100% Automatizado / Sovereign CLI\n")

md <- c(md, "## 🚨 Alerta de Framing Estratégico\n")
md <- c(md, sprintf("> Monitoreo automatizado finalizado para la jornada **%s**. La cobertura se mantiene liderada por **%s**, concentrando el **%.1f%%** del Share of Voice total.", fecha_str, top_medio, pct_top_medio))
md <- c(md, "\n")

md <- c(md, "## 📈 Desglose por Medio Principal\n")
md <- c(md, "| Medio | Volumen | Cobertura |")
md <- c(md, "| :--- | :---: | :---: |")

if (!is.null(sov_df) && nrow(sov_df) > 0) {
  for (i in 1:min(5, nrow(sov_df))) {
    m_row <- sov_df[i, ]
    md <- c(md, sprintf("| **%s** | %d | %.1f%% |", m_row$medio, m_row$total_notas, m_row$porcentaje))
  }
} else {
  md <- c(md, "| Sin datos | 0 | 0.0% |")
}

md <- c(md, "\n")

if (file.exists("sov_medios.png")) {
  md <- c(md, "## 🎨 Distribución de Share of Voice\n")
  md <- c(md, "![Share of Voice por Medio](./sov_medios.png)\n")
}

writeLines(md, output_md)
cat(paste("-> Executive Briefing generado exitosamente en:", output_md, "\n"))

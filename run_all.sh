#!/usr/bin/env bash
# ==============================================================================
# Intelpress — Orquestador Master de Inteligencia de Medios (Fase 3)
# Uso: ./run_all.sh <ruta_al_csv> [directorio_salida]
# ==============================================================================

set -e

if [ "$#" -lt 1 ]; then
    echo "Error: Debe proporcionar la ruta del archivo CSV de prensa."
    echo "Uso: ./run_all.sh <ruta_al_csv> [directorio_salida]"
    exit 1
fi

CSV_INPUT="$1"
OUT_DIR="${2:-.}"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

echo "======================================================================"
echo "           INTELPRESS — MEDIA INTELLIGENCE ENGINE                     "
echo "======================================================================"

# 1. Ejecutar Engine Analítico y Generación de JSON/Imágenes
Rscript scripts/run_pipeline.R "$CSV_INPUT" "$OUT_DIR"

# 2. Ensamblar Informe Ejecutivo en Markdown
JSON_METRICAS="$OUT_DIR/metricas_intelpress.json"
PLANTILLA="templates/executive_briefing.md"
BRIEFING_OUT="$OUT_DIR/briefing_ejecutivo_${TIMESTAMP}.md"

Rscript scripts/build_newsletter.R "$JSON_METRICAS" "$PLANTILLA" "$BRIEFING_OUT"

echo "----------------------------------------------------------------------"
echo " Pipeline finalizado con éxito."
echo " Informe Markdown generado en: $BRIEFING_OUT"
echo "======================================================================"

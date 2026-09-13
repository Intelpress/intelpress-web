#!/usr/bin/env bash
# ==============================================================================
# INTELPRESS — Media Intelligence Engine (Pipeline Orchestrator)
# Uso: ./run_all.sh <ruta_al_csv>
# ==============================================================================

set -e

INPUT_CSV="${1:-""}"

if [ -z "$INPUT_CSV" ]; then
    echo "Error: Debes proporcionar la ruta al archivo CSV."
    echo "Uso: ./run_all.sh <ruta_al_csv>"
    exit 1
fi

if [ ! -f "$INPUT_CSV" ]; then
    echo "Error: El archivo '$INPUT_CSV' no existe."
    exit 1
fi

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUT_MD="./briefing_ejecutivo_${TIMESTAMP}.md"
OUT_HTML_DARK="./briefing_dark_${TIMESTAMP}.html"
OUT_HTML_LIGHT="./briefing_light_${TIMESTAMP}.html"
OUT_PNG="./briefing_whatsapp_${TIMESTAMP}.png"

echo "======================================================================"
echo "            INTELPRESS — MEDIA INTELLIGENCE ENGINE                   "
echo "======================================================================"

echo "=== 1. Procesando Datos Crudos (R/Analytics Engine) ==="
Rscript scripts/run_pipeline.R "$INPUT_CSV"

echo "=== 2. Generando Executive Briefing Markdown ==="
Rscript scripts/build_newsletter.R metricas_intelpress.json "$OUT_MD"

echo "=== 3. Compilando HTML Multiformato (Pandoc --self-contained) ==="
# Version Dark (Tokyo Night / Purple CLI Accent)
pandoc "$OUT_MD" \
    --self-contained \
    --standalone \
    --css=templates/style_tony_purple.css \
    -o "$OUT_HTML_DARK" \
    --metadata title="Intelpress Executive Briefing (Dark)"

# Version Light (Standard Reading)
pandoc "$OUT_MD" \
    --self-contained \
    --standalone \
    --css=templates/style_light.css \
    -o "$OUT_HTML_LIGHT" \
    --metadata title="Intelpress Executive Briefing (Light)"

echo "=== 4. Generando Captura PNG para Despacho Móvil (Brave Headless) ==="
brave-browser --headless --disable-gpu --screenshot="$OUT_PNG" --window-size=800,1600 "$OUT_HTML_DARK" 2>/dev/null

echo "----------------------------------------------------------------------"
echo " Pipeline finalizado con éxito."
echo " Archivos generados:"
echo "   - Markdown:   $OUT_MD"
echo "   - HTML Dark:  $OUT_HTML_DARK"
echo "   - HTML Light: $OUT_HTML_LIGHT"
echo "   - PNG Push:   $OUT_PNG"
echo "======================================================================"

#!/usr/bin/env bash
# Intelpress Master Orchestration Script
set -e

echo "[INTELPRESS] === Iniciando Proceso Global de Inteligencia ==="

# 1. Ejecutar pipeline de datos en R
if [ -f "scripts/run_pipeline.R" ]; then
  echo "[INTELPRESS] Ejecutando pipeline en R..."
  Rscript scripts/run_pipeline.R
else
  echo "[WARN] No se encontró scripts/run_pipeline.R, saltando paso R..."
fi

# 2. Renderizar sitio web estático con Quarto
echo "[INTELPRESS] Compilando sitio con Quarto..."
quarto render

echo "[INTELPRESS] === Proceso completado exitosamente ==="

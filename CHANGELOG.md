# Changelog — Intelpress Web

Todas las modificaciones notables de este proyecto serán documentadas en este archivo.
El formato está basado en [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased] - Fase 2: Motor de Analítica en R

### Por Hacer
- Implementar módulo de análisis de encuadre mediático (*framing*) y co-ocurrencia semántica por taxonomía.
- Crear script CLI ejecutable en R para consumo automatizado desde Bash (`Rscript scripts/run_pipeline.R`).
- Integrar exportación de métricas en formato JSON para consumo desde el frontend.

---

## [0.2.0] - 2026-09-13 - Fase 2: Motor de Analítica Base

### Añadido
- Creación de `scripts/analytics_engine.R` con soporte para tidyverse y lubridate.
- Implementación de `cargar_datos_prensa()` con validación estricta de tipos y manejo explícito de `NA`.
- Cálculo de métricas cuantitativas: Share of Voice (SoV) por medio y distribución por taxonomía.
- Tema visual personalizado `tema_intelpress()` para `ggplot2` bajo la paleta institucional (`#0d1117`, `#161b22`, `#a371f7`).
- Función de generación y exportación de gráficos de prensa en formato PNG de alta resolución.

---

## [0.1.0] - 2026-09-13 - Fase 1: Arquitectura y Contrato de Datos

### Añadido
- Inicialización del repositorio Git en `~/Intelpress/Intelpress-web/` con rama principal `main`.
- Creación de landing page base minimalista en `index.html`.
- Creación de `.gitignore` para excluir entornos virtuales, archivos temporales y datos sensibles.
- Inspección completa del historial de datos del motor E/clip (`rtfs_entrenamiento_procesado.csv` y `tags_eclip.txt`).
- Definición formal del **Contrato de Datos Oficial** para la ingesta de metadatos en R.
- Documentación de la taxonomía jerárquica de 3 niveles (Macro Grupos, Bloques/Clientes y Temáticas).
- Creación de la estructura de directorios (`scripts/`).

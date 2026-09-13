# Changelog — Intelpress Web

Todas las modificaciones notables de este proyecto serán documentadas en este archivo.
El formato está basado en [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased] - Fase 2: Motor de Analítica en R

### Por Hacer
- Crear script `scripts/analytics_engine.R` para la ingesta y parseo del CSV del motor E/clip.
- Implementar función de cálculo de Share of Voice (SoV) por medio y taxonomía.
- Configurar paleta de colores oficial de Intelpress (`#0d1117`, `#161b22`, `#a371f7`) en visualizaciones vectoriales con `ggplot2`.
- Integrar módulo de análisis de encuadre mediático (*framing*) y co-ocurrencia semántica.

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

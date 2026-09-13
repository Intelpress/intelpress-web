# Intelpress — Media Intelligence Engine

Engine local-first de analítica de medios, minería de texto y generación automatizada de informes de inteligencia estratégica (*Executive Briefings & Newsletters*) con enfoque **Ground News B2B**.

## Arquitectura de Entrega (Multi-Tier Intelligence)

1. **Nivel 1 — Curaduría Segmentada:** Filtrado de notas por sectores, gremios y taxonomías específicas de cada suscriptor.
2. **Nivel 2 — Métricas Base & Datos Duros:** Métricas automáticas de *Share of Voice* (SoV), volumen de cobertura y gráficos vectoriales integrados.
3. **Nivel 3 — Framing Analytics (Estilo Ground News B2B):** Análisis de encuadre semántico, co-ocurrencias por línea editorial, sesgo temático y tendencias comparativas históricas.

## Stack Tecnológico

* **Engine Analítico:** R (tidyverse, tidytext, ggplot2, lubridate)
* **Pipeline Orchestrator:** Bash CLI / Rscripts
* **Entorno:** Linux / Sovereignty First (Debian / MX Linux)
* **Formato de Salida:** Briefings sintéticos en Markdown / HTML / Quarto (vía Email, PDF o CLI)

## Estructura del Proyecto

```text
Intelpress-web/
├── scripts/
│   ├── analytics_engine.R   # Engine base de analítica, SoV y Framing Analytics
│   └── run_pipeline.R       # Executable CLI pipeline (Fase 2)
├── templates/               # Plantillas para Newsletters / Briefings
├── CHANGELOG.md             # Registro de cambios y thinking process
└── README.md                # Documentación general

# Changelog — Intelpress

Todas las notas notables de cambios y decisiones de arquitectura en este proyecto serán documentadas en este archivo.

## [0.3.0] - 2026-09-13 - Fase 3: Executive Briefing Builder & CLI Orchestration

### Decisiones de Arquitectura & Thinking Process
* **Renderizado Decoplado:** El motor de generación de reportes (`scripts/build_newsletter.R`) funciona de manera independiente al backend analítico, consumiendo directamente la especificación en `metricas_intelpress.json`.
* **Formato Agnóstico:** Se utiliza Markdown puro renderizado mediante `knitr::kable()` para permitir la salida directa en consola CLI, correo electrónico o conversión hacia HTML/PDF mediante Pandoc o Quarto.

### Añadido
* `templates/executive_briefing.md`: Plantilla base en Markdown estructurada bajo el modelo de entrega en 3 niveles (Curaduría, SoV y Framing Analytics).
* `scripts/build_newsletter.R`: Script en R encargado de inyectar los datos estructurados en la plantilla y formatear tablas en Markdown.
* `run_all.sh`: Script ejecutable máster en Bash que orquesta la analítica en R y la compilación del informe final con marcas de tiempo (*timestamps*).

---

## [0.2.0-framing] - 2026-09-13 - Fase 2: Backend Analytics Engine & CLI Pipeline
### Añadido
* `scripts/analytics_engine.R`: Soporte multilingüe en `obtener_stopwords_multilingue()`, extracción de términos de encuadre (`extraer_terminos_framing()`) y co-ocurrencia por taxonomía (`extraer_coocurrencia_taxonomia()`).
* `scripts/run_pipeline.R`: Script CLI ejecutable para automatización de la analítica cuantitativa/cualitativa y exportación de `metricas_intelpress.json` y `sov_medios.png`.

---

## [0.2.0] - 2026-09-13
### Añadido
* `scripts/analytics_engine.R`: Ingesta robusta de CSV, parsing de fechas, cálculo de Share of Voice (SoV) y exportación de gráficos con `tema_intelpress()`.
* `.gitignore`: Regla para ignorar artefactos visuales temporales (`*.png`).

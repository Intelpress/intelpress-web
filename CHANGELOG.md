# Changelog — Intelpress

Todas las notas notables de cambios y decisiones de arquitectura en este proyecto serán documentadas en este archivo.

## [Unreleased] - Fase 3: Newsletter & Briefing Builder

### Por Hacer
- Crear motor de plantillas para newsletters ejecutivas en Markdown/Quarto.
- Implementar script CLI de renderizado y ensamblado del boletín B2B.
- Integrar la inserción dinámica de métricas JSON y gráficos SoV en las plantillas.

---

## [0.2.0-framing] - 2026-09-13 - Fase 2: Backend Analytics Engine & CLI Pipeline

### Decisiones de Arquitectura & Thinking Process
* **Pivote Estratégico de Interfaz:** Se descartó el desarrollo de un Dashboard UI tradicional en favor de un enfoque **Push Intelligence / Executive Newsletter B2B** (inspirado en la arquitectura de valor de Ground News).
* **Racionalidad:** El valor ejecutivo de Media Intelligence reside en la entrega sintética y directa en la bandeja de entrada o consola del cliente, combinando curaduría por sector + datos duros (SoV) + análisis de encuadre semántico (*Framing Analytics*).

### Añadido
* `scripts/analytics_engine.R`:
  * Soporte multilingüe en `obtener_stopwords_multilingue()` para filtrado de ruido en español e inglés.
  * Extracción de términos de encuadre semántico (`extraer_terminos_framing()`).
  * Análisis de co-ocurrencia semántica por taxonomía/cliente (`extraer_coocurrencia_taxonomia()`).
* `scripts/run_pipeline.R`:
  * Script CLI ejecutable para automatización de punta a punta.
  * Ingesta, cálculo de SoV, extracción de encuadre y exportación de `metricas_intelpress.json` y `sov_medios.png`.

---

## [0.2.0] - 2026-09-13
### Añadido
* `scripts/analytics_engine.R`: Ingesta robusta de CSV, parsing de fechas, cálculo de Share of Voice (SoV) por medio y por taxonomía, y función de exportación de gráficos con `tema_intelpress()`.
* `.gitignore`: Regla para ignorar artefactos visuales temporales (`*.png`).

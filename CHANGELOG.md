# Changelog — Intelpress

Todas las notas notables de cambios y decisiones de arquitectura en este proyecto serán documentadas en este archivo.

## [0.2.0-framing] - 2026-09-13

### Decisiones de Arquitectura & Thinking Process
* **Pivote Estratégico de Interfaz:** Se descartó el desarrollo de un Dashboard UI tradicional en favor de un enfoque **Push Intelligence / Executive Newsletter B2B** (inspirado en la arquitectura de valor de Ground News).
* **Racionalidad:** El valor ejecutivo de Media Intelligence reside en la entrega sintética y directa en la bandeja de entrada o consola del cliente, combinando curaduría por sector + datos duros (SoV) + análisis de encuadre semántico (*Framing Analytics*).

### Añadido
* **Framing Analytics en `scripts/analytics_engine.R`:**
  * `obtener_stopwords_es()`: Diccionario extendido de stop-words en español para minería de texto.
  * `extraer_terminos_framing()`: Extracción de n-gramas y términos clave por relevancia.
  * `extraer_coocurrencia_taxonomia()`: Análisis de co-ocurrencia semántica por sector o taxonomía de cliente.
* **Documentación:** Actualización de `README.md` reflejando la arquitectura de 3 niveles de boletines de inteligencia.

## [0.2.0] - 2026-09-13
### Añadido
* `scripts/analytics_engine.R`: Ingesta robusta de CSV, parsing de fechas, cálculo de Share of Voice (SoV) por medio y por taxonomía, y función de exportación de gráficos con `tema_intelpress()`.
* `.gitignore`: Regla para ignorar artefactos visuales temporales (`*.png`).

# Changelog — Intelpress

Todas las notas notables de cambios y decisiones de arquitectura en este proyecto serán documentadas en este archivo.

## [0.4.0] - 2026-09-13 - Fase 4: Multiformat Export & CLI Automation

### Decisiones de Arquitectura & Thinking Process
* **Independencia de Interfaz:** Separación estricta entre el motor industrial agnóstico (**Intelpress Engine**) y las capas relacionales o de consulta personalizada para clientes (**SOMA**).
* **Versatilidad Visual:** Soporte nativo de renderizado mediante Pandoc para hojas de estilo diferenciadas (`templates/style_dark.css` y `templates/style_light.css`), eliminando barreras de contraste para lectura diurna, nocturna o impresión.
* **Distribución Push Móvil:** Generación automatizada de capturas PNG de alta resolución mediante navegadores headless (`brave-browser`), facilitando el compartimiento directo en plataformas de mensajería (WhatsApp/Telegram).

### Añadido
* `templates/style_dark.css`: Hoja de estilo en modo oscuro basada en paleta ejecutiva CLI.
* `templates/style_light.css`: Hoja de estilo en modo claro optimizada para lectura tradicional e impresión.
* `run_all.sh`: Integración de compilación multiformato (MD, HTML Dark/Light, PNG) con marcas de tiempo deterministas.

---

## [0.3.0] - 2026-09-13 - Fase 3: Executive Briefing Builder & CLI Orchestration
### Añadido
* `templates/executive_briefing.md`: Plantilla base en Markdown estructurada en 3 niveles (Curaduría, SoV y Framing).
* `scripts/build_newsletter.R`: Motor de ensamblado e inyección de datos estructurados desde JSON a tablas Markdown.

---

## [0.2.0-framing] - 2026-09-13 - Fase 2: Backend Analytics Engine & CLI Pipeline
### Añadido
* `scripts/analytics_engine.R`: Analítica de encuadre semántico multilingüe y co-ocurrencia por taxonomía.
* `scripts/run_pipeline.R`: Script CLI para extracción determinista de métricas JSON y gráficos SoV.

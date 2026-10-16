---
titulo: "Memoria — Intelpress-web"
proyecto: intelpress-web
autor: "Arquitecto Web"
fecha: 2026-10-15
version_doc: 1
estado: activo
tags: [intelpress-web]
resumen: "Estado, decisiones y protocolos del portal de inteligencia de medios Intelpress — motor analítico R, sitio Quarto y dashboards."
ubicacion_git: "MEMORIA.md"
---

# Intelpress-web — Memoria del proyecto

Intelpress-web es el motor analítico y el portal público de
inteligencia de medios de Intelpress. Consume la capa Bronze que
produce E/clip (CSVs diarios de noticias estructuradas) y genera:
métricas agregadas (Share of Voice, taxonomía, framing), un briefing
ejecutivo diario, y dashboards analíticos publicados como sitio web.
Es una de las tres islas del archipiélago Intelpress.

## Línea de tiempo

- v0.1 (sep 2026): repositorio inicial. Sitio Quarto con aesthetic
  terminal (Tokyo Night, fuente monoespaciada). Plantilla de briefing
  y motor R básico (analytics_engine.R) con SoV por medio.
- v0.2 (sep 2026): rediseño web v1. Paleta sobria (azul marino +
  terracota), tipografía serif editorial, home con hero de dos
  columnas, navbar de 7 secciones, modo claro/oscuro.
- v0.3 (oct 2026): integración con capa Bronze. run_pipeline.R v2
  lee todos los CSVs de data/raw/eclip/ (symlink a
  ~/Intelpress/datos/bronze/), genera metricas_intelpress.json con
  metadata completa (rango de fechas, archivos, total de notas).
  Fechas en ISO 8601 en todo el pipeline.
- v0.4 (oct 2026): dashboard de crisis Escondida funcionando de punta
  a punta (E/clip → CSV → R → Quarto → HTML). 17 notas, 10 medios,
  4 ángulos editoriales.
- v0.5 (oct 2026): sitio publicado en GitHub Pages
  (intelpress.github.io/intelpress-web/). 10 páginas renderizadas.
  Dashboard Escondida accesible en /output/reports/.

## Decisiones (qué, quién, cuándo, porqué)

- **Quarto Website + output-dir docs** (Arquitecto Web, sep 2026).
  Método de publicación: render-to-docs (Quarto genera a docs/,
  GitHub Pages sirve desde ahí). Alternativa descartada: rama
  gh-pages vía quarto publish. Fundamento: simplicidad mental (un
  solo branch, sin migraciones de rama).
- **Versionar docs/** (Arquitecto Web, oct 2026). Cambio de decisión
  respecto a la configuración previa (que tenía /docs/ en .gitignore).
  Fundamento: el método render-to-docs requiere que docs/ esté en git;
  para un sitio de 7-8 páginas los diffs son manejables.
- **Bronze como dependencia, no como producción** (Arquitecto Web,
  oct 2026). run_pipeline.R lee los CSVs de ~/Intelpress/datos/bronze/
  vía symlink (data/raw/eclip → ~/Intelpress/datos/bronze). La isla no
  genera Bronze; lo consume. Contrato de datos: 11 campos (id, titulo,
  bajada, imagen_path, url, taxonomia, medio, autor, fecha,
  cuerpo_completo, status_scraping).
- **Filtrado de estados en el pipeline** (heredado de v0.2).
  cargar_datos_prensa() filtra status_scraping == "OK" por default.
  Para análisis que requieren las pendientes, se usa un lector sin
  filtro (leer_sin_filtro() en build_crisis_escondida.R).
- **Paleta visual** (Arquitecto Web, sep 2026). Azul marino profundo
  (#0f2a4a) + terracota (#b8632c) sobre fondo blanco cálido (#fafaf7).
  Sin relación con la paleta Tokyo Night de E/clip (regla transversal
  del archipiélago: solo se comparte el significado del color, no el
  tinte).
- **Tipografía** (Arquitecto Web, sep 2026). Serif editorial para
  titulares (Source Serif 4), sans humanista para cuerpo (Inter),
  monoespaciada solo para bloques de código (JetBrains Mono).
- **GitHub Pages por ahora, Posit Connect Cloud después** (Arquitecto
  Web, oct 2026). GitHub Pages es suficiente mientras el sitio sea
  estático. Migración a Posit Connect Cloud (capa gratuita) cuando se
  incorporen dashboards con cómputo dinámico o scheduling. Plan
  intermedio: Quarto Dashboards con Plotly (estático interactivo).
- **Post-render para datos dinámicos en el home** (Arquitecto Web,
  oct 2026, diseñado sin implementar). El home tiene datos
  hardcodeados. Plan: script de post-render que lea
  metricas_intelpress.json y actualice el HTML generado. Método
  descartado: include de fragmentos HTML generados por R (no es el
  uso canónico de Quarto).

## Estado de obra (2026-10-15)

- HEAD: commit 5bebc87 (último push a origin/main).
- 26 CSVs en ~/Intelpress/datos/bronze/ (consolidados + diarios).
- 342 notas procesadas por el pipeline (rango 2026-09-04 a 2026-10-12).
- Sitio renderizado: 10 páginas HTML en docs/.
- Dashboard Escondida publicado en docs/output/reports/.

## Pendientes

Tabla específica de esta isla. Las filas 1, 9, 12 y 14 de la lista
única del archipiélago (MEMORIA de E/clip) se resuelven acá.

| # | Pendiente | Estado | Esfuerzo |
|---|---|---|---|
| 1 | Hero/CTA/URL del dashboard Escondida | Diseñado, sin aplicar | 1 tarde |
| 2 | Conectar home a datos reales (post-render) | Diseñado, sin implementar | 1 tanda |
| 3 | MEMORIA de Intelpress-web (este documento) | CREADO 2026-10-15 | hecho |
| 4 | Push pendiente + styles.css (fila 9 archipiélago) | Sin congelar | 1 tanda |
| 5 | Cerrar sitio web Fase 2 (fila 14 archipiélago) | Sin fecha | 2-3 sesiones |
| 6 | Migrar dashboard a Quarto Dashboard + Plotly | Diseñado, sin aplicar | 1-2 sesiones |
| 7 | Informe de coyuntura minera de octubre 2026 | Diseñado, sin aplicar | 2 sesiones |
| 8 | Análisis de sentimiento entity-aware (vía SOMA) | Diseñado, sin aplicar | 1-2 sesiones |
| 9 | Migrar a Posit Connect Cloud | Planificado | cuando justifique |

Método (heredado del archipiélago): no se abren frentes nuevos hasta
cerrar los abiertos.

## Contratos de datos (esta isla como consumidora)

### Entrada: Bronze (producido por E/clip)

- **Ubicación**: ~/Intelpress/datos/bronze/noticias_YYYY-MM-DD.csv.
- **Acceso desde esta isla**: data/raw/eclip/ es un symlink a
  ~/Intelpress/datos/bronze/. Se configura una sola vez:
  mkdir -p data/raw && ln -sfn ~/Intelpress/datos/bronze data/raw/eclip.
- **Esquema** (11 campos, especificación completa en MEMORIA de
  E/clip): id, titulo, bajada, imagen_path, url, taxonomia, medio,
  autor, fecha (ISO 8601), cuerpo_completo, status_scraping (OK |
  PENDIENTE | DESCARTADA).
- **Frecuencia**: diaria (cuando E/clip procesa el turno del día).
- **Semántica**: taxonomia son acrónimos de entidades (ESCO, BHP,
  CEIM, etc.), no categorías temáticas. OK significa editada por
  humano; PENDIENTE significa que el editor no la revisó (pero el
  cuerpo puede estar completo).
- **Regla de oro**: E/clip nunca depende de esta isla (integración
  unidireccional). Si Bronze no tiene datos nuevos, el pipeline
  conserva lo último publicado.

### Salida: métricas y artefactos

- data/processed/metricas_intelpress.json — SoV, taxonomía, framing,
  metadata. Consumido por el sitio (pendiente: post-render).
- data/processed/crisis_*.csv — datasets de eventos específicos.
- output/plots/*.png — gráficos estáticos (temporales; migrarán a
  Plotly).
- output/reports/*.md — briefings y dashboards intermedios.
- docs/ — sitio HTML publicado.

## Lenguaje visual transversal del archipiélago (heredado)

- **Semántica funcional del color** (definida en E/clip): rojo =
  pendiente/inválido, verde = editada/válido, amarillo =
  alerta/sospechoso, tenue = descartado.
- **Regla de no importación**: cada isla mantiene su paleta propia.
  Intelpress-web usa azul marino + terracota; E/clip usa Tokyo Night.
  Lo compartido es el significado, no el tinte.
- **Accesibilidad**: modo claro/oscuro conmutable desde el navbar.
  Claro por defecto (comprador B2B lee en claro); oscuro como opción
  del sistema o preferencia manual.

## Protocolos del repo (heredados del archipiélago)

- Verificar contra el disco, nunca contra la memoria.
- Heredocs con comillas simples (<<'EOF') para escribir archivos con
  backticks, código o variables que deben quedar literales.
- Commit en cada estado validado; git status limpio después.
- Cirugía con greps de anclaje primero.
- Archivo dañado: git checkout -- <archivo>, nunca sed a ciegas.
- Cada cambio que importe: entrada en CHANGELOG.md antes del commit.
- Decisiones editoriales del dueño son ley; no tocar sin preguntar.
- Comentarios de código: claros y autocontenidos, sin jerga de sesión.

## Flujo de datos end-to-end

E/clip (ingesta diaria)
  -> ~/Intelpress/datos/bronze/noticias_YYYY-MM-DD.csv
    -> [symlink: data/raw/eclip/]
      -> Rscript scripts/run_pipeline.R
        -> data/processed/metricas_intelpress.json
        -> output/plots/sov_medios.png
        -> output/reports/briefing.md
      -> Rscript scripts/build_crisis_*.R (eventos específicos)
        -> data/processed/crisis_*.csv
        -> output/plots/crisis_*.png
      -> quarto render
        -> docs/*.html (sitio público)

## Herramientas del pipeline

- scripts/analytics_engine.R: librería de funciones (cargar_datos_prensa,
  calcular_sov_medios, framing, gráficos).
- scripts/build_newsletter.R: CLI que toma un JSON y produce un briefing
  en Markdown.
- scripts/run_pipeline.R: orquestador. Lee todos los CSVs de Bronze,
  calcula métricas, escribe JSON, genera gráfico y briefing.
- scripts/build_crisis_escondida.R: filtro y clasificación de un evento
  específico (Escondida, sep 2026). Incluye leer_sin_filtro() para no
  descartar pendientes.
- scripts/build_crisis_plots.R: genera los 3 PNG del dashboard
  (timeline, medios, ángulos).
- output/reports/crisis_escondida.qmd: dashboard Quarto con narrativa.

## El archipiélago (referencias cruzadas)

- **E/clip** (~/Intelpress/Eclip): generador de boletines. Es el
  productor de Bronze. Su MEMORIA.md documenta la especificación del
  contrato de datos y la lista única de pendientes del archipiélago.
- **SOMA** (~/proyectos/ds_soma-web + ~/vault/SOMA): agente de memoria.
  Consumidor futuro de Bronze y de metricas_intelpress.json para generar
  narrativa editorial. Su MEMORIA.md está pendiente.
- **Intelpress-web** (esta isla): consumidor de Bronze, productor del
  sitio y los dashboards.
- **Regla de integración**: unidireccional y opcional. E/clip produce y
  no le importa quién lee. SOMA consulta y nunca bloquea. Las islas
  comunican por contratos de datos, no por monorepo.

## Registro de cambios

- 2026-10-15 — Arquitecto Web — versión 1: documento inicial.
  Redactado tras verificación en disco (git log, run_pipeline.R,
  build_crisis_escondida.R, _quarto.yml, docs/). Estructura y lenguaje
  visual heredados de MEMORIA de E/clip v5. Cierra parcialmente la
  fila 12 del archipiélago (MEMORIA de Intelpress-web).

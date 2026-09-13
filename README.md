# Intelpress — Presencia Inteligente

> Media Intelligence, Data Analytics & Sovereign Data

---

## 📌 Visión del Proyecto

Intelpress es un sistema B2B de inteligencia de medios y analítica de encuadre (*framing analytics*) construido bajo arquitectura **Local-First / Sovereign Data**. Su objetivo es procesar grandes volúmenes de metadatos de prensa mediante minería local en Python y rigurosidad cuantitativa en R, ofreciendo entregables efímeros (*Zero-UI / Headless Intelligence*) sin exponer datos sensibles a nubes de terceros.

---

## 🛠️ Stack Tecnológico

* **Entorno & Orquestación:** Linux CLI, Bash Shell.
* **Ingestión de Datos:** Python 3.11+ (Motor E/clip — Scraping, TUI, parseo HTML/RTF).
* **Backend Analítico:** R (`tidyverse`, `lubridate`, `ggplot2`, `tidytext`).
* **Frontend & Reportabilidad:** HTML5 minimalista, Quarto, GitHub Pages / Next.js.
* **Control de Versiones:** Git (Convenciones estricta de commits).

---

## 📋 Contrato de Datos Oficial (Entrada R)

El backend en R consume el archivo procesado por el motor E/clip (`rtfs_entrenamiento_procesado.csv` o JSON equivalente) estructurado bajo el siguiente esquema obligatorio:

| Campo | Tipo | Descripción | Regla de Validación / Handling |
| :--- | :--- | :--- | :--- |
| `id` | Integer | Identificador único de la nota | Obligatorio, no nulo |
| `titulo` | String | Titular de la noticia | Reemplazar `NA` por `""` |
| `bajada` | String | Subtítulo / Copete de la nota | Reemplazar `NA` por `""` |
| `imagen_path` | String | Ruta local de la imagen destacada | Opcional |
| `url` | String | Enlace fuente original | Formato URL válido |
| `taxonomia` | String | Código de taxonomía asignado | Reemplazar `NA` por `"SIN_TAXONOMIA"` |
| `medio` | String | Dominio / Fuente de comunicación | Reemplazar `NA` por `"Desconocido"` |
| `autor` | String | Periodista / Firma | Opcional |
| `fecha` | ISO 8601 | Timestamp de publicación (`YYYY-MM-DDTHH:MM:SS`) | Parseo estricto vía `lubridate::ymd_hms` |
| `cuerpo_completo` | String | Texto completo extraído | Opcional para NLP/Framing |
| `status_scraping` | String | Estado de extracción (`OK`, `HTTP_ERROR`, etc.) | Filtrar sólo registros `OK` o `NA` |

---

## 🏷️ Dominio & Taxonomía Jerárquica

El modelo de clasificación cualitativa organiza la información en tres niveles de análisis:

1. **Macro Grupos (`/ GR`):** Cobertura sectorial amplia (`MULTI SECTOR`, `ENERGIA`, `CONCESIONES`, `CONSULTORAS`, `COMERCIO`, `AGRO-FORESTAL-PECUARIO`).
2. **Bloques / Clientes (`/ BL`):** Entidades y actores corporativos monitoreados (`BHP`, `SQM`, `GLENCORE`, `TOYOTA`, `ARAUCO`, `SAAM`, `ACERA`, `RIO TINTO`, etc.).
3. **Sub-etiquetas / Temáticas:** Dimensiones analíticas cualitativas (`Recursos Hídricos`, `Comunidad`, `Electromovilidad`, `Litio`, `Negociación Colectiva`, `Descarbonización`, `Ley de Pesca`).

---

## 📜 Estándares y Protocolos de Trabajo

1. **Soberanía Local-First:** Ningún procesamiento analítico requiere apis de nube propietarias.
2. **Validación Estricta de Tipos:** Todo script de R o Python debe explicitar tipos de datos al cargar y manejar exhaustivamente valores faltantes (`NA`).
3. **Documentación Agnóstica:** Repositorio estructurado para ser interpretado sin ambigüedad por ingenieros, analistas y agentes IA.

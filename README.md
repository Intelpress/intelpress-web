# Intelpress — Presencia Inteligente

> Media Intelligence, Data Analytics & Sovereign Data

---

## 📌 Contexto de Proyecto

* **Proyecto:** Intelpress — Presencia Inteligente
* **Stack Tecnológico:** Linux CLI, Bash, R (tidyverse, ggplot2, tidytext), Quarto / HTML5 estático, GitHub Pages.
* **Filosofía:** Minimalismo funcional, Zero-UI / Headless Intelligence (referencias: Ground News + Benjamin Cowen), rigor en ciencia de datos, soberanía de información local-first.
* **Paleta Visual:** Fondo Azul Marino (#0d1117), Tarjetas (#161b22), Acentos Morado/Lavanda (#a371f7, #bc8cff).
* **Estado Actual:** Fase 1 completada (Entorno y Landing Page). Fase 2 en ejecución (Pipeline R & E/clip).

---

## 🛠️ Arquitectura & Principios

1. **Soberanía de Datos (Local-First):** Minería y procesamiento de datos ejecutados localmente sin enviar información sensible a nubes públicas.
2. **Inteligencia Efímera (Zero-UI):** Desuso de dashboards pesados y estáticos. Entregables directos en flujos de trabajo (minutas, newsletters, reportes vectorizados).
3. **Rigor Cuantitativo:** Auditoría semántica, encuadre mediático (framing) y cuota de voz respaldados por código reproducible en R.

---

## 📂 Estructura del Repositorio

~/Intelpress/Intelpress-web/
├── index.html       # Landing page (HTML5 / CSS minimalista)
├── README.md        # Documentación y contexto del proyecto
└── .gitignore       # Exclusiones de Git (.venv, archivos temporales)

---

## 🚀 Despliegue Local

Para inspeccionar la landing page en entorno de desarrollo local:

python3 -m http.server 8000
Visitar en navegador: http://localhost:8000

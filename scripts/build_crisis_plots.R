#!/usr/bin/env Rscript
# Genera los gráficos del dashboard de crisis Escondida
suppressPackageStartupMessages({
  library(tidyverse)
  library(scales)
})

crisis <- read_csv("data/processed/crisis_escondida.csv", show_col_types = FALSE) %>%
  mutate(fecha_dia = as.Date(fecha_dia))

dir.create("output/plots", showWarnings = FALSE, recursive = TRUE)

# Paleta Intelpress
color_primario <- "#0f2a4a"
color_acento   <- "#b8632c"

# --- Plot 1: Timeline por día y ángulo ---
p1 <- crisis %>%
  count(fecha_dia, angulo) %>%
  ggplot(aes(x = fecha_dia, y = n, fill = angulo)) +
  geom_col(width = 0.6) +
  scale_fill_manual(values = c(
    "Regulatorio" = color_primario,
    "Sindical"    = color_acento,
    "Paralización"= "#7a7a85",
    "Contexto"    = "#c0c0c0"
  )) +
  scale_x_date(date_labels = "%d-%b", date_breaks = "1 day") +
  labs(
    title = "Evolución del evento por día",
    subtitle = "Notas por ángulo editorial",
    x = NULL, y = "Notas", fill = NULL
  ) +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "bottom",
    plot.title = element_text(face = "bold", color = color_primario),
    panel.grid.minor = element_blank()
  )

ggsave("output/plots/crisis_timeline.png", p1, width = 8, height = 4, dpi = 150)

# --- Plot 2: Medios que cubrieron el evento ---
p2 <- crisis %>%
  count(medio, sort = TRUE) %>%
  ggplot(aes(x = reorder(medio, n), y = n)) +
  geom_col(fill = color_primario, width = 0.7) +
  coord_flip() +
  geom_text(aes(label = n), hjust = -0.3, color = color_primario, size = 4) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(
    title = "Medios que cubrieron el evento",
    subtitle = "Total de notas por medio",
    x = NULL, y = "Notas"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", color = color_primario),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank()
  )

ggsave("output/plots/crisis_medios.png", p2, width = 8, height = 4.5, dpi = 150)

# --- Plot 3: Ángulos ---
p3 <- crisis %>%
  count(angulo, sort = TRUE) %>%
  ggplot(aes(x = reorder(angulo, n), y = n, fill = angulo)) +
  geom_col(width = 0.7, show.legend = FALSE) +
  scale_fill_manual(values = c(
    "Regulatorio" = color_primario,
    "Sindical"    = color_acento,
    "Paralización"= "#7a7a85",
    "Contexto"    = "#c0c0c0"
  )) +
  coord_flip() +
  geom_text(aes(label = n), hjust = -0.3, color = color_primario, size = 4) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(
    title = "Ángulos editoriales",
    subtitle = "Cómo se enmarcó el evento",
    x = NULL, y = "Notas"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", color = color_primario),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank()
  )

ggsave("output/plots/crisis_angulos.png", p3, width = 8, height = 3.5, dpi = 150)

cat("✓ 3 gráficos generados en output/plots/\n")

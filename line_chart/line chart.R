# Librerías
library(readxl)
library(dplyr)
library(ggplot2)

# Configuración
archivo_excel <- "SAG_solicitudes.xlsx"
archivo_salida <- "Grafico_SAG_Totales_Anuales.png"

# Cargar datos
anios_horizontal <- read_excel(archivo_excel, range = "B1:H1", col_names = FALSE)
totales_horizontal <- read_excel(archivo_excel, range = "B10:H10", col_names = FALSE)

# Transformar datos
df_sag <- data.frame(
  Año = as.numeric(t(anios_horizontal)),
  Solicitudes = as.numeric(t(totales_horizontal))
) %>%
  filter(!is.na(Año), !is.na(Solicitudes))

# Identificar peak histórico
dato_peak <- df_sag %>%
  filter(Solicitudes == max(Solicitudes))

cat(
  paste0(
    "Peak detectado: ",
    dato_peak$Año,
    " con ",
    format(dato_peak$Solicitudes, big.mark = "."),
    " solicitudes.\n"
  )
)

# Generar gráfico
p_sag_final <- ggplot(df_sag, aes(x = Año, y = Solicitudes)) +
  geom_line(color = "#1f77b4", linewidth = 1.2, alpha = 0.8) +
  geom_point(color = "#1f77b4", size = 3.5) +
  geom_point(data = dato_peak, color = "#ff7f0e", size = 5) +
  geom_text(
    data = dato_peak,
    aes(label = format(Solicitudes, big.mark = ".")),
    vjust = -1.3,
    size = 3.8,
    fontface = "bold",
    color = "#d62728"
  ) +
  geom_text(
    data = df_sag %>% filter(Año != dato_peak$Año),
    aes(label = format(Solicitudes, big.mark = ".")),
    vjust = -1.4,
    size = 3.2,
    fontface = "bold",
    color = "gray20"
  ) +
  scale_x_continuous(
    breaks = seq(min(df_sag$Año), max(df_sag$Año), by = 1)
  ) +
  scale_y_continuous(
    labels = function(x) format(x, big.mark = ".", decimal.mark = ","),
    expand = expansion(mult = c(0.1, 0.25))
  ) +
  labs(
    title = "Evolución Cronológica de Solicitudes de Subdivisión Predial",
    subtitle = "Registro anual de trámites ingresados ante el Servicio Agrícola y Ganadero (SAG)",
    x = "Año de Ingreso",
    y = "Cantidad de Solicitudes (nº)",
    caption = "Fuente: Elaboración propia en base a registros de la Dirección Regional del Servicio Agrícola y Ganadero (SAG)."
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 13, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 10, face = "italic", hjust = 0.5, color = "gray30"),
    axis.title.x = element_text(margin = margin(t = 15), face = "bold", size = 10),
    axis.title.y = element_text(margin = margin(r = 15), face = "bold", size = 10),
    axis.text = element_text(size = 9, face = "bold"),
    panel.grid.minor = element_blank(),
    plot.margin = margin(20, 20, 20, 20)
  )

# Mostrar gráfico
print(p_sag_final)

# Exportar gráfico
ggsave(
  filename = archivo_salida,
  plot = p_sag_final,
  width = 10,
  height = 5,
  dpi = 300
)
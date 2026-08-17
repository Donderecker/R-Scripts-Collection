library(sf)
library(dplyr)
library(ggplot2)
library(scales)
library(patchwork) 
library(svglite) # Recomendado para una exportación limpia de SVG

# Establecer carpeta de trabajo
setwd("D:/maletin/UACH/tesis/Ciren_histo")

# ============================================================
# 1. PREPARACIÓN DE DATOS (Carga y Limpieza)
# ============================================================

# --- Datos 2018 ---
ciren_2018 <- st_read("CIREN_2018.gpkg", quiet = TRUE)
ciren_2018_menor1    <- ciren_2018 %>% filter(ha >= 0.03 & ha <= 1.0)
ciren_2018_menor_0.5 <- ciren_2018 %>% filter(ha >= 0.03 & ha <= 0.5)

# --- Datos 2025 (SII) ---
SII_2024 <- st_read("SII_2024.gpkg", quiet = TRUE)
SII_2024 <- st_transform(SII_2024, crs = 32718)
SII_2024$area_m2 <- st_area(SII_2024)
SII_2024$ha <- as.numeric(SII_2024$area_m2) / 10000

SII_2024_menor_1.0 <- SII_2024 %>% filter(ha >= 0.03 & ha <= 1.0)
SII_2024_menor_0.5 <- SII_2024 %>% filter(ha >= 0.03 & ha <= 0.5)

# ============================================================
# 2. FUNCIONES DE ESTILO Y ESCALA UNIFICADA
# ============================================================

fmt_comma <- function(x) format(x, decimal.mark = ",", scientific = FALSE)

# Sincronización total para la tesis
max_y_unificado <- 300 

tema_tesis <- theme_minimal() +
  theme(
    plot.title = element_text(size = 12, face = "plain", hjust = 0.5), # <- Corrección aquí (sin negrita)
    axis.title = element_text(size = 10),
    axis.text = element_text(size = 9),
    panel.grid.minor = element_blank()
  )

# ============================================================
# 3. GENERACIÓN DE GRÁFICOS: CASO ≤ 1.0 HA
# ============================================================

bin_w_1ha <- 0.02 

p1_2018 <- ggplot(ciren_2018_menor1, aes(x = ha)) +
  geom_histogram(binwidth = bin_w_1ha, color = "white", fill = "#1f77b4", alpha = 0.9, boundary = 0.03) +
  scale_y_continuous(limits = c(0, max_y_unificado), expand = c(0, 0)) +
  scale_x_continuous(labels = fmt_comma, breaks = seq(0, 1, 0.1), limits = c(0.03, 1)) +
  labs(title = "Distribución de áreas ≤ 1 ha (CIREN 2018)", 
       x = "Área (ha)", y = "Frecuencia (nº predios)") +
  tema_tesis

p1_2025 <- ggplot(SII_2024_menor_1.0, aes(x = ha)) +
  geom_histogram(binwidth = bin_w_1ha, color = "white", fill = "#ff7f0e", alpha = 0.9, boundary = 0.03) +
  scale_y_continuous(limits = c(0, max_y_unificado), expand = c(0, 0)) + 
  scale_x_continuous(labels = fmt_comma, breaks = seq(0, 1, 0.1), limits = c(0.03, 1)) +
  labs(title = "Distribución de áreas ≤ 1.0 ha (2025)", 
       x = "Área (ha)", y = "Frecuencia (nº predios)") +
  tema_tesis

print(p1_2018)
print(p1_2025)


# ============================================================
# 4. GENERACIÓN DE GRÁFICOS: CASO ≤ 0.5 HA
# ============================================================

bin_w_05ha <- 0.01

p2_2018 <- ggplot(ciren_2018_menor_0.5, aes(x = ha)) +
  geom_histogram(binwidth = bin_w_05ha, color = "white", fill = "#1f77b4", alpha = 0.9, boundary = 0.03) +
  scale_y_continuous(limits = c(0, max_y_unificado), expand = c(0, 0)) +
  scale_x_continuous(labels = fmt_comma, breaks = seq(0, 0.5, 0.1), limits = c(0.03, 0.5)) +
  labs(title = "Distribución de áreas ≤ 0.5 ha (CIREN 2018)", 
       x = "Área (ha)", y = "Frecuencia (nº predios)") +
  tema_tesis

p2_2025 <- ggplot(SII_2024_menor_0.5, aes(x = ha)) +
  geom_histogram(binwidth = bin_w_05ha, color = "white", fill = "#ff7f0e", alpha = 0.9, boundary = 0.03) +
  scale_y_continuous(limits = c(0, max_y_unificado), expand = c(0, 0)) +
  scale_x_continuous(labels = fmt_comma, breaks = seq(0, 0.5, 0.1), limits = c(0.03, 0.5)) +
  labs(title = "Distribución de áreas ≤ 0.5 ha (2025)", 
       x = "Área (ha)", y = "Frecuencia (nº predios)") +
  tema_tesis

print(p2_2018)
print(p2_2025)


# ============================================================
# 5. EXPORTACIÓN OPTIMIZADA A SVG (Opcional pero recomendado)
# ============================================================

# Combinar y guardar caso 1.0 ha (lado a lado)
panel_2018 <- p2_2018 + p1_2018
print(panel_2018)
ggsave("histogramas_2018.svg", plot = panel_1ha, width = 12, height = 4, device = "svg")

# Combinar y guardar caso 0.5 ha (lado a lado)
panel_2025 <- p2_2025 + p1_2025
print(panel_2025)
ggsave("histogramas_2025.svg", plot = panel_05ha, width = 12, height = 4, device = "svg")


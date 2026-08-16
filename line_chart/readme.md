# Gráfico de serie temporal: Solicitudes SAG

## Descripción

Este script genera un gráfico de líneas de serie temporal para representar la evolución anual de solicitudes registradas ante el Servicio Agrícola y Ganadero (SAG).

El gráfico permite visualizar la variación de las solicitudes a través del tiempo e identifica automáticamente el año con el mayor número de registros (el valor máximo de la serie).

![Ejemplo del gráfico](example.png)

---

## Requisitos

### Software
* R
* RStudio

### Librerías
* `readxl`: Lectura de archivos Excel.
* `dplyr`: Manipulación y transformación de datos.
* `ggplot2`: Generación y personalización del gráfico.

### Datos
Se utiliza un archivo Excel denominado `SAG_solicitudes.xlsx`. El script está diseñado para una estructura donde los años están en la fila 1 y los totales en la fila 10.

| Rango | Contenido |
| :--- | :--- |
| `B1:H1` | Años |
| `B10:H10` | Total de solicitudes |

---

## Uso del script

El archivo de datos debe encontrarse en la misma carpeta que el script, o se debe especificar la ruta correspondiente en la variable:

```r
archivo_excel <- "SAG_solicitudes.xlsx"
```

### Configurar rangos de datos

Si los años o los valores se encuentran en otras celdas del Excel, modifique los rangos utilizados en:

```r
# Definir rangos
anios_horizontal <- read_excel(
  archivo_excel,
  range = "B1:H1",
  col_names = FALSE
)

totales_horizontal <- read_excel(
  archivo_excel,
  range = "B10:H10",
  col_names = FALSE
)
```

Por ejemplo, si los años estuvieran en `C2:J2` y los valores en `C11:J11`:

```r
range = "C2:J2"
range = "C11:J11"
```

---

## Personalización del gráfico

### Etiquetas y títulos

Los textos principales se configuran directamente en la sección de etiquetas:

```r
title    = "Evolución Cronológica de Solicitudes de Subdivisión Predial"
subtitle = "Registro anual de trámites ingresados ante el Servicio Agrícola y Ganadero (SAG)"
x        = "Año de Ingreso"
y        = "Cantidad de Solicitudes (nº)"
caption  = "Fuente: Elaboración propia en base a registros de la Dirección Regional del Servicio Agrícola y Ganadero (SAG)."
```

### Estética y colores

* **Línea principal:** Ajuste el color, grosor (`linewidth`) y transparencia (`alpha`):
  ```r
  geom_line(
    color = "#1f77b4",
    linewidth = 1.2,
    alpha = 0.8
  )
  ```

* **Puntos de datos:** Modifique el color y tamaño de los puntos normales y del valor máximo:
  ```r
  # Puntos regulares
  geom_point(
    color = "#1f77b4",
    size = 3.5
  )

  # Punto máximo
  geom_point(
    data = dato_peak,
    color = "#ff7f0e",
    size = 5
  )
  ```

### Etiquetas de valores

El tamaño y estilo de las etiquetas numéricas sobre los puntos se controlan mediante:

```r
size = 3.2
fontface = "bold"
```

### Tema visual

El gráfico utiliza `theme_minimal()`. La configuración detallada de títulos, ejes, textos y márgenes se define dentro de `theme()`.

---

## Identificación automática del máximo

El script identifica automáticamente el año con mayor cantidad de solicitudes mediante:

```r
dato_peak <- df_sag %>%
  filter(Solicitudes == max(Solicitudes))
```

No es necesario indicar manualmente cuál es el año con mayor número de solicitudes. Si los datos cambian, el valor máximo se actualizará automáticamente al volver a ejecutar el script.

---

## Exportación del gráfico

El nombre del archivo de salida y sus dimensiones se establecen mediante:

```r
archivo_salida <- "Grafico_SAG_Totales_Anuales.png"

ggsave(
  filename = archivo_salida,
  plot = p_sag_final,
  width = 10,
  height = 5,
  dpi = 300
)
```

* `width`: Ancho de la imagen.
* `height`: Alto de la imagen.
* `dpi`: Resolución de la imagen (se recomienda mantener 300 dpi para documentos o publicaciones).

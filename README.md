# Análisis del vínculo entre el crimen y el precio de la tortilla en México

![Tortillas](https://mexiconewsdaily.com/wp-content/uploads/2019/06/tortillas-1.jpg)


## Introducción:
Este estudio se centra en explorar la relación entre el precio de la tortilla y la incidencia delictiva en México. Se utilizarán datos recopilados de más de 270,000 registros de precios de tortilla, abarcando diversas ciudades y establecimientos en todo el país. Asimismo, se empleará un conjunto de datos exhaustivo sobre incidentes criminales en México, obtenido de fuentes gubernamentales oficiales, para analizar patrones y tendencias relacionadas con la criminalidad en diferentes regiones.

El estudio de la relación entre el precio de la tortilla y la incidencia delictiva es crucial para comprender la dinámica económica y social en México. La tortilla es un alimento básico en la dieta de la población mexicana y sus fluctuaciones de precio pueden tener un impacto significativo en la estabilidad de las comunidades. Además, la seguridad pública juega un papel determinante en el desarrollo económico, ya que la presencia de altos índices delictivos puede afectar el progreso de las comunidades.

## Objetivo: 
Proporcionar información valiosa para la toma de decisiones en políticas públicas y estrategias empresariales que contribuyan al bienestar económico y social del país.

## Preguntas clave:
1. ¿Cuál es la variación de precios de la tortilla en relación con la incidencia delictiva en diferentes áreas geográficas de México?.
2. ¿Qué tipos de crímenes y en qué regiones existe una relación significativa entre el precio de la tortilla y la criminalidad?.

## Hipótesis
Hay una correlación significativa entre las variaciones en el precio de la tortilla y la incidencia delictiva en México. Se espera que períodos de aumentos bruscos en el precio de la tortilla coincidan con incrementos en la actividad criminal, especialmente en aquellas regiones donde el crimen organizado participa en el establecimiento de precios de la tortilla. Esta relación refleja la compleja interacción entre factores económicos y sociales en la dinámica delictiva del país.

Además, se anticipa que la seguridad pública juegue un papel crucial en mitigar los efectos negativos de estas fluctuaciones económicas en la estabilidad social y económica de las comunidades afectadas.


## Datasets

- **Tortilla prices**
  - [Enlace al dataset](https://www.kaggle.com/datasets/richave/tortilla-prices-in-mexico)
  - Descripción: Este conjunto de datos consiste en más de +270k registros de precios de tortillas del Sistema Nacional de Información e Integración de Mercados de México, el cual encuesta 53 ciudades, 384 tiendas familiares y 120 tiendas minoristas que venden "tortillas" en todo México.
  - Columnas:
    - State: State in Mexico where the city is located, all 32 states en Mexico are included in the dataset
    - City: Major cities in Mexico where prices are surveyed
    - Year: Year corresponding to observation
    - Month: Month corresponding to observation
    - Day: Day corresponding to observation
    - Store type: Type of store of the surveyed prices (can be Mom and Pop Sotre or Big Retail Store)
    - Price per kilogram: Estimate of the prices for the type of store, day and city surveyed
  
- **Mexican crime statistics**
  - [Enlace al dataset](https://www.kaggle.com/datasets/elanderos/official-crime-stats-mexico-2015-2023)
  - Descripción: Este conjunto de datos es una compilación de incidentes criminales reportados en todo México. Incluye registros detallados de diversas actividades criminales, ofreciendo información sobre patrones y tendencias delictivas en diferentes regiones.
  - Columnas:
    - year: The year when the crime was reported. This is a numeric field representing the calendar year (e.g., 2015).
    - entity_code: A numeric code representing a specific entity (state or region) within Mexico. Each number corresponds to a unique entity.
    - entity: The name of the Mexican state or region where the crime occurred. This is a textual field (e.g., Aguascalientes).
    - affected_legal_good: A categorical field describing the broad category of the legal good (i.e., personal or societal interest) affected by the crime.
    - type_of_crime: A categorical field indicating the general type of crime. This field is more specific than 'affected_legal_good' but less specific than 'subtype_of_crime'. Examples include 'Abduction', 'Sexual abuse', and 'Robbery'.
    - subtype_of_crime: A further categorization of the type of crime. This field provides more specific details within the general type of crime. Examples include 'Sexual Harassment', 'Simple Rape', and 'Home Burglary'.
    - modality: The specific nature or method of the crime. This field details how the crime was committed or any specific characteristic that differentiates it within its subtype. Examples include 'With violence', 'Without violence', 'Sexual Bullying'.
    - month: The month when the crime was reported. This is a textual field representing the month (e.g., January).
    - count: The number of reported incidents for the specific crime type, subtype, and modality in the given entity and month. This is a numeric field


## Limpieza de datos
[] Estandarización de los nombres de estados.

## Estructura del código:


## Gráficas e interpretación

## Hallazgos

## Conclusiones y recomendaciones

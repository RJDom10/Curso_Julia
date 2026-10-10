# Tarea 2: Ingesta y Perfilado de un Lago de Datos Transaccional

## Objetivo
Dominar la lectura masiva de datos en formatos columnares y CSV, así como ejecutar transformaciones y cálculos agregados usando `DataFrames.jl` aplicando el paradigma Split-Apply-Combine.

## Contexto de Negocio
Un corporativo multinacional consolida sus ventas en un Data Lake. Te solicitan extraer indicadores clave de rendimiento (KPIs) por sucursal y categoría para un reporte del consejo directivo.

## Preparación de Datos (Simulación)
Antes de analizar, escribe en tu script el siguiente código para simular la generación de datos y guardarlos localmente:

```julia
using DataFrames, CSV, Parquet2, Random
Random.seed!(42)
N = 500_000
df_origen = DataFrame(
    Sucursal = rand(["Norte", "Sur", "Centro", "Occidente"], N),
    Categoria = rand(["Electronica", "Muebles", "Ropa", "Alimentos"], N),
    Ventas = rand(N) .* 5000 .+ 100,
    Costo = rand(N) .* 3000 .+ 50
)
CSV.write("datos_brutos.csv", df_origen)
```

## Instrucciones Paso a Paso
1. **Lectura y Conversión:**
   - Mide el tiempo (`@time`) de lectura del archivo `datos_brutos.csv`.
   - Guarda el DataFrame en formato Parquet (`Parquet2.writefile("datos.parquet", df)`).
   - Lee el archivo `.parquet` y mide su tiempo. Documenta en comentarios la diferencia de tiempos.

2. **Transformación (Crear columnas):**
   - Agrega una nueva columna al DataFrame llamada `Margen_Utilidad` calculada como `Ventas - Costo`. (Usa `transform`).

3. **Agrupación y KPIs (Split-Apply-Combine):**
   - Agrupa los datos por `Sucursal` y `Categoria`.
   - Calcula:
     - Ventas totales (suma de ventas).
     - Promedio de Margen de Utilidad.
     - Número de transacciones (usando `nrow`).
   - Muestra por consola las 5 categorías con mayor venta total ordenando los datos.

## Entregables
El notebook o script `.jl` con el procesamiento paso a paso y los comentarios sobre la comparación Parquet vs CSV.

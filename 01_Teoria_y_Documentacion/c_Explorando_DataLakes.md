# Módulo C: Explorando Lagos de Datos (Data Lakes)

## 1. El Ecosistema de Datos Estructurados en Julia
La Ciencia de Datos moderna lidia con volúmenes masivos de datos distribuidos en Data Lakes y Data Warehouses. Julia posee un ecosistema de última generación para manipulación de tablas mediante el paquete `DataFrames.jl`.

Paquetes clave:
- `CSV.jl`: Lector y escritor de CSV ultrarrápido y multihilo.
- `Parquet2.jl` o `Arrow.jl`: Formatos columnares estándar de la industria (Hadoop, Spark).
- `DataFrames.jl`: Manipulación de datos en memoria equivalente a `pandas` (Python) o `dplyr` (R).

## 2. Lectura y Escritura en Lagos de Datos
El almacenamiento columnar (Arrow/Parquet) es esencial para Big Data, ya que permite la lectura fraccionada y un menor tamaño en disco gracias a la compresión avanzada.

```julia
using DataFrames, CSV, Arrow

# Leer un archivo CSV multihilo
df_csv = CSV.read("datos_ventas.csv", DataFrame)

# Guardar en formato moderno Arrow
Arrow.write("datos_ventas.arrow", df_csv)

# Cargar desde formato Arrow (muy rápido)
df_arrow = DataFrame(Arrow.Table("datos_ventas.arrow"))
```

## 3. Manipulación de Datos con DataFrames.jl
`DataFrames.jl` utiliza símbolos (`:nombre_columna`) o cadenas (`"nombre_columna"`) para referirse a columnas.

### a) Selección y Filtrado
```julia
# Seleccionar columnas
select(df, :ID_Cliente, :Monto)

# Filtrar filas (usando filter o indexación lógica)
filter(row -> row.Monto > 5000, df)
df[df.Monto .> 5000, :]
```

### b) Transformaciones (Crear nuevas columnas)
La función `transform` es la manera idiomática de añadir o modificar columnas:
```julia
transform(df, :Monto => (x -> x .* 1.16) => :Monto_Con_IVA)
```

## 4. Agrupamiento y Agregación (El Paradigma Split-Apply-Combine)
El análisis empresarial requiere frecuentemente agrupar transacciones y resumirlas (KPIs). En Julia esto se hace con `groupby` y `combine`.

```julia
# Supongamos un df con columnas :Region, :Categoria, :Ingresos

# 1. Agrupar (Split)
grupos_region = groupby(df, :Region)

# 2. Resumir (Combine)
kpis = combine(grupos_region,
    :Ingresos => sum => :Ingresos_Totales,
    :Ingresos => mean => :Ticket_Promedio,
    nrow => :Numero_Transacciones
)
```

## 5. Uniones de Tablas (Joins)
Conectar dimensiones y tablas de hechos:
```julia
# Left Join
innerjoin(tabla_ventas, catalogo_productos, on=:Producto_ID)
leftjoin(tabla_ventas, tabla_clientes, on=:Cliente_ID)
```

# %% [markdown]
# # Laboratorio 3: Explorando Data Lakes (DataFrames, CSV y Arrow)
# **Objetivo:** Aprender a ingerir datos masivos empresariales, manipularlos (creación, filtrado) y resumirlos utilizando operaciones del tipo SQL (Agrupamientos y Joins).

# %%
# Descomenta y ejecuta esta celda solo la primera vez para instalar los paquetes necesarios:
# import Pkg; Pkg.add(["DataFrames", "CSV", "Arrow", "Dates"])

using DataFrames, CSV, Arrow, Dates

# %% [markdown]
# ## 1. Creación e Inspección de un DataFrame
# Un DataFrame es la estructura fundamental del analista tabular (similar a una tabla de Excel o SQL).

# %%
# Vamos a crear una tabla de transacciones de un E-commerce
df_transacciones = DataFrame(
    Ticket_ID = 1001:1005,
    Cliente = ["C01", "C02", "C01", "C03", "C02"],
    Fecha = [Date(2024, 1, 15), Date(2024, 1, 16), Date(2024, 1, 18), Date(2024, 2, 2), Date(2024, 2, 5)],
    Categoria = ["Electrónica", "Hogar", "Moda", "Electrónica", "Juguetes"],
    Monto = [12000.50, 4500.00, 1200.00, 23000.00, 850.00]
)

println("Resumen de las primeras filas:")
first(df_transacciones, 3)

# %%
# Describir estadísticamente el DataFrame
describe(df_transacciones)

# %% [markdown]
# ## 2. Escritura y Lectura Masiva (CSV vs Almacenamiento Columnar Arrow)
# En un Data Lake rara vez leemos Excels; operamos con CSVs gigantes o formatos comprimidos eficientes (Arrow, Parquet).

# %%
# Guardar en CSV
CSV.write("transacciones_hist.csv", df_transacciones)

# Guardar en Arrow (Formato optimizado para analítica in-memory de Big Data)
Arrow.write("transacciones_hist.arrow", df_transacciones)

# Leer desde el archivo comprimido (Esta operación suele ser 10x a 50x más rápida que leer un CSV)
df_leido = DataFrame(Arrow.Table("transacciones_hist.arrow"))
println("Data cargada desde el lago columnar con ", nrow(df_leido), " registros.")

# %% [markdown]
# ## 3. Filtrado y Manipulación
# A diferencia de SQL, aquí filtramos usando vectores lógicos o la función `filter`.

# %%
# Seleccionar solo tickets mayores a $5,000
# El operador .> devuelve un vector booleano [true, false, ...] 
# que usamos para enmascarar las filas.
ventas_altas = df_transacciones[df_transacciones.Monto .> 5000.0, :]
println("Ventas altas:")
display(ventas_altas)

# Agregar una nueva columna de "Impuesto" aplicando un 16% al Monto
# La función transform nos permite crear o sobreescribir columnas
transform!(df_transacciones, :Monto => (m -> m .* 0.16) => :Impuesto)

# %% [markdown]
# ## 4. Paradigma Split-Apply-Combine (Agrupamientos)
# Agrupar datos por dimensiones de negocio y aplicar agregaciones.

# %%
# Queremos saber: ¿Cuánto gastó cada cliente en total y cuántos tickets tiene?
# 1. SPLIT (Dividir por Cliente)
grupos_cliente = groupby(df_transacciones, :Cliente)

# 2. APPLY & COMBINE (Calcular y consolidar)
kpi_clientes = combine(grupos_cliente,
    :Monto => sum => :Gasto_Total,
    nrow => :Num_Compras # nrow es una función especial que cuenta las filas del grupo
)

# Ordenar a los clientes VIP (mayor gasto) hasta arriba
sort!(kpi_clientes, :Gasto_Total, rev=true)
display(kpi_clientes)

# %% [markdown]
# ## 5. Joins (Cruces de Tablas)
# Vamos a enriquecer el KPI cruzándolo con un catálogo de clientes (Dimensión).

# %%
df_catalogo = DataFrame(
    Cliente = ["C01", "C02", "C03", "C04"],
    Segmento = ["Premium", "Regular", "Regular", "Premium"],
    Pais = ["México", "Colombia", "México", "Chile"]
)

# Hacemos un Left Join: Tomamos kpi_clientes y le pegamos País y Segmento
df_final = leftjoin(kpi_clientes, df_catalogo, on=:Cliente)
println("\nDashboard Final de KPIs Enriquecido:")
display(df_final)

# %% [markdown]
# ---
# **Ejercicio Rápido para el alumno:**
# 1. Genera un DataFrame sintético con 10,000 filas de ventas.
# 2. Extrae el "Mes" de la columna fecha y usa `groupby` y `combine` para determinar qué Mes generó mayores ingresos.

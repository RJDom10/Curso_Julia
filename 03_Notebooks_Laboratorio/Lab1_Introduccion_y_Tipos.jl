# %% [markdown]
# # Laboratorio 1: Introducción a Julia y Tipos Fundamentales
# **Objetivo:** Familiarizarse con la sintaxis básica, el sistema de tipos dinámico pero fuerte de Julia, estructuras de control y la medición inicial del rendimiento computacional.
#
# Para ejecutar cada celda en VS Code, ubica tu cursor en la celda y presiona `Shift + Enter`.

# %% [markdown]
# ## 1. El Problema de los Dos Lenguajes y el Rendimiento
# Julia nació para evitar que el código escrito de forma rápida y sencilla deba ser reescrito en C o Fortran para ganar velocidad. La macro `@time` nos permite comprobar esto empíricamente.

# %%
println("--- Benchmark Simple ---")
# Usamos una función para evitar el alcance global (Global Scope), lo cual es 
# la regla #1 de rendimiento en Julia.
function suma_masiva(n)
    total = 0.0
    for i in 1:n
        total += i
    end
    return total
end

# Ejecutamos una vez para que el compilador JIT (Just-In-Time) traduzca el código a lenguaje máquina.
suma_masiva(10) 

# Ahora medimos la ejecución real sobre 100 millones de ciclos
print("Tiempo para sumar 100 millones de números: ")
@time suma_masiva(100_000_000)

# %% [markdown]
# ## 2. Tipos de Datos Primitivos
# Aunque Julia es dinámico, podemos pedirle explícitamente el tipo de las variables con `typeof()`.

# %%
ingreso_mensual = 45000.50      # Float64 (Número decimal)
edad_cliente = 34               # Int64 (Número entero)
nombre_cliente = "Empresa XYZ"  # String (Cadena de texto)
cliente_activo = true           # Bool (Booleano)

println("Tipo de ingreso_mensual: ", typeof(ingreso_mensual))
println("Tipo de edad_cliente: ", typeof(edad_cliente))

# %% [markdown]
# ## 3. Estructuras de Datos y Colecciones
# En Ciencia de Datos, constantemente manejamos conjuntos de valores. Las principales estructuras base son los Arreglos (`Array`), Tuplas (`Tuple`) y Diccionarios (`Dict`).
# **Importante:** La indexación en Julia comienza en el índice 1, NO en el 0 como en Python.

# %%
# a) Arreglos (Vectores 1D) - Son mutables
tasas_interes = [0.05, 0.08, 0.12, 0.15]
tasas_interes[1] = 0.06 # Podemos modificar elementos
println("Tasas actualizadas: ", tasas_interes)

# b) Tuplas - Son inmutables (más rápidas, usadas para devolver múltiples valores)
coordenadas_sucursal = (19.4326, -99.1332)
# coordenadas_sucursal[1] = 20.0 # ¡Esto daría error!

# c) Diccionarios - Pares clave-valor
catalogo_productos = Dict(
    "LAPTOP" => 15000.0,
    "MOUSE" => 250.0,
    "MONITOR" => 4500.0
)
println("El precio del monitor es: $", catalogo_productos["MONITOR"])

# Añadir nuevo producto
catalogo_productos["TECLADO"] = 800.0

# %% [markdown]
# ## 4. Estructuras de Control de Flujo
# Los bucles y condicionales no usan llaves `{}` ni indentación obligatoria. Se cierran explícitamente con la palabra `end`.

# %%
# Condicional if-elseif-else
score_crediticio = 650

if score_crediticio >= 750
    println("Crédito Aprobado - Tasa Preferencial")
elseif score_crediticio >= 600
    println("Crédito Aprobado - Tasa Estándar")
else
    println("Crédito Rechazado")
end

# Bucle for
println("\nListado de Tasas:")
for (i, tasa) in enumerate(tasas_interes)
    println("Producto $i: Tasa del ", tasa * 100, "%")
end

# %% [markdown]
# ## 5. El Operador Ternario
# Muy usado en Julia para escribir condicionales en una sola línea (equivalente a un "if compacto").
# Sintaxis: `condicion ? valor_verdadero : valor_falso`

# %%
limite_credito = score_crediticio > 700 ? 50000.0 : 10000.0
println("Límite asignado: $", limite_credito)

# %% [markdown]
# ---
# **Ejercicio Rápido para el alumno:**
# 1. Crea un Diccionario que contenga 3 nombres de clientes como claves y sus saldos como valores.
# 2. Crea un bucle `for` que itere sobre el diccionario y si el saldo es mayor a 1000, imprima "Cliente VIP", de lo contrario "Cliente Regular".

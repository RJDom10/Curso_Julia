# %% [markdown]
# # Laboratorio 2: Constructores, Funciones y Despacho Múltiple
# **Objetivo:** Modelar problemas empresariales estructurando datos en `structs`, aplicando validaciones con constructores internos y explotando el corazón de Julia: el "Multiple Dispatch".

# %% [markdown]
# ## 1. Funciones en Julia
# Las funciones pueden definirse en un formato largo clásico o en formato corto de asignación.

# %%
# Formato compacto (ideal para fórmulas matemáticas o cálculos directos)
calcular_roi(inversion, retorno) = ((retorno - inversion) / inversion) * 100

# Formato de bloque con argumentos por defecto y keyword arguments (con nombre)
# Los argumentos después del punto y coma (;) deben nombrarse al llamar la función
function simular_prestamo(monto, plazo_meses; tasa_anual=0.15)
    tasa_mensual = tasa_anual / 12
    # Fórmula de cuota nivelada
    cuota = monto * (tasa_mensual * (1 + tasa_mensual)^plazo_meses) / ((1 + tasa_mensual)^plazo_meses - 1)
    return cuota
end

println("ROI de campaña publicitaria: ", calcular_roi(15000, 22000), "%")
println("Cuota de préstamo a 24 meses: $", round(simular_prestamo(50000, 24, tasa_anual=0.12), digits=2))

# %% [markdown]
# ## 2. Vectorización y Broadcasting (`.`)
# En lugar de escribir bucles `for` para aplicar funciones a cada elemento de un arreglo, Julia provee el operador punto `.`. Esto es crítico para operaciones de Ciencia de Datos rápidas.

# %%
precios_sin_iva = [100.0, 500.0, 1500.0, 30.0]

# El punto aplica la multiplicación a cada elemento individualmente
precios_con_iva = precios_sin_iva .* 1.16 
println("Precios con IVA: ", precios_con_iva)

# También aplica a llamadas a funciones
rois = calcular_roi.([1000, 2000], [1200, 1800]) # Operamos sobre dos arreglos simultáneamente
println("Múltiples ROIs: ", rois)

# %% [markdown]
# ## 3. Modelado de Negocios: Estructuras (Structs) e Invariantes
# Para asegurar la integridad de los datos, utilizamos constructores internos para rechazar la creación de objetos con datos inválidos.

# %%
struct EmpleadoVentas
    id::Int64
    nombre::String
    meta_mensual::Float64
    
    # Constructor interno
    function EmpleadoVentas(id, nombre, meta_mensual)
        # Invariantes (Reglas de negocio)
        if meta_mensual < 5000.0
            error("La meta mensual mínima permitida en la empresa es $5000")
        end
        if length(nombre) < 3
            error("El nombre debe tener al menos 3 caracteres")
        end
        # Si todo es correcto, construimos y retornamos el nuevo objeto
        new(id, nombre, meta_mensual)
    end
end

vendedor1 = EmpleadoVentas(101, "Carlos Pérez", 15000.0)
println("Empleado creado con éxito: ", vendedor1.nombre)

# Descomenta la siguiente línea para ver el error de validación
# vendedor_invalido = EmpleadoVentas(102, "Ana", 3000.0)

# %% [markdown]
# ## 4. Despacho Múltiple en Acción
# El Despacho Múltiple permite tener la misma función que se comporta diferente según los tipos concretos de los argumentos que le pasamos.
# Definiremos una jerarquía abstracta para categorizar el tipo de riesgo comercial.

# %%
# Definimos el tipo "padre" y sus "hijos" concretos
abstract type CategoriaRiesgo end

struct RiesgoBajo <: CategoriaRiesgo end
struct RiesgoMedio <: CategoriaRiesgo end
struct RiesgoAlto <: CategoriaRiesgo end

# Creamos métodos de la MISMA función "autorizar_credito" pero para tipos diferentes
function autorizar_credito(riesgo::RiesgoBajo, monto_solicitado::Float64)
    return monto_solicitado <= 500_000.0 ? "Aprobado Automáticamente" : "Requiere Firma de Director"
end

function autorizar_credito(riesgo::RiesgoMedio, monto_solicitado::Float64)
    return monto_solicitado <= 100_000.0 ? "Aprobado con Condiciones" : "Rechazado - Supera Límite Medio"
end

function autorizar_credito(riesgo::RiesgoAlto, monto_solicitado::Float64)
    return "Rechazado - Perfil No Elegible"
end

# Ejecutamos la función. Julia "despacha" automáticamente al código correcto
println("Cliente 1 (Bajo, \$200k): ", autorizar_credito(RiesgoBajo(), 200_000.0))
println("Cliente 2 (Alto, \$50k):  ", autorizar_credito(RiesgoAlto(), 50_000.0))
println("Cliente 3 (Medio, \$150k):", autorizar_credito(RiesgoMedio(), 150_000.0))

# %% [markdown]
# ---
# **Ejercicio Rápido para el alumno:**
# 1. Modifica la función `autorizar_credito` añadiendo un argumento posicional adicional: `saldo_garantia::Float64`.
# 2. Crea un nuevo método de `autorizar_credito` para `RiesgoAlto` que apruebe el crédito SOLO si el `saldo_garantia` es igual o mayor al `monto_solicitado`.

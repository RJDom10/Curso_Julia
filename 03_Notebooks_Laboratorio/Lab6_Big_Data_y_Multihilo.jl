# %% [markdown]
# # Laboratorio 6: Big Data de Alto Rendimiento Computacional (HPC)
# **Objetivo:** Escapar de los límites del procesamiento serial. Aprender a dividir cargas de trabajo analíticas a lo largo de todos los procesadores físicos de la computadora utilizando los paquetes nativos de Julia.

# %%
using Base.Threads
using Distributed

# %% [markdown]
# ## 1. Comprobando la Máquina
# Julia permite correr código en 1 hilo o en múltiples. Un hilo es una unidad de procesamiento en tu CPU.

# %%
println("Cantidad de hilos disponibles para esta sesión: ", nthreads())
# IMPORTANTE: Si ves '1', necesitas indicarle a tu editor o consola que despierte los hilos.
# En VS Code ve a File > Preferences > Settings, busca "Julia Num Threads" y pon la palabra "auto" o el número de núcleos que tiene tu computadora (e.g. 4 u 8). Luego reinicia el REPL de Julia.

# %% [markdown]
# ## 2. El Peligro del Código Serial (Cuello de botella)
# Imaginemos que trabajamos para un fondo de inversión y necesitamos simular 10 millones de escenarios de riesgo (Valor en Riesgo / Monte Carlo) calculando matemáticas pesadas.

# %%
function calculo_financiero_pesado(semilla)
    resultado = semilla
    # Bucle inútil diseñado únicamente para estresar el CPU
    for _ in 1:100
        resultado = sqrt(abs(resultado) + 1.0) * 1.0001
    end
    return resultado
end

arreglo_gigante = rand(Float64, 10_000_000)

println("--- Iniciando Procesamiento Serial ---")
function simular_serial(arr)
    respuestas = zeros(Float64, length(arr))
    for i in 1:length(arr)
        respuestas[i] = calculo_financiero_pesado(arr[i])
    end
    return respuestas
end

# Usamos macro @time. Tomará algunos segundos (dependiendo de tu CPU).
@time res_serial = simular_serial(arreglo_gigante);

# %% [markdown]
# ## 3. Paralelización Multihilo (@threads)
# Vamos a hacer EXACTAMENTE lo mismo, pero le diremos al compilador "¡Divide este bucle for entre todos los hilos que tengas!". Se logra con la mágica macro `@threads`.

# %%
println("\n--- Iniciando Procesamiento Paralelo Multihilo ---")
function simular_paralelo(arr)
    respuestas = zeros(Float64, length(arr))
    
    # La ÚNICA diferencia es esta macro:
    @threads for i in 1:length(arr)
        respuestas[i] = calculo_financiero_pesado(arr[i])
    end
    return respuestas
end

@time res_paralelo = simular_paralelo(arreglo_gigante);

# ¡Anota la diferencia de tiempos! El Speedup = Tiempo Serial / Tiempo Paralelo.

# %% [markdown]
# ## 4. Condiciones de Carrera (Race Conditions)
# El paralelismo es peligroso si dos hilos tratan de escribir en la misma variable al mismo tiempo. Observemos el desastre:

# %%
println("\n--- Demostración de Condición de Carrera ---")
contador_global = 0
@threads for i in 1:1_000_000
    global contador_global += 1
end

# ¡Debería ser 1,000,000! Pero casi siempre es un número mucho menor.
println("Contador final con race condition: ", contador_global)
println("Varios hilos leyeron el mismo número e intentaron sobreescribirlo a la vez perdiendo conteos.")

# Solución con Operaciones Atómicas (Bloqueos de microsegundos a nivel CPU):
contador_atomico = Atomic{Int64}(0)
@threads for i in 1:1_000_000
    atomic_add!(contador_atomico, 1)
end
println("Contador final Seguro (Atómico): ", contador_atomico[])

# %% [markdown]
# ## 5. Más Allá de Una Sola Computadora (`Distributed`)
# Cuando tu computadora no da abasto, Distributed permite mandar pedazos del trabajo a OTROS procesos de Julia, e incluso a OTROS servidores conectados en red.

# %%
# addprocs(2) # Agregaría 2 procesos "esclavos" adicionales (descomentar con cuidado).
println("Procesos activos en el clúster: ", nprocs())
# La función pmap (parallel map) tomaría una función y la distribuiría equitativamente en el clúster.

# %% [markdown]
# ---
# **¡Felicidades!** Has concluido el módulo y tienes el nivel técnico para ingerir datos masivos, evaluarlos estadísticamente, construir modelos predictivos y optimizar el cómputo.

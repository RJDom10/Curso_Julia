# Módulo F: Aplicaciones en Análisis de Big Data de Alto Rendimiento

## 1. El Desafío del Big Data en Ciencias de Datos
El Big Data no siempre significa petabytes en un clúster. A menudo significa datos que simplemente **no caben en la memoria RAM (Out-of-Core)** o que el procesamiento serial toma demasiadas horas.

Julia está diseñado de raíz para alto rendimiento computacional (HPC).

## 2. Multihilo (Multi-threading) vs Multiprocesamiento (Distributed)

### Multihilo (`Base.Threads`)
- Aprovecha los múltiples núcleos (cores) del CPU en una misma máquina física.
- Todos los hilos comparten la misma memoria RAM.
- **Riesgo:** Condiciones de carrera (Race conditions). Dos hilos tratando de escribir en la misma variable a la vez.

```julia
using Base.Threads

println("Iniciando procesamiento con \$(nthreads()) hilos.")

# Macro @threads paraleliza un bucle for
resultados = zeros(Float64, 10_000)
@threads for i in 1:10_000
    resultados[i] = log(i) + sqrt(i)
end
```
*Para activar los hilos, iniciar julia con: `julia --threads auto`*

### Multiprocesamiento (`Distributed`)
- Levanta múltiples procesos de Julia independientes (Workers).
- Cada worker tiene su propia memoria RAM (evita condiciones de carrera).
- Los workers pueden estar en la misma máquina o en diferentes servidores a través de la red (Clúster).

```julia
using Distributed
addprocs(4) # Agrega 4 procesos extra

@everywhere function tarea_pesada(x)
    return sum(rand(1000) .* x)
end

# pmap aplica la función a un arreglo distribuyendo el trabajo en el clúster
resultados = pmap(tarea_pesada, 1:1000)
```

## 3. Procesamiento Fuera de Memoria (Out-of-Core)
Cuando un DataFrame de 100GB no cabe en la RAM de 16GB:
1. **Iterar por Chunks:** Librerías como `CSV.jl` permiten leer y procesar bloques de datos de $N$ líneas a la vez.
2. **Archivos Mapeados a Memoria (Mmap):** Mapear archivos gigantes en el disco directamente a estructuras de arreglos en Julia como si estuvieran en memoria.
3. **Bases de Datos de Análisis Columnar:** Usar `DuckDB.jl` (Base de datos analítica empotrada) para hacer consultas SQL sobre archivos Parquet gigantes, y solo extraer en Julia el DataFrame agregado de 100MB.

## 4. Reglas de Oro de Optimización en Julia
- **Evitar variables globales:** Julia no puede optimizar bien variables que no tienen tipo constante. Las variables globales causan degradación masiva de rendimiento. Envolver todo código en funciones.
- **Tipos Concretos:** Estructuras como `Array{Any, 1}` son perjudiciales porque el compilador no sabe qué tipo esperar; usar `Array{Float64, 1}` es clave para el JIT.

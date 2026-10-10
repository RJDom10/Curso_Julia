# Práctica Integradora (15%): Análisis Multihilo de Alto Rendimiento

## Objetivo
Acelerar el cómputo de métricas analíticas complejas sobre datos masivos (Big Data) aprovechando la arquitectura multinúcleo del procesador utilizando Julia nativo.

## Contexto de Negocio
El área de riesgos te entrega un arreglo con la probabilidad de impago (Default) de 10,000,000 de tarjetas de crédito. Quieren calcular una métrica sintética de "Stress Test" por cada cuenta, que consiste en una simulación compleja (e.g., elevar probabilidades, aplicar logaritmos iterativos). Hacer esto en serie bloquea la máquina toda la mañana. 

## Instrucciones Paso a Paso
1. **Configuración de Entorno:**
   - Asegúrate de iniciar tu sesión de Julia indicando que use varios hilos. Si usas VS Code, ve a Settings -> Julia: Num Threads y pon `auto`. (Comprueba en consola ejecutando `using Base.Threads; nthreads()`).

2. **Generación de Datos de Riesgo:**
   ```julia
   probabilidades = rand(10_000_000) # Probabilidades aleatorias entre 0 y 1
   ```

3. **Función Analítica Compleja:**
   Diseña una función pesada que simule un estrés:
   ```julia
   function calculo_estres(p)
       val = p
       for _ in 1:50
           val = log(abs(val) + 1.1) ^ 1.05
       end
       return val
   end
   ```

4. **Procesamiento Serial (Un Hilo):**
   - Crea un arreglo de resultados en ceros (`zeros(10_000_000)`).
   - Haz un bucle `for` normal para llenar los resultados aplicando `calculo_estres`.
   - Mide su tiempo (`@time`).

5. **Procesamiento Paralelo (Multihilo):**
   - Recrea el mismo bucle pero esta vez con la macro `@threads` antes del `for`.
   - Mide su tiempo (`@time`).

6. **Cálculo de Aceleración (Speedup):**
   - Calcula el $Speedup = Tiempo_{Serial} / Tiempo_{Paralelo}$.
   - Redacta una conclusión técnica ejecutiva justificando el ahorro de costos en la nube (computación) al migrar este cálculo de Python/R estándar a Julia Paralelo.

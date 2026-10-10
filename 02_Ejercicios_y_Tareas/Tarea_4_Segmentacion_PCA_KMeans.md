# Tarea 4: Segmentación de Mercados con PCA y K-Means

## Objetivo
Aplicar aprendizaje no supervisado sobre variables comerciales para perfilar carteras de clientes y enfocar campañas de marketing.

## Contexto de Negocio
Tienes un listado de clientes de una plataforma E-Commerce. Posees datos numéricos continuos: Gasto Total, Frecuencia de Compra Mensual y Días desde la Última Compra. Debes separar la cartera en grupos lógicos (clusters).

## Instrucciones Paso a Paso
1. **Matriz de Features:**
   ```julia
   using Clustering, MultivariateStats, Statistics, Random
   Random.seed!(42)
   # 3 Variables x 200 Clientes
   # Para Clustering.jl, las filas son variables (features) y las columnas observaciones (clientes)
   X = randn(3, 200) 
   ```

2. **Reducción de Dimensionalidad (Opcional pero recomendado para graficar):**
   - Entrena un modelo PCA (`fit(PCA, X; maxoutdim=2)`) para reducir las 3 variables originales a solo 2 Componentes Principales.
   - Transforma tus datos originales (`predict(pca_model, X)`) obteniendo una matriz 2x200.

3. **Agrupamiento (K-Means):**
   - Aplica el algoritmo K-Means sobre tus datos bidimensionales con `k=3` (`kmeans(datos_pca, 3)`).
   - Extrae el arreglo de asignaciones de cluster (`modelo.assignments`).

4. **Visualización y Ficha:**
   - Investiga y utiliza el paquete `Plots.jl` para generar un *scatter plot* (gráfico de dispersión) donde el color de cada punto dependa de su cluster asignado.
   - Redacta brevemente a qué tipo de perfil comercial podría corresponder cada cluster.

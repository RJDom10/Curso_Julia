# Módulo E: Modelos de Aprendizaje Supervisado y No Supervisado

## 1. El Ecosistema `MLJ.jl`
En Python, `scikit-learn` unifica los algoritmos de Machine Learning. En Julia, la respuesta es **`MLJ.jl`** (Machine Learning in Julia). MLJ provee una interfaz unificada sobre decenas de librerías subyacentes.

Conceptos base de MLJ:
- **Modelos:** Estructuras que guardan los *hiperparámetros* del algoritmo (Ej: `max_depth` en un árbol).
- **Máquinas (`machine`):** Combina un *Modelo* con los *Datos* concretos a entrenar. Mantiene el estado del entrenamiento.
- **Acciones:** `fit!` (entrenar) y `predict` (predecir).

## 2. Aprendizaje No Supervisado
Tratamos con datos no etiquetados. El objetivo es encontrar estructura oculta.

### K-Means (Segmentación)
Usado para clusterizar clientes, agrupar productos, etc. Utilizaremos el paquete nativo `Clustering.jl`.
- **Objetivo:** Minimizar la inercia (distancia de los puntos al centroide de su cluster).
- **Hiperparámetro Clave:** $K$ (número de clusters). Se puede determinar mediante el *Método del Codo*.

```julia
using Clustering
# K-means requiere que los features estén en filas y muestras en columnas
X = [1.0 2.0 5.0; 1.5 2.5 5.5] # 2 features x 3 observaciones
modelo = kmeans(X, 2) # k=2
println(modelo.assignments) # A qué cluster pertenece cada muestra
```

### PCA (Análisis de Componentes Principales)
Usado para reducir la dimensionalidad eliminando variables altamente correlacionadas. Usamos `MultivariateStats.jl`.

## 3. Aprendizaje Supervisado
Contamos con una variable objetivo $y$ ("target") que queremos predecir a partir de una matriz de características $X$.

### Regresión vs Clasificación
- **Regresión:** Predice un valor continuo (e.g., Monto de fraude, precio de acción). 
  - *Modelos:* Regresión Lineal (`GLM.jl`), Árboles de Regresión.
- **Clasificación:** Predice una categoría discreta (e.g., Cliente Aprobado / Rechazado).
  - *Modelos:* Regresión Logística, Random Forest, Support Vector Machines.

### Ejemplo de flujo Supervisado con MLJ
```julia
using MLJ

# Cargar el algoritmo (modelo)
Tree = @load DecisionTreeClassifier pkg=DecisionTree
modelo_arbol = Tree(max_depth=5)

# X es un DataFrame de características, y es un vector categórico
mach = machine(modelo_arbol, X, y)

# Entrenar
fit!(mach)

# Predecir
y_hat = predict_mode(mach, X_test) # predict_mode para clasificaciones
```

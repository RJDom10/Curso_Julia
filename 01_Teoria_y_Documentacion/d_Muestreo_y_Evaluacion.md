# Módulo D: Métodos de Muestreo y Técnicas de Evaluación de Modelos

## 1. El Concepto de Muestreo en Machine Learning
En el análisis predictivo, no entrenamos los modelos con todos los datos disponibles. Es mandatorio separar los datos para evitar el **Sobreajuste (Overfitting)**.

Típicamente dividimos los datos en:
- **Conjunto de Entrenamiento (Train):** Usado para ajustar los parámetros del modelo (e.g., 70%-80%).
- **Conjunto de Prueba (Test / Hold-out):** Usado para medir el rendimiento del modelo en datos que nunca ha visto (e.g., 20%-30%).

## 2. Muestreo Aleatorio y Estratificado (`StatsBase.jl`)
En Julia usamos `Random` y `StatsBase`.

### Muestreo Aleatorio Simple
```julia
using StatsBase, Random
Random.seed!(1234) # Fijar semilla para reproducibilidad

total_filas = 1000
# Elegimos el 80% de los índices al azar sin reemplazo
indices_train = sample(1:total_filas, Int(0.8 * total_filas), replace=false)
indices_test = setdiff(1:total_filas, indices_train)
```

### Validación Cruzada (K-Fold Cross Validation)
En lugar de una sola partición, la Validación Cruzada particiona los datos en $K$ subconjuntos y entrena $K$ modelos, rotando el conjunto de prueba. Es fundamental cuando los conjuntos de datos son pequeños.

## 3. Métricas de Evaluación de Modelos de Clasificación
Al predecir etiquetas binarias (Ej: 1 = Cancelación, 0 = Renovación), las predicciones se resumen en una **Matriz de Confusión**.

- **Verdaderos Positivos (TP):** Predecimos Cancelación y realmente Canceló.
- **Verdaderos Negativos (TN):** Predecimos Renovación y realmente Renovó.
- **Falsos Positivos (FP - Error Tipo I):** Predecimos Cancelación, pero Renovó.
- **Falsos Negativos (FN - Error Tipo II):** Predecimos Renovación, pero Canceló (¡Usualmente el error más costoso en negocios!).

### Principales Fórmulas de Desempeño
1. **Accuracy (Exactitud):** $(TP + TN) / Total$ (Sensible a clases desbalanceadas).
2. **Precision (Precisión):** $TP / (TP + FP)$ (De todos los que predije que cancelarían, ¿cuántos realmente lo hicieron?).
3. **Recall (Exhaustividad o Sensibilidad):** $TP / (TP + FN)$ (De todos los que *realmente* cancelaron, ¿qué porcentaje logré detectar?).
4. **F1-Score:** Media armónica entre Precision y Recall. $2 * (Precision * Recall) / (Precision + Recall)$

En Julia, estas métricas pueden calcularse manualmente usando álgebra vectorial o usando paquetes como `MLJ.jl`.

## 4. Métricas de Evaluación para Regresión
Si predecimos números continuos (e.g., Pronóstico de Ventas):
- **MAE (Mean Absolute Error):** Promedio absoluto de las diferencias entre real y predicción. Fácil de interpretar (está en la misma unidad que la variable).
- **RMSE (Root Mean Squared Error):** Penaliza más fuerte los errores grandes (los eleva al cuadrado antes de promediar).
- **R² (Coeficiente de Determinación):** Indica la proporción de la varianza en la variable dependiente que es predecible a partir de la variable independiente.

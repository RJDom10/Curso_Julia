# Tarea 3: Modelo Predictivo de Abandono (Churn)

## Objetivo
Diseñar, entrenar y evaluar un pipeline de Machine Learning de clasificación usando el ecosistema `MLJ.jl`, validando cruces de negocio respecto a errores Tipo I y Tipo II.

## Contexto de Negocio
Una compañía de telecomunicaciones tiene una alta tasa de abandono de clientes (Churn). Necesitan identificar a tiempo quiénes son propensos a cancelar el servicio en el próximo mes para ofrecerles descuentos de retención.

## Instrucciones Paso a Paso

1. **Generación de Dataset:**
   Crea un dataframe con 5000 clientes simulando antigüedad (meses), cargo mensual (dólares) y llamadas de soporte.
   ```julia
   using DataFrames, Random
   Random.seed!(1)
   X_df = DataFrame(
       antiguedad = rand(1:60, 5000),
       cargo = rand(20.0:100.0, 5000),
       soporte = rand(0:10, 5000)
   )
   # Formula artificial de probabilidad de abandono
   prob = 1.0 ./ (1.0 .+ exp.(- (0.1 .* X_df.soporte .- 0.05 .* X_df.antiguedad)))
   y_target = categorical(rand(5000) .< prob) # true = Abandono
   ```

2. **Partición de Datos:**
   Usa MLJ (`using MLJ`) para realizar una partición (Hold-out) de 80% para entrenamiento y 20% para test.

3. **Entrenamiento (Fit):**
   - Carga un modelo Random Forest o un Árbol de decisión simple (`@load DecisionTreeClassifier pkg=DecisionTree`).
   - Crea la `machine` con los datos de entrenamiento y entrénala usando `fit!`.

4. **Evaluación (Predict y Métricas):**
   - Realiza predicciones sobre el conjunto de test.
   - Imprime la Matriz de Confusión (`ConfusionMatrix()(y_hat, y_test)`).
   - Calcula el Accuracy, Precision y Recall.

5. **Análisis de Negocio:**
   Añade un texto final argumentando: ¿Qué es peor para la empresa: un Falso Positivo (ofrecer descuento a un cliente que NO iba a irse) o un Falso Negativo (no ofrecer descuento a un cliente que se irá)? ¿En base a ello, qué métrica priorizarías, Precision o Recall?

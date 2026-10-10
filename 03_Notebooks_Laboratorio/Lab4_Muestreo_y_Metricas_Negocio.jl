# %% [markdown]
# # Laboratorio 4: Muestreo, Matrices de Confusión y Métricas de Negocio
# **Objetivo:** Preparar los datos metodológicamente para evitar el sobreajuste (overfitting) y comprender la interpretación económica de las métricas de un modelo clasificatorio.

# %%
using DataFrames, Random, StatsBase

# %% [markdown]
# ## 1. Creación del Dataset Simulado (Predicción de Fraude)
# Supongamos que evaluamos 2,000 transacciones. Solo el 5% son realmente un Fraude (Clase desbalanceada).

# %%
Random.seed!(1234)
N = 2000
# 1 = Fraude, 0 = Transacción Legítima
y_real = [rand() < 0.05 ? 1 : 0 for _ in 1:N] 
println("Transacciones Totales: ", length(y_real))
println("Fraudes Reales: ", sum(y_real))

# %% [markdown]
# ## 2. Muestreo Aleatorio (Partición Train / Test)
# Nunca evaluamos el modelo con los datos con los que lo entrenamos.

# %%
# Vamos a extraer los índices de los datos
todos_indices = collect(1:N)

# sample extrae una muestra al azar (sin reemplazo) del 80% de los datos
indices_entrenamiento = sample(todos_indices, Int(round(0.8 * N)), replace=false)

# setdiff se queda con la diferencia (el 20% restante que usaremos para Testing)
indices_prueba = setdiff(todos_indices, indices_entrenamiento)

println("Filas para entrenar (Train): ", length(indices_entrenamiento))
println("Filas para probar (Test): ", length(indices_prueba))

# %% [markdown]
# ## 3. Matrices de Confusión desde Cero
# Un modelo matemático arrojó sus predicciones para el conjunto de Test. Comparemos su predicción (`y_pred`) con la realidad (`y_test`).

# %%
# Datos de la partición de prueba
y_test = y_real[indices_prueba]

# Simulamos las predicciones del modelo (acierta muchas, pero se equivoca en algunas)
y_pred = copy(y_test)
# Inyectar algunos errores artificiales para el ejemplo:
for i in 1:length(y_pred)
    if rand() < 0.15 # 15% de las veces el modelo se confunde al azar
        y_pred[i] = 1 - y_pred[i]
    end
end

# Construcción manual de la matriz
TP = sum((y_test .== 1) .& (y_pred .== 1)) # Verdadero Positivo
TN = sum((y_test .== 0) .& (y_pred .== 0)) # Verdadero Negativo
FP = sum((y_test .== 0) .& (y_pred .== 1)) # Falso Positivo (Error Tipo I)
FN = sum((y_test .== 1) .& (y_pred .== 0)) # Falso Negativo (Error Tipo II)

println("--- MATRIZ DE CONFUSIÓN ---")
println("Predicción\\Realidad | Fraude (1) | Legítimo (0)")
println("     Predice Fraude |    $TP      |     $FP")
println("   Predice Legítimo |    $FN       |     $TN")

# %% [markdown]
# ## 4. Cálculo de Métricas y su Costo Financiero
# El "Accuracy" general no sirve en clases desbalanceadas (como el Fraude).

# %%
# 1. Accuracy (Precisión general): Total de aciertos / Total de casos
accuracy = (TP + TN) / (TP + TN + FP + FN)

# 2. Precision (Valor Predictivo Positivo): 
# Cuando el modelo grita "¡FRAUDE!", ¿cuántas veces realmente lo era?
# Un FP alto arruina la Precision (Bloqueas tarjetas a clientes buenos y se enojan).
precision = TP / (TP + FP)

# 3. Recall (Exhaustividad / Sensibilidad):
# De TODOS los fraudes que realmente hubo, ¿qué porcentaje atrapó mi modelo?
# Un FN alto arruina el Recall (Se te cuelan los hackers y pierdes dinero).
recall = TP / (TP + FN)

# 4. F1-Score: Media armónica que castiga desbalances extremos
f1_score = 2 * (precision * recall) / (precision + recall)

println("\n--- MÉTRICAS DEL MODELO ---")
println("Accuracy:  ", round(accuracy * 100, digits=2), "%")
println("Precision: ", round(precision * 100, digits=2), "%")
println("Recall:    ", round(recall * 100, digits=2), "%")
println("F1-Score:  ", round(f1_score * 100, digits=2), "%")

# %% [markdown]
# ---
# **Discusión de Negocio (Para responder):**
# En un banco donde cada Fraude cuesta \$100,000 USD, pero revisar falsas alarmas solo cuesta tiempo de los telefonistas (\$10 USD):
# ¿Qué métrica preferirías optimizar, el `Recall` o la `Precision`? ¿Por qué?

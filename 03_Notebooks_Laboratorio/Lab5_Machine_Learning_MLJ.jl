# %% [markdown]
# # Laboratorio 5: Ecosistema Machine Learning con MLJ.jl
# **Objetivo:** Orquestar algoritmos supervisados (Clasificación/Árboles) y no supervisados (Segmentación/K-Means) bajo una interfaz estandarizada y aplicarlos a problemas empresariales.

# %%
using MLJ, DataFrames, Random, Clustering, MultivariateStats

# %% [markdown]
# ## PARTE 1: APRENDIZAJE NO SUPERVISADO (Clustering de Clientes)
# No tenemos una "etiqueta" a predecir. Solo tenemos datos de comportamiento de clientes y queremos encontrar patrones o grupos de mercado.

# %%
# Simulamos datos numéricos de 300 clientes (2 Variables: Ticket Promedio, Visitas Mensuales)
Random.seed!(99)
# Grupo 1 (Bajo gasto, pocas visitas), Grupo 2 (Alto gasto, muchas visitas)
cluster_1 = randn(2, 150) .+ [10.0; 2.0]
cluster_2 = randn(2, 150) .+ [100.0; 15.0]

# La matriz debe ser (Características x Observaciones) para Clustering.jl
X_clientes = hcat(cluster_1, cluster_2)

# Ejecutamos K-Means pidiendo explícitamente 2 clusters (k=2)
modelo_kmeans = kmeans(X_clientes, 2)

println("Centroides encontrados (Los 'promedios' de cada perfil):")
display(modelo_kmeans.centers)

# Las asignaciones te dicen a qué grupo pertenece el cliente 1, el 2, etc.
# println(modelo_kmeans.assignments)

# %% [markdown]
# ## PARTE 2: APRENDIZAJE SUPERVISADO (Predicción de Retención con MLJ)
# Tenemos el historial (X) y SÍ sabemos qué pasó con el cliente (y). Entrenamos un modelo para que aprenda el patrón y prediga a los nuevos.

# %%
# 1. Carga de los Datos
X_df = DataFrame(
    Gasto_Promedio = rand(500:5000, 400),
    Quejas_Mensuales = rand(0:5, 400),
    Descuentos_Usados = rand(0:10, 400)
)
# Regla inventada: Si el cliente tuvo 3 o más quejas, es muy probable que Cancele ("Sí").
y_etiquetas = [q >= 3 ? "Cancela" : "Renueva" for q in X_df.Quejas_Mensuales]

# En MLJ es MANDATORIO coercionar la variable Y a tipo Categórico (Multiclass o OrderedFactor)
y_target = coerce(y_etiquetas, Multiclass)

# Particionamiento rápido (Entrenar 70%, Probar 30%)
train, test = partition(eachindex(y_target), 0.7, shuffle=true, rng=123)

# %% [markdown]
# ### Carga y Entrenamiento (El concepto de 'machine')
# MLJ envuelve los algoritmos en "máquinas" que almacenan el modelo, los datos y el estado del entrenamiento.

# %%
# a) Seleccionamos el algoritmo (Decision Tree Classifier)
Tree = @load DecisionTreeClassifier pkg=DecisionTree

# b) Instanciamos el modelo con hiperparámetros limitadores (para no sobreajustar)
arbol = Tree(max_depth=3)

# c) Vinculamos Modelo + Datos creando una "Machine"
maquina_arbol = machine(arbol, X_df[train, :], y_target[train])

# d) ¡Entrenamos!
fit!(maquina_arbol)

# %% [markdown]
# ### Predicción y Evaluación Rápida en MLJ
# Usamos `predict_mode` para que nos devuelva la clase contundente (Renueva/Cancela).

# %%
y_predichos = predict_mode(maquina_arbol, X_df[test, :])

# Evaluamos la exactitud cruzando con la realidad
exactitud = accuracy(y_predichos, y_target[test])
println("La exactitud del Árbol en datos nunca vistos es: ", round(exactitud * 100, 1), "%")

# Despliegue de matriz de confusión automatizada por MLJ
conf_matrix = ConfusionMatrix()(y_predichos, y_target[test])
display(conf_matrix)

# %% [markdown]
# ---
# **Ejercicio Rápido para el alumno:**
# 1. Cambia el parámetro `max_depth` a 15 y vuelve a correr la celda de entrenamiento.
# 2. ¿Mejoró o empeoró la exactitud en el conjunto de `test`? ¡Esto es el Sobreajuste (Overfitting) en acción!

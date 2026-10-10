# Programa de Especializacion: Julia para la Ciencia de Datos en Entornos de Negocio

Este repositorio contiene el material teorico, practico y evaluativo para el modulo "Julia para la Ciencia de Datos", disenado para formar profesionales en el analisis computacional de alto rendimiento, ingenieria de datos y modelos predictivos aplicados a la toma de decisiones empresariales.

---

## Descripcion General

El lenguaje de programacion Julia resuelve el dilema clasico de los dos lenguajes en la industria (la necesidad de prototipar en Python o R y reescribir en C, C++ o Java para produccion). Este programa proporciona una ruta de aprendizaje estructurada que abarca desde los fundamentos de tipado y despacho multiple, pasando por la manipulacion de lagos de datos (Data Lakes), hasta el modelado estadistico con Machine Learning y la computacion paralela en arquitecturas multinucleo (HPC).

---

## Estructura del Repositorio

El contenido esta organizado en modulos pedagogicos que facilitan el avance progresivo del estudiante:

```text
Curso_Julia_Negocios/
|-- .gitignore                             # Reglas de exclusion de Git (ignora solucionario y temporales)
|-- Project.toml                           # Definicion formal de dependencias y paquetes del entorno
|-- README.md                              # Documento principal del repositorio
|-- GUIA_INSTALACION_Y_EJECUCION.md        # Manual detallado de instalacion, configuracion y ejecucion
|
|-- 01_Teoria_y_Documentacion/             # Fundamentos conceptuales y arquitectura tecnica
|   |-- a_Descripcion_Lenguaje.md          # Sintaxis, ejecucion JIT y filosofia de Julia
|   |-- b_Constructores_y_Funciones.md     # Estructuras de datos, despacho multiple y tipado
|   |-- c_Explorando_DataLakes.md          # Formatos binarios (Arrow, Parquet) y DataFrames
|   |-- d_Muestreo_y_Evaluacion.md         # Estadistica descriptiva, remuestreo y bootstrap
|   |-- e_Modelos_Aprendizaje.md           # Flujo de Machine Learning con el framework MLJ
|   |-- f_BigData_AltoRendimiento.md       # Multiprocesamiento, hilos y optimizacion de memoria
|
|-- 02_Ejercicios_y_Tareas/                # Evaluaciones practicas basadas en casos de negocio
|   |-- Tarea_1_Constructores_y_Despacho.md# Modelado de carteras y perdida crediticia
|   |-- Tarea_2_Ingesta_DataLakes.md       # Limpieza, cruces y agregaciones en datos masivos
|   |-- Tarea_3_Modelos_Churn.md           # Prediccion de cancelacion de clientes con MLJ
|   |-- Tarea_4_Segmentacion_PCA_KMeans.md # Reduccion de dimensionalidad y clusterizacion
|   |-- Practica_Integradora_HPC.md        # Pipeline integral de riesgo financiero a gran escala
|
`-- 03_Notebooks_Laboratorio/              # Scripts interactivos con celdas de codigo (# %%)
    |-- Lab1_Introduccion_y_Tipos.jl       # Variables, control de flujo y despacho basico
    |-- Lab2_Constructores_y_Despacho_Multiple.jl # Structs parametricos y validaciones internas
    |-- Lab3_DataFrames_y_Lagos_Datos.jl   # Ingesta de CSV, Arrow, joins y transformaciones
    |-- Lab4_Muestreo_y_Metricas_Negocio.jl# Calculo de KPI financieros y simulacion Monte Carlo
    |-- Lab5_Machine_Learning_MLJ.jl       # Pipeline completo de entrenamiento y evaluacion
    `-- Lab6_Big_Data_y_Multihilo.jl       # Multithreading, exclusion mutua y BenchmarkTools
```

> **Nota para el Estudiante:** La carpeta de solucionarios docentes se encuentra excluida mediante `.gitignore` para salvaguardar el proceso de evaluacion formativa y sumativa.

---

## Requisitos Previos del Sistema

- **Sistema Operativo:** Windows 10/11 (64-bit), macOS 11+ o distribuciones Linux basadas en glibc 2.17+ (Ubuntu 20.04+, Debian 11+, Fedora 36+).
- **Julia:** Version 1.9 o superior (se recomienda la version 1.10 LTS o posterior).
- **Entorno de Desarrollo:** Visual Studio Code con la extension oficial de Julia.
- **Hardware Minimo Recomendado:** Procesador de 4 nucleos fisicos y 8 GB de memoria RAM.

---

## Inicio Rapido

### 1. Clonar el repositorio

```bash
git clone https://github.com/tu-usuario/Curso_Julia_Negocios.git
cd Curso_Julia_Negocios
```

### 2. Instanciar el entorno de paquetes

Inicie una sesion interactiva de Julia en el directorio raiz del proyecto:

```bash
julia --project=.
```

Dentro del REPL de Julia, ingrese al gestor de paquetes presionando la tecla `]` y ejecute el comando de instalacion y precompilacion:

```julia
pkg> instantiate
pkg> precompile
```

Para regresar al modo de ejecucion de codigo, presione la tecla de retroceso (`Backspace`).

### 3. Ejecucion de laboratorios

Los archivos ubicados en `03_Notebooks_Laboratorio/` estan formateados con el estandar de celdas interactivas (`# %%`). Puede abrirlos en Visual Studio Code y ejecutar cada celda de manera independiente mediante la combinacion de teclas `Shift + Enter`.

Para instrucciones detalladas sobre resolucion de problemas, configuracion de multihilo (`JULIA_NUM_THREADS`) y opciones avanzadas, consulte el archivo [GUIA_INSTALACION_Y_EJECUCION.md](file:///c:/Users/HP/Documents/Julia/Curso_Julia_Negocios/GUIA_INSTALACION_Y_EJECUCION.md).

---

## Metodologia Pedagogica

El curso se articula bajo el principio de aprendizaje constructivo aplicado a la resolucion de problemas:

1. **Fundamentacion Teorica:** Lectura analitica de los modulos en `01_Teoria_y_Documentacion/` para comprender la semantica del lenguaje y la gestion de recursos.
2. **Experimentacion en Laboratorio:** Ejecucion de los notebooks en `03_Notebooks_Laboratorio/`, permitiendo inspeccionar variables, estructuras en memoria y reportes de tiempo de ejecucion.
3. **Casos de Negocio Aplicados:** Desarrollo autonomo de las tareas en `02_Ejercicios_y_Tareas/`, donde el estudiante debe aplicar los patrones demostrados en contextos de banca, telecomunicaciones y analitica avanzada.

---

## Politica de Integridad Academica

El codigo desarrollado por el estudiante en las tareas debe ser de creacion propia. Se permite el uso de los notebooks de laboratorio como plantilla sintactica y estructural. La presentacion de entregables debe incluir los scripts fuente debidamente comentados y documentados.

# Módulo A: Descripción del Lenguaje Julia

## 1. Introducción y el Problema de los Dos Lenguajes
Históricamente, los científicos de datos y programadores científicos se enfrentaban al "Problema de los Dos Lenguajes" (*Two-Language Problem*):
- **Lenguajes de prototipado (Python, R, MATLAB):** Fáciles de escribir, interactivos, de alto nivel, pero lentos en ejecución debido a que son interpretados y dinámicamente tipados.
- **Lenguajes de alto rendimiento (C, C++, Fortran):** Extremadamente rápidos, pero difíciles de escribir, compilar y depurar, y carecen de interactividad.

Julia fue creado en el MIT en 2012 para resolver este problema. Su premisa es: "Caminar como Python, correr como C".

## 2. Características Principales
- **Compilación Just-In-Time (JIT):** Julia no es interpretado tradicionalmente. Utiliza LLVM (Low Level Virtual Machine) para compilar el código dinámicamente a lenguaje máquina nativo justo antes de ejecutarse. 
- **Tipado Dinámico pero Fuerte:** No necesitas declarar los tipos de variables, pero cada variable tiene un tipo concreto en ejecución, y no se permiten conversiones implícitas peligrosas.
- **Despacho Múltiple (Multiple Dispatch):** Es el paradigma central de Julia (a diferencia de la Orientación a Objetos). Las funciones se comportan diferente dependiendo de los tipos de *todos* sus argumentos.
- **Metaprogramación y Macros:** Julia es homoiocónico (el código es una estructura de datos de Julia). Macros como `@time`, `@threads` permiten transformar el código antes de su compilación.

## 3. Ecosistema y Gestor de Paquetes (`Pkg`)
Julia incluye un gestor de paquetes de clase mundial. Presionando `]` en el REPL entramos a la consola de Pkg:
```julia
(@v1.11) pkg> activate .
(MiProyecto) pkg> add DataFrames CSV
(MiProyecto) pkg> status
```
Los archivos `Project.toml` y `Manifest.toml` garantizan una **reproducibilidad exacta** del entorno en cualquier máquina del mundo.

## 4. Tipos de Datos Primitivos y Colecciones
```julia
x = 42          # Int64
y = 3.14159     # Float64
z = "Datos"     # String
b = true        # Bool

# Colecciones
arreglo = [1, 2, 3]               # Array{Int64,1}
diccionario = Dict("A" => 1)      # Dict{String, Int64}
tupla = (1, "Hola", 3.14)         # Tuple{Int64, String, Float64}
```
**Nota:** Julia usa indexación basada en 1 (el primer elemento de un arreglo es `A[1]`).

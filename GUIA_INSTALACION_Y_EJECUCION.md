# Manual de Instalacion, Configuracion y Ejecucion del Entorno

Este documento proporciona las directrices tecnicas para configurar de manera rigurosa y reproducible el entorno de desarrollo para el curso "Julia para la Ciencia de Datos en Entornos de Negocio".

---

## 1. Requisitos de Hardware y Sistema Operativo

- **Sistemas Operativos Compatibles:**
  - Microsoft Windows 10 / 11 (64 bits).
  - macOS Monterey (12.0) o superior (arquitecturas Apple Silicon M1/M2/M3 y procesadores Intel x86_64).
  - Linux (distribuciones compatibles con glibc 2.17+, tales como Ubuntu 20.04+, Debian 11+, RHEL 8+, Fedora 36+).
- **Procesador:** Minimo 2 nucleos fisicos (se recomiendan 4 nucleos o mas para aprovechar los modulos de computacion paralela).
- **Memoria RAM:** Minimo 8 GB (se recomiendan 16 GB para manipulacion de grandes volumenes de datos en memoria).
- **Espacio en Disco:** Minimo 5 GB libres para binarios de Julia, entornos virtuales y paquetes precompilados.

---

## 2. Instalacion del Interprete de Julia

Se requiere la version estable de Julia 1.9 o superior (se sugiere la serie 1.10 LTS o versiones actuales).

### Metodo 1: Instalacion mediante Juliaup (Recomendado)

Juliaup es el gestor oficial de versiones multiplataforma para Julia.

- **En Windows:**
  Abra una consola de PowerShell y ejecute:
  ```powershell
  winget install julia -s msstore
  ```
  O alternativamente:
  ```powershell
  curl -fsSL https://install.julialang.org | iex
  ```

- **En macOS o Linux:**
  Abra la terminal y ejecute:
  ```bash
  curl -fsSL https://install.julialang.org | sh
  ```

Siga las instrucciones en pantalla y reinicie la terminal al finalizar.

### Metodo 2: Instaladores Binarios Directos

Si no tiene privilegios para usar administradores de paquetes de sistema:
1. Ingrese a la pagina oficial de descargas: `https://julialang.org/downloads/`.
2. Descargue el instalador correspondiente a su arquitectura.
3. Asegurese de marcar la casilla "Add Julia to PATH" durante la instalacion en Windows.

### Verificacion de la Instalacion

Abra una nueva terminal o consola y ejecute:

```bash
julia --version
```

La salida esperada debe indicar una version igual o superior a `julia version 1.9.0`.

---

## 3. Configuracion de Visual Studio Code

### 3.1. Instalacion de la Extension Oficial

1. Abra Visual Studio Code.
2. Vaya al panel de extensiones mediante el atajo `Ctrl + Shift + X` (en macOS: `Cmd + Shift + X`).
3. Busque la extension identificada como `Julia` (publicada por `julialang`).
4. Haga clic en **Install**.

### 3.2. Configuracion de la Ruta del Ejecutable (Opcional)

Si Visual Studio Code no detecta automaticamente el interprete:
1. Abra la configuracion mediante `Ctrl + ,` (o `Cmd + ,`).
2. En la barra de busqueda escriba: `julia.executablePath`.
3. Especifique la ruta absoluta a su ejecutable de Julia:
   - Windows: `C:\Users\<Usuario>\AppData\Local\Programs\Julia-1.10.x\bin\julia.exe` (o la ruta provista por Juliaup).
   - macOS: `/Applications/Julia-1.10.app/Contents/Resources/julia/bin/julia` o `/Users/<Usuario>/.juliaup/bin/julia`.
   - Linux: `/usr/local/bin/julia` o `/home/<usuario>/.juliaup/bin/julia`.

---

## 4. Configuracion de Computacion Multihilo (Multithreading)

Para ejecutar correctamente los modulos de computacion de alto rendimiento (Laboratorio 6 y Tarea 4), Julia debe iniciarse con acceso a multiples hilos del procesador.

### 4.1. Configuracion Temporal por Linea de Comandos

Puede indicar a Julia que utilice todos los nucleos logicos disponibles usando el modificador `-t auto` o `--threads auto`:

```bash
julia -t auto
```

O especificando una cantidad exacta de hilos:

```bash
julia -t 4
```

### 4.2. Configuracion Permanente mediante Variable de Entorno

Para no requerir el modificador manual en cada sesion:

- **En Windows (PowerShell):**
  Para definirlo a nivel de usuario en el sistema:
  ```powershell
  [Environment]::SetEnvironmentVariable("JULIA_NUM_THREADS", "auto", "User")
  ```

- **En macOS y Linux:**
  Agregue la siguiente linea al final de su archivo de configuracion de shell (`~/.bashrc` o `~/.zshrc`):
  ```bash
  export JULIA_NUM_THREADS=auto
  ```
  Guarde el archivo y ejecute `source ~/.bashrc` o `source ~/.zshrc`.

- **En Visual Studio Code:**
  Abra la configuracion (`Ctrl + ,`), busque `julia.NumThreads` e ingrese el valor `auto`.

---

## 5. Activacion e Instanciacion del Entorno de Paquetes

Este repositorio cuenta con un archivo formal `Project.toml` que define las versiones y dependencias exactas requeridas para los analisis.

### Paso 1: Posicionarse en el Directorio del Curso

Abra la terminal del sistema o la terminal integrada de VS Code (`Ctrl + ñ` o `Ctrl + ~`) y confirme que se encuentra en la raiz del proyecto:

```bash
cd Curso_Julia_Negocios
```

### Paso 2: Iniciar Julia con el Entorno Activo

Ejecute Julia vinculando el entorno actual mediante el parametro `--project=.`:

```bash
julia --project=. -t auto
```

### Paso 3: Instanciar los Paquetes en el Gestor Pkg

Una vez dentro del REPL interactivo de Julia:
1. Presione la tecla corchete de cierre `]` para ingresar al modo de gestion de paquetes. El prompt cambiara de `julia>` a `(Curso_Julia_Negocios) pkg>`.
2. Ejecute el comando `instantiate`:
   ```julia
   (Curso_Julia_Negocios) pkg> instantiate
   ```
   Este comando descargara e instalara exactamente las versiones indicadas de `DataFrames`, `CSV`, `Arrow`, `MLJ`, `DecisionTree`, `Clustering`, `MultivariateStats`, entre otras.
3. Ejecute el comando de precompilacion para optimizar los tiempos de carga posteriores:
   ```julia
   (Curso_Julia_Negocios) pkg> precompile
   ```
4. Presione la tecla `Backspace` (retroceso) para regresar al prompt estandar de Julia: `julia>`.

---

## 6. Modalidades de Ejecucion de Codigo

### Modalidad A: Ejecucion Interactiva Celda por Celda en VS Code (Recomendada)

Los archivos en la carpeta `03_Notebooks_Laboratorio/` utilizan delimitadores de celdas interactivas `# %%`:

1. Abra cualquier laboratorio en VS Code (por ejemplo, `Lab1_Introduccion_y_Tipos.jl`).
2. Notara que sobre cada bloque `# %%` aparece la opcion visual interactiva `Run Cell`.
3. Situe el cursor dentro de la celda y presione `Shift + Enter`.
4. Se abrira la ventana interactiva de Julia a la derecha, evaluando el bloque de codigo y mostrando los graficos, tablas y metricas generadas de inmediato.

### Modalidad B: Ejecucion desde la Terminal (Scripts Completos)

Para ejecutar un laboratorio o una solucion de manera desatendida desde la linea de comandos:

```bash
julia --project=. -t auto 03_Notebooks_Laboratorio/Lab1_Introduccion_y_Tipos.jl
```

---

## 7. Script de Validacion del Entorno

Para verificar que todas las dependencias y la configuracion multihilo estan correctamente operativas, copie y pegue el siguiente bloque de validacion directamente en su consola de Julia:

```julia
using Pkg
Pkg.activate(".")

println("="^60)
println("REPORTE DE DIAGNOSTICO DEL ENTORNO")
println("="^60)

println("Version de Julia:       ", VERSION)
println("Hilos disponibles:      ", Threads.nthreads())
println("Directorio del entorno: ", Base.active_project())

paquetes_criticos = [
    :DataFrames,
    :CSV,
    :Arrow,
    :MLJ,
    :Clustering,
    :MultivariateStats,
    :BenchmarkTools
]

println("\nComprobando carga de dependencias:")
todos_correctos = true

for pkg in paquetes_criticos
    try
        eval(:(using $pkg))
        println("  [OK]       Modulo cargado correctamente: ", pkg)
    catch e
        global todos_correctos = false
        println("  [ERROR]    Fallo al cargar modulo:       ", pkg)
    end
end

println("="^60)
if todos_correctos && Threads.nthreads() > 1
    println("DIAGNOSTICO FINAL: Entorno completamente listo y optimizado.")
elseif todos_correctos && Threads.nthreads() == 1
    println("DIAGNOSTICO FINAL: Paquetes correctos, pero Julia esta operando con 1 solo hilo.")
    println("ADVERTENCIA: Configure JULIA_NUM_THREADS=auto para los laboratorios de HPC.")
else
    println("DIAGNOSTICO FINAL: Existen inconsistencias en las dependencias.")
    println("ACCION REQUERIDA: Ingrese al modo Pkg con ']' y ejecute 'instantiate'.")
end
println("="^60)
```

---

## 8. Resolucion de Problemas Comunes (Troubleshooting)

### Problema 1: `Threads.nthreads()` reporta solo 1 hilo
- **Causa:** El interprete fue iniciado sin el parametro de hilos o la variable de entorno no se ha propagado al proceso hijo de VS Code.
- **Solucion:** Cierre completamente VS Code y vuelva a abrirlo tras configurar `JULIA_NUM_THREADS=auto`, o inicie la sesion explícitamente desde la terminal con `julia -t auto`.

### Problema 2: Error `ArgumentError: Package X not found in current path`
- **Causa:** Se inicio Julia sin activar el proyecto raiz, por lo que esta buscando en el entorno global por defecto (`@v1.10`).
- **Solucion:** Inicie siempre con `julia --project=.` o dentro del REPL ejecute:
  ```julia
  using Pkg; Pkg.activate(".")
  ```

### Problema 3: Tiempos de ejecucion elevados en la primera ejecucion (Time-to-First-Plot)
- **Causa:** El compilador Just-In-Time (JIT) de Julia compila las funciones a codigo maquina la primera vez que se invocan con un tipo concreto de dato.
- **Comportamiento esperado:** La segunda ejecucion de la misma funcion o celda sera de dos a tres ordenes de magnitud mas rapida. No interrumpa la sesion interactiva repetidamente para evitar recompilaciones innecesarias.

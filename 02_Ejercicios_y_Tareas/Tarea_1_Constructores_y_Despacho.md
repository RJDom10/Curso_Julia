# Tarea 1: El Dilema del Desempeño y Despacho Múltiple Bancario

## Objetivo
Demostrar empíricamente las ventajas de velocidad de Julia y aplicar los conceptos de constructores, inmutabilidad y despacho múltiple (Multiple Dispatch) en un contexto financiero.

## Contexto de Negocio
Eres Científico de Datos en un NeoBanco. Necesitas calcular las comisiones transaccionales de cierre de mes. Procesar esto en lenguajes antiguos toma demasiado tiempo. Tu tarea es diseñar un motor de cálculo en Julia.

## Instrucciones Paso a Paso
1. **Creación de Estructuras (Tipos de Datos):**
   - Crea un `abstract type` llamado `PerfilCliente`.
   - Crea tres tipos concretos derivados del anterior: `PersonaFisica`, `Pyme` y `Corporativo`.
   - Crea un `struct` llamado `Transaccion` con los atributos: `id` (Entero), `cliente` (PerfilCliente), `monto` (Decimal flotante).

2. **Constructores e Invariantes:**
   - Escribe un constructor interno para `Transaccion` que arroje un error si el `monto` es menor o igual a cero.

3. **Despacho Múltiple para Reglas de Negocio:**
   - Define una función `calcular_comision(t::Transaccion)` que aplique la tarifa de la transacción según el perfil del cliente en su atributo `.cliente`:
     - `PersonaFisica`: Si monto < 1000, 2% comisión; si es mayor, 1.5%.
     - `Pyme`: 1% fijo en todas las transacciones.
     - `Corporativo`: 0.5% fijo.

4. **Simulación y Benchmark:**
   - Crea un arreglo con 1,000,000 de transacciones aleatorias (asignando clientes aleatorios y montos aleatorios).
   - Crea una función contenedora `procesar_lote(arreglo_transacciones)` que itere y sume todas las comisiones calculadas.
   - Utiliza la macro `@time` o `@btime` (del paquete `BenchmarkTools`) midiendo el tiempo de ejecución de `procesar_lote`.

## Entregables
Un script `.jl` comentado. Debe mostrarse la impresión en consola del tiempo total que tomó procesar el millón de transacciones (que debería ser en milisegundos).

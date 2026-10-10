# Módulo B: Constructores, Comandos, Funciones y Librerías

## 1. Estructuras (`struct`)
A diferencia de las clases en OOP (Programación Orientada a Objetos), en Julia los datos y las operaciones están estrictamente separados. 
Las estructuras son **inmutables** por defecto para maximizar el rendimiento.

```julia
struct Cliente
    id::Int64
    nombre::String
    balance::Float64
end
```
Si necesitas que una estructura modifique sus atributos después de creada, usa `mutable struct`:
```julia
mutable struct CuentaBancaria
    numero::String
    saldo::Float64
end
```

## 2. Constructores
Un constructor es una función especial que crea una instancia de un tipo estructurado.
- **Constructores Externos:** Se definen fuera del `struct`. Útiles para dar valores por defecto o transformar tipos de entrada.
- **Constructores Internos:** Se definen dentro del `struct`. Obligatorios si necesitas validar reglas de negocio de los datos (invariantes).

```julia
struct Transaccion
    monto::Float64
    tipo::String
    
    # Constructor interno
    function Transaccion(monto, tipo)
        if monto <= 0
            error("El monto de transacción debe ser positivo")
        end
        if tipo ∉ ["Debito", "Credito"]
            error("Tipo de transacción no reconocido")
        end
        new(monto, tipo) # Crea el objeto
    end
end
```

## 3. Funciones
Julia es excepcionalmente flexible con las funciones:

```julia
# 1. Forma compacta (asignación matemática)
f(x) = x^2 + 2x - 1

# 2. Forma de bloque estándar
function calcular_interes(capital, tasa, tiempo)
    return capital * (1 + tasa)^tiempo
end

# 3. Argumentos opcionales (posicionales)
sumar(x, y=10) = x + y

# 4. Argumentos con nombre (Keyword arguments) van después de ;
function plot_linea(x, y; color="blue", linewidth=2)
    # Lógica del gráfico
end
```

## 4. Despacho Múltiple (Multiple Dispatch)
En lugar de encapsular métodos dentro de las clases (`objeto.metodo()`), Julia asocia métodos a funciones basándose en los tipos de datos de los argumentos que recibe la función.

```julia
abstract type Vehiculo end
struct Coche <: Vehiculo end
struct Bicicleta <: Vehiculo end

# La función 'viajar' tiene dos "métodos" diferentes
viajar(v::Coche, distancia::Float64) = "Conduciendo $distancia km"
viajar(v::Bicicleta, distancia::Float64) = "Pedaleando $distancia km"

viajar(Coche(), 15.5) # Despacha automáticamente a la lógica de coche
```

## 5. El Operador de Broadcast (`.`)
Para aplicar funciones de manera vectorial (elemento por elemento) a un arreglo, no necesitas escribir bucles `for`, solo añade un punto `.` a cualquier función u operador:

```julia
precios_sin_iva = [100.0, 200.0, 50.0]
precios_con_iva = precios_sin_iva .* 1.16 # Multiplica cada elemento por 1.16
```

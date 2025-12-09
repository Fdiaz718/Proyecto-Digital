# Proyecto Electronica Digital
Integrantes:
* Felipe Diaz Gordillo - fdiazgo@unal.edu.co - 1013100552
* Daniel Felipe Castro Gonzalez - dcastrogon@unal.edu.co - 1052836051
* Pablo Paez Linarez - ppaezl@unal.edu.co - 1011082418


# Panel led
Para tener toda la información sobre el proyecto de panel led revisar [este repositorio](https://github.com/Fdiaz718/Panel-Led-8bpp).

## CALCULADORA
1. Multiplicador
   
1.1 Especificaciones iniciales:

Se pidió diseñar un multiplicador secuencial de 8x8 bits que calcule el producto de dos números binarios.
El resultado final será un número de 16 bits.
El multiplicador debe operar de manera secuencial, usando sumas y desplazamientos, sin emplear operadores * directos.
Se deben manejar correctamente las señales de inicio (start), ocupado (busy) y terminado (done).

1.2 Diseño:

El multiplicador está basado en un camino de datos que contiene registros para los operandos A y B, un registro para el producto P y un contador de iteraciones.
La máquina de estados genera las señales de control para el datapath:

Cargar los operandos en los registros internos.

Comprobar el bit menos significativo de B; si es 1, sumar A al producto parcial.

Desplazar los registros A y B según el algoritmo de multiplicación secuencial.

Decrementar el contador de iteraciones.

Repetir hasta completar 8 iteraciones.

Señalar done y liberar busy cuando el cálculo termina.

1.3 Creación de los respectivos diagramas

![diag flujo multiplicador](https://github.com/user-attachments/assets/67117f8c-bab7-48eb-a41d-3b22cb43202a)

![Datapath multiplicador](https://github.com/user-attachments/assets/b38eee89-7328-4819-9dd9-b8765638dd3d)

![diag estados multiplicador](https://github.com/user-attachments/assets/a219e7ae-4a5a-499d-b26e-6af6b5f9922e)

1.4 Implementación en código

Carpeta con códigos del multiplicador y testbench







### 2. Divisor
2.1 Especificaciones iniciales:

Se solicitó diseñar un divisor secuencial de 8 bits que calcule cociente y residuo.
La división debe ser entera y el divisor no puede ser cero; en ese caso, se debe señalar div_zero.
Se deben usar operaciones de resta condicional y desplazamiento, evitando el operador / directo.
También se manejan las señales de inicio (start), ocupado (busy) y terminado (done).

2.2 Diseño:

El divisor usa un camino de datos con registros para el dividendo A, el divisor B, el residuo R y el cociente Q.
La máquina de estados genera señales para:

Cargar A y B en los registros internos.

Comparar el residuo actual con B; si es mayor o igual, restar B y actualizar Q.

Desplazar el residuo y el cociente según corresponda.

Repetir hasta completar 8 iteraciones.

Señalar done y liberar busy cuando el cálculo termina.

Si B = 0, levantar div_zero.

2.3 Creación de los respectivos diagramas
![Sin título](https://github.com/user-attachments/assets/9691eefe-d9db-4504-9167-d21b9235f4e1)
![WhatsApp Image 2025-11-24 at 8 52 58 AM](https://github.com/user-attachments/assets/b6fdf33c-5c00-44b4-a46c-b57298fa823b)
![diag ](https://github.com/user-attachments/assets/fa3b3a75-e1b1-4931-938e-f3ca9442284c)

1.4 Implementación en código

Carpeta con códigos del divisor y testbench




### 3. Raiz Cuadrada

#### 3.1 Especificaciones iniciales:
   Se pidio realizar el diseño de un algoritmo que realice raiz cuadrada de un numero en base 2, las limitaciones que se impusieron fue que el resultado final seria la parte entera del resultado, omitiendo los decimales. Los numeros de entrada serán de maximo 8 digitos en sistema binario.
   
#### 3.2 Diseño:
   El diseño de la logica que seguiria el algoritmo esta basado en este [video](https://www.youtube.com/watch?v=t7kInZP8CpI).
   Para la logica que tendra el diseño sera: A'' esta concatenado con A y X'' con X
   A es la entrada, A'' inicialmente es los 2 bits mas significativos de A y luego se convierte en el residuo para la operación.
   X es una variable de apoyo y X'' donde se ira escribiendo el resultado y n el numero de operaciones por hacer.
   1. Lo primero es X'' = 1 y corro 2 posiciones a A''
   2. Le resto 1 a A''
   3. Corro 2 posiciones a A'' y X = 01
   4. Comparar si  A'' es mayor que X'' movido 2 posiciones (A'' >= X''<<2)
   5. Si es mayor actualizo el valor de A'' como A'' = A'' - (X''<< 2) y X = 1
   6. Si no es mayor X = 0
   7. En ambos casos actualizo X'' como X'' = X'' << 1
   8. Comparacion final de n para saber si debo hacer mas iteraciones, si n = 0 vuelvo a al paso 3, si n = 0 se termina el proceso.

#### 3.3 Creación algoritmo, camino de datos (data pack) y maquina de estados
   a. Diagrama de flujo del algoritmo
   ![sqr_algrt](https://github.com/user-attachments/assets/1c7ca85d-a7a3-4324-9d6a-c2cb4cb0c91a)
   b. Diagrama de bloques del camino de datos
   ![sqr;data](https://github.com/user-attachments/assets/044e33d4-d616-4be2-b823-8fbb0323060a)
   c. Diagrama de estado de la máquina de control
   ![sqrt_state](https://github.com/user-attachments/assets/30d77d83-88cb-4368-a405-b79ed2f2f5ed)


#### 3.4 Implementación en codigo
   [Carpeta con codigos de raiz cuadrada y TB](https://github.com/Fdiaz718/Proyecto-Digital/tree/main/Codigos%20Calculadora/Raiz%20Cuadrada)
### 4. Conversor BCD

#### 4.1 Especificaciones iniciales:
   Se solicitó realizar el diseño de un conversor que transforme un número binario a su representación BCD (Binary Coded Decimal) utilizando el algoritmo estándar conocido como Double Dabble o método de Add-3/Shift.
   La entrada es un número binario de 8  bits.
   La salida se compone de tres dígitos BCD: unidades (X), decenas (X') y centenas (X'').
   El algoritmo debe recorrer todos los bits de la entrada y producir un resultado válido al final del proceso.

#### 4.2 Diseño:
   Para el diseño del convertidor se utilizó la lógica del algoritmo Double Dabble. La idea principal del método consiste en que antes de cada desplazamiento, cada dígito BCD parcial es comparado con 5.
   Si alguno de ellos es mayor o igual que 5, a ese dígito se le suma 3. Luego se realiza un corrimiento hacia la izquierda desplazando también el bit más significativo del número binario hacia los registros BCD.
   Este diseño estaba basado en este [video](https://www.youtube.com/watch?v=RDoYo3yOL_E) donde se detalla la logica del proceso, ademas de ejemplos paso a paso

   El proceso general es:

   1. Inicialización de X, X', X'' en 0 y carga del número binario en binary.

   2. Comparación de cada dígito BCD con 5.

   3. Suma opcional de 3 a los dígitos ≥ 5.

   4. Corrimiento hacia la izquierda propagando los bits entre los dígitos BCD y binary.

   5. Decremento de n y repetición mientras queden bits por procesar.

Entrega del resultado final cuando n = 0.
#### 4.3 Creación algoritmo, camino de datos (data pack) y maquina de estados
   a. Diagrama de flujo del algoritmo
   ![bcd_algrt](https://github.com/user-attachments/assets/def57e33-6353-4856-93b9-667dcd0faef2)

   b. Diagrama de bloques del camino de datos
   ![bcd_data](https://github.com/user-attachments/assets/a275291a-e734-459a-9530-cf8401579b7d)

   c. Diagrama de estado de la máquina de control
   ![bcd_statte](https://github.com/user-attachments/assets/767dddb3-01b4-46c2-9e51-db5a1a3f45e8)

#### 4.4 Implementación en codigo
   [Caperta con codigo y TB de BCD](https://github.com/Fdiaz718/Proyecto-Digital/tree/main/Codigos%20Calculadora/BCD)
   ## Periféricos para FemtoRV32

Los periféricos son wrappers que permiten conectar los módulos de la calculadora al bus de memoria del procesador FemtoRV32. Cada periférico mapea las señales de control y datos al espacio de direcciones del procesador.

### Estructura de los Periféricos

Cada periférico sigue el mismo patrón de interfaz:
```verilog
module peripheral_xxx (
    input wire clk,
    input wire reset,
    input wire [15:0] d_in,    // Datos de entrada desde el bus
    input wire cs,              // Chip select
    input wire [4:0] addr,      // Dirección interna
    input wire rd,              // Señal de lectura
    input wire wr,              // Señal de escritura
    output reg [31:0] d_out     // Datos de salida al bus
);
```

### Mapeo de Memoria

Los periféricos están mapeados en las siguientes direcciones de memoria:

| Dirección | Periférico | Descripción |
|-----------|------------|-------------|
| 0x00000400 | Multiplicador | Escribe A y B, lee producto P |
| 0x00000410 | Divisor | Escribe A y B, lee cociente y residuo |
| 0x00000420 | Raíz Cuadrada | Escribe A, lee resultado |
| 0x00000430 | Conversor BCD | Escribe número binario, lee dígitos BCD |

### Uso desde Assembly

Para usar los periféricos desde código assembly RISC-V:
```assembly
# Ejemplo: Multiplicar 12 x 8
li t0, 0x0C08           # A=12 en bits [15:8], B=8 en bits [7:0]
sw t0, 0x400(zero)      # Escribir a dirección del multiplicador
nop                      # Esperar ciclos de procesamiento
lw t1, 0x400(zero)      # Leer resultado (96 en t1)
```

### Archivos de Periféricos

- `peripheral_mult.v`: Wrapper del multiplicador
- `peripheral_div.v`: Wrapper del divisor  
- `peripheral_sqrt.v`: Wrapper de raíz cuadrada
- `peripheral_bcd.v`: Wrapper del conversor BCD

Todos los periféricos incluyen sincronización de señales start y lectura de banderas de estado (done, busy, error).

---

## Calculadora Integradora

El módulo `calc_core.v` integra los cuatro módulos aritméticos en un único sistema controlado por un selector de operación.

### Interfaz
```verilog
module calc_core (
    input  wire        clk,
    input  wire        reset,
    input  wire        start,       // Iniciar cálculo
    input  wire [1:0]  op,          // Selector de operación
    input  wire [7:0]  A,           // Operando A
    input  wire [7:0]  B,           // Operando B
    output reg  [15:0] result,      // Resultado
    output reg         busy,        // Calculando
    output reg         done,        // Terminado
    output reg         error        // Error (ej: división por cero)
);
```

### Selector de Operación

El campo `op` determina qué módulo se activa:

- `op = 2'b00`: Multiplicación (A × B)
- `op = 2'b01`: División (A ÷ B)
- `op = 2'b10`: Raíz cuadrada (√A)
- `op = 2'b11`: Conversión BCD (A → BCD)

### Formato de Resultados

Dependiendo de la operación, el campo `result[15:0]` tiene diferentes interpretaciones:

**Multiplicación:**
- `result[15:0]`: Producto completo de 16 bits

**División:**
- `result[15:8]`: Cociente
- `result[7:0]`: Residuo

**Raíz Cuadrada:**
- `result[9:0]`: Resultado de 10 bits
- `result[15:10]`: Ceros

**BCD:**
- `result[11:8]`: Centenas
- `result[7:4]`: Decenas
- `result[3:0]`: Unidades
- `result[15:12]`: Ceros

### Manejo de Errores

La señal `error` se activa en las siguientes condiciones:
- División por cero (B = 0 en operación de división)
- Conversión BCD inválida (señal `valid` del conversor en bajo)

---

## Simulación y Verificación

### Testbenches Incluidos

Cada módulo tiene su testbench correspondiente:

- `tb_mult.v`: Prueba el multiplicador con 5 casos
- `tb_div.v`: Prueba el divisor incluyendo división por cero
- `sqrt_testbench.v`: Prueba la raíz cuadrada con varios valores
- `bcd_converter_tb.v`: Verifica la conversión BCD
- `tb_calc_core.v`: Prueba la calculadora integrada completa

### Compilar y Simular

Para simular cualquier módulo:
```bash
# Ejemplo con el multiplicador
cd multiplicador
iverilog -o mult_sim sim/tb_mult.v rtl/*.v
vvp mult_sim
gtkwave multiplicador.vcd
```

Para simular la calculadora completa:
```bash
cd integradora
iverilog -o calc_sim sim/tb_calc_core.v rtl/calc_core.v \
    ../multiplicador/rtl/*.v ../divisor/rtl/*.v \
    ../raiz/rtl/*.v ../bcd/rtl/bcd_converter.v
vvp calc_sim
```

### Resultados de Simulación

Todos los módulos pasaron sus tests de verificación:

**Multiplicador:**
- 5 × 3 = 15 (PASS)
- 12 × 8 = 96 (PASS)
- 255 × 255 = 65025 (PASS)
- 100 × 0 = 0 (PASS)
- 15 × 7 = 105 (PASS)

**Divisor:**
- 15 ÷ 3 = 5 resto 0 (PASS)
- 20 ÷ 4 = 5 resto 0 (PASS)
- 17 ÷ 5 = 3 resto 2 (PASS)
- 255 ÷ 10 = 25 resto 5 (PASS)
- 100 ÷ 0 = error detectado (PASS)

**Raíz Cuadrada:**
- √144 = 12 (PASS)
- √100 = 10 (PASS)
- √255 = 15 (PASS)

**Conversor BCD:**
- 0 → 000 (PASS)
- 9 → 009 (PASS)
- 123 → 123 (PASS)
- 255 → 255 (PASS)

**Calculadora Integrada:**
- Multiplicación 12 × 8 = 96 (PASS)
- División 17 ÷ 5 = 3 resto 2 (PASS)
- Raíz √144 = 12 (PASS)
- BCD 123 → 1-2-3 (PASS)
- División por cero detectada (PASS)

---

## Implementación en FPGA

### Hardware Target

El proyecto está diseñado para implementarse en la **Colorlight 5A-75E**:
- FPGA: Anlogic EG4S20BG256
- Clock: 25 MHz
- Comunicación: 2x FT232RL (UART)


### Archivos de Firmware

Los programas de prueba en assembly están en la carpeta `perifericos/`:

- `calc_test.s`: Programa completo que prueba todos los módulos
- `mult_periph.s`: Test individual del multiplicador
- `div_periph.s`: Test individual del divisor
- `sqrt_periph.s`: Test individual de raíz cuadrada
- `bcd_periph.s`: Test individual del conversor BCD




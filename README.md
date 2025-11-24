# Proyecto Electronica Digital
Integrantes:
* Felipe Diaz Gordillo - fdiazgo@unal.edu.co - 1013100552
* Daniel Felipe Castro Gonzalez - dcastogon@unal.edu.co - 1052836051

## DEPENDENCIAS


## CALCULADORA
### 1. Multiplicador
## 1.1 Descripción General

El multiplicador es un circuito digital que realiza la multiplicación de dos 
números de 8 bits sin signo, generando un producto de 16 bits. El diseño 
utiliza el algoritmo shift-and-add (desplazamiento y suma) implementado 
mediante una arquitectura separada de datapath y máquina de control.

## 1.2 Parámetros de Diseño

### 1.3 Entradas
- **A[7:0]**: Multiplicando (8 bits, sin signo)
- **B[7:0]**: Multiplicador (8 bits, sin signo)
- **start**: Señal de inicio de operación (activa en alto)
- **clk**: Señal de reloj del sistema
- **reset**: Reset asíncrono (activo en alto)

### 1.4 Salidas
- **P[15:0]**: Producto resultante (16 bits, sin signo)
- **busy**: Indicador de operación en curso (alto durante cálculo)
- **done**: Indicador de operación completada (pulso de 1 ciclo)

### 1.5 Restricciones
- Números sin signo únicamente
- Rango de entrada: 0 a 255 para A y B
- Rango de salida: 0 a 65025 para P
- Operación síncrona con reloj

## 1.6 Algoritmo

El multiplicador implementa el algoritmo shift-and-add:
```
1. Inicializar:
   - P ← 0
   - A_reg ← A
   - B_reg ← B
   - contador ← 8

2. Mientras contador > 0:
   a. Si B_reg[0] = 1:
      - P ← P + A_reg
   b. A_reg ← A_reg << 1 (desplazar izquierda)
   c. B_reg ← B_reg >> 1 (desplazar derecha)
   d. contador ← contador - 1
### 1.7 Componentes Principales

**Datapath (camino de datos):**
- Registro A (8 bits): almacena multiplicando y se desplaza izquierda
- Registro B (8 bits): almacena multiplicador y se desplaza derecha
- Registro P (16 bits): acumulador del producto
- Sumador (16 bits): realiza P + A_reg
- Contador (4 bits): cuenta de 8 a 0
- Lógica de desplazamiento

**Máquina de Control (FSM):**
- 6 estados: IDLE, LOAD, CHECK, ADD, SHIFT, DONE
- Genera señales de control: load, add, shift, clear_P, dec_count
- Recibe señales de estado: B_bit0, count_zero

### 1.8 Señales Internas

**Del FSM al Datapath:**
- load: cargar operandos iniciales
- clear_P: limpiar acumulador
- add: realizar suma P + A_reg
- shift: desplazar A y B
- dec_count: decrementar contador

**Del Datapath al FSM:**
- B_bit0: bit menos significativo de B
- count_zero: flag indicando contador en 0

## 1.9 Máquina de Estados

### Estados:

**IDLE**: Estado de espera
   - Espera señal start
   - busy = 0, done = 0

**LOAD**: Carga de operandos
   - Carga A y B en registros
   - Inicializa P = 0
   - Inicializa contador = 8
   - Activa: load, clear_P
   - busy = 1

**CHECK**: Verificación de bit
   - Revisa B_reg[0]
   - No genera señales de control
   - busy = 1
   - Transición a ADD si B[0]=1, sino a SHIFT

 **ADD**: Suma
   - P = P + A_reg
   - Activa: add
   - busy = 1

**SHIFT**: Desplazamiento
   - A_reg << 1
   - B_reg >> 1
   - contador--
   - Activa: shift, dec_count
   - busy = 1
   - Transición a CHECK si count≠0, sino a DONE

*DONE**: Finalización
   - Operación completa
   - done = 1, busy = 0
   - Retorna a IDLE
```
## Diagramas
![diag flujo multiplicador](https://github.com/user-attachments/assets/67117f8c-bab7-48eb-a41d-3b22cb43202a)

![Datapath multiplicador](https://github.com/user-attachments/assets/b38eee89-7328-4819-9dd9-b8765638dd3d)

![diag estados multiplicador](https://github.com/user-attachments/assets/a219e7ae-4a5a-499d-b26e-6af6b5f9922e)





### 2. Divisor



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

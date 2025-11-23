# Proyecto Electronica Digital
Integrantes:
Felipe Diaz Gordillo - fdiazgo@unal.edu.co - 1013100552

## DEPENDENCIAS


## CALCULADORA
### 1. Multiplicador



### 2. Divisor



### 3. Raiz Cuadrada

#### 3.1 Especificaciones iniciales:
   Se pidio realizar el diseño de un algoritmo que realice raiz cuadrada de un numero en base 2, las limitaciones que se impusieron fue que el resultado final seria la parte entera del resultado, omitiendo los decimales. Los numeros de entrada podran ser de maximo 8 digitos en sistema binario.
   
#### 3.2 Diseño:
   El diseño de la logica que seguiria el algoritmo esta basado en este [video](https://www.youtube.com/watch?v=t7kInZP8CpI).
   Para la logica que tendra el diseño sera: A'' esta concatenado con A y X'' con X
   A es la entrada, A'' inicialmente es los 2 bits mas significativos de A y luego se convierte en el residuo para la operación.
   X es una variable de apoyo y X'' donde se ira escribiendo el resultado y n el numero de operaciones por hacer.
   1. Lo primero es X'' = 1 
   2. Corro 2 posiciones a A'' y X = 01
   3. Comparar si  A'' es mayor que X'' movido 2 posiciones (A'' >= X''<<2)
   4. Si es mayor actualizo el valor de A'' como A'' = A'' - (X''<< 2) y X = 1
   5. Si no es mayor X = 0
   6. En ambos casos actualizo X'' como X'' = X'' << 1
   7. Comparacion final de n para saber si debo hacer mas iteraciones, si n = 0 vuelvo a al paso 2, si n = 0 se termina el proceso.

#### 3.3 Creación algoritmo, camino de datos (data pack) y maquina de estados
   a. Diagrama de flujo del algoritmo
   ![sqr](https://github.com/user-attachments/assets/2581e3fc-8a5a-4ff0-b55f-c45fab63b8a9)


   b. Diagrama de bloques del camino de datos
   c. Diagrama de estado de la máquina de control
#### 3.4 Implementación en codigo



### 4. Conversor BCD
#### 4.1 Especificaciones iniciales:
#### 4.2 Diseño:
   Para entender como 
#### 4.3 Creación algoritmo, camino de datos (data pack) y maquina de estados
   
#### 4.4 Implementación en codigo

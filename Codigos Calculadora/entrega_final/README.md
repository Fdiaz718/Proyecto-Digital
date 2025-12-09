# Proyecto Calculadora Digital

**Autores:** Daniel & Compañero  
**Curso:** Diseño Digital  
**Fecha:** Diciembre 2024

---

## Descripción

Este proyecto implementa una calculadora digital en Verilog con cuatro operaciones:
- Multiplicación 8x8 bits
- División 8÷8 bits  
- Raíz cuadrada
- Conversión binario a BCD

Todo está diseñado para implementarse en la FPGA Colorlight 5A-75E usando el procesador FemtoRV32.

---

## Estructura del Proyecto
cat > entrega_final/docs/IMPLEMENTACION.md << 'EOF'
# Guía de Implementación en FPGA

Esta guía explica cómo implementar la calculadora en la Colorlight 5A-75E.

---

## Lo que Necesitas

**Hardware:**
- Colorlight 5A-75E (la que tenemos)
- Cable USB
- PC

**Software:**
- Tang Dynasty IDE (de Anlogic)
- FemtoRV32 de GitHub
- Terminal serial (PuTTY o cualquiera)

---

## Pasos

### 1. Descargar FemtoRV32
```bash
git clone https://github.com/BrunoLevy/learn-fpga
cd learn-fpga/FemtoRV
```

FemtoRV32 es un procesador RISC-V chiquito que cabe en nuestra FPGA.

### 2. Copiar Nuestros Archivos

Copiar todos los .v de `entrega_final/rtl/` a `FemtoRV/RTL/DEVICES/`

Esto incluye:
- Los módulos base (mult, div, sqrt, bcd)
- Los periféricos (peripheral_*.v)

### 3. Editar femtosoc.v

Abrir `FemtoRV/RTL/femtosoc.v` y agregar nuestros periféricos.

Buscar donde están definidos los otros periféricos y agregar algo así:
```verilog
// nuestros periféricos de la calculadora

peripheral_mult mult_inst (
    .clk(clk),
    .reset(reset),
    .d_in(mem_wdata[15:0]),
    .cs(IO_mem_wr && mem_addr[31:4] == 28'h0000040),
    .addr(mem_addr[4:0]),
    .rd(IO_mem_rd),
    .wr(IO_mem_wr),
    .d_out(mult_rdata)
);

// repetir para div, sqrt, bcd...
```

Los números después de `28'h` son las direcciones de memoria. Podemos usar:
- 0x400 para multiplicador
- 0x410 para divisor
- 0x420 para raíz
- 0x430 para BCD

### 4. Compilar el Firmware
```bash
cd FemtoRV/FIRMWARE

# compilar calc_test.s
riscv64-linux-gnu-as -march=rv32i -mabi=ilp32 \
    ../../entrega_final/firmware/calc_test.s -o calc_test.o
    
riscv64-linux-gnu-ld -m elf32lriscv calc_test.o -o calc_test.elf

riscv64-linux-gnu-objcopy -O verilog calc_test.elf calc_test.hex
```

Esto convierte el assembly a un archivo .hex que puede cargar la FPGA.

### 5. Crear Proyecto en Tang Dynasty

1. Abrir Tang Dynasty IDE
2. New Project
3. Seleccionar EG4S20BG256 (chip de la 5A-75E)
4. Agregar todos los .v
5. Configurar el clock (25 MHz generalmente)
6. Agregar constraints para los pines

Los pines de la 5A-75E están documentados aquí:
https://github.com/q3k/chubby75

### 6. Sintetizar

Click en "Synthesize" y esperar. Si hay errores, probablemente falta algún archivo .v o hay algo mal en las rutas.

### 7. Implementar y Generar Bitstream

Click en "Place & Route" y luego "Generate Bitstream".

### 8. Programar la FPGA

Con openFPGALoader:
```bash
openFPGALoader -b colorlight-5a-75e bitstream.bit
```

O usando la herramienta de Anlogic directamente.

### 9. Probar

Conectar un terminal serial al puerto USB:
```bash
screen /dev/ttyUSB0 115200
```

Si todo está bien, deberías ver los resultados de las pruebas por el UART.

---

## Direcciones de Memoria

Los periféricos están mapeados en:

| Dirección | Periférico |
|-----------|------------|
| 0x400 | Multiplicador |
| 0x410 | Divisor |
| 0x420 | Raíz Cuadrada |
| 0x430 | BCD |

Para usarlos desde assembly:
```assembly
li t0, 0x0C08        # A=12, B=8
sw t0, 0x400(zero)   # escribir
lw t1, 0x400(zero)   # leer resultado
```

---

## Problemas Comunes

**No compila:**
- Verificar que todos los .v estén agregados
- Revisar nombres de módulos

**No programa:**
- Verificar cable USB
- Probar con sudo

**No sale nada por UART:**
- Verificar baud rate (115200)
- Probar los dos puertos USB (la 5A-75E tiene 2 FT232RL)

---

## Referencias

- FemtoRV32: https://github.com/BrunoLevy/learn-fpga
- Colorlight 5A-75E pinout: https://github.com/q3k/chubby75
- Tang Dynasty: https://www.anlogic.com

---

Cualquier duda, revisar los testbenches en `simulacion/` para ver cómo se usan los módulos.

¡Suerte! 🚀

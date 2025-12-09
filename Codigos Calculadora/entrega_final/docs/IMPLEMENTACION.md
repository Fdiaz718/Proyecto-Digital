# Calculadora Digital - Guía de Implementación para Colorlight 5A-75E

## Objetivo
Implementar calculadora digital en FPGA Colorlight 5A-75E usando procesador FemtoRV32.

---

## Requisitos Previos

### Hardware:
- Colorlight 5A-75E (FPGA Anlogic EG4S20)
- Cable USB para programación
- pC con puerto USB (para UART)

### Software:
- Tang Dynasty IDE (Anlogic) o herramientas OpenSource
- FemtoRV32: https://github.com/BrunoLevy/learn-fpga
- Terminal serial (PuTTY, minicom, screen)

---

## Pasos de Implementación

### Paso 1: Clonar FemtoRV32
```bash
git clone https://github.com/BrunoLevy/learn-fpga
cd learn-fpga/FemtoRV
```

### Paso 2: Copiar Periféricos
```bash
# Copiar tus periféricos a FemtoRV32
cp /ruta/entrega_final/rtl/peripheral_*.v FemtoRV/RTL/DEVICES/
cp /ruta/entrega_final/rtl/*.v FemtoRV/RTL/DEVICES/
```

### Paso 3: Modificar femtosoc.v

Editar `FemtoRV/RTL/femtosoc.v` y agregar tus periféricos:
```verilog
// Agregar después de los periféricos existentes

// Calculadora - Multiplicador
peripheral_mult mult_periph (
    .clk(clk),
    .reset(reset),
    .d_in(mem_wdata[15:0]),
    .cs(IO_mem_wr && mem_addr[31:4] == 28'h0000040), // 0x00000400
    .addr(mem_addr[4:0]),
    .rd(IO_mem_rd),
    .wr(IO_mem_wr),
    .d_out(mult_rdata)
);

// Calculadora - Divisor
peripheral_div div_periph (
    .clk(clk),
    .reset(reset),
    .d_in(mem_wdata[15:0]),
    .cs(IO_mem_wr && mem_addr[31:4] == 28'h0000041), // 0x00000410
    .addr(mem_addr[4:0]),
    .rd(IO_mem_rd),
    .wr(IO_mem_wr),
    .d_out(div_rdata)
);

// Calculadora - Raíz Cuadrada
peripheral_sqrt sqrt_periph (
    .clk(clk),
    .reset(reset),
    .d_in(mem_wdata[15:0]),
    .cs(IO_mem_wr && mem_addr[31:4] == 28'h0000042), // 0x00000420
    .addr(mem_addr[4:0]),
    .rd(IO_mem_rd),
    .wr(IO_mem_wr),
    .d_out(sqrt_rdata)
);

// Calculadora - BCD
peripheral_bcd bcd_periph (
    .clk(clk),
    .reset(reset),
    .d_in(mem_wdata[15:0]),
    .cs(IO_mem_wr && mem_addr[31:4] == 28'h0000043), // 0x00000430
    .addr(mem_addr[4:0]),
    .rd(IO_mem_rd),
    .wr(IO_mem_wr),
    .d_out(bcd_rdata)
);
```

### Paso 4: Compilar Firmware
```bash
cd FemtoRV/FIRMWARE

# Compilar test de calculadora
riscv64-linux-gnu-as -march=rv32i -mabi=ilp32 \
    /ruta/entrega_final/firmware/calc_test.s -o calc_test.o
    
riscv64-linux-gnu-ld -m elf32lriscv calc_test.o -o calc_test.elf

riscv64-linux-gnu-objcopy -O verilog calc_test.elf calc_test.hex
```

### Paso 5: Sintetizar para 5A-75E

En Tang Dynasty IDE:
1. Crear nuevo proyecto
2. Seleccionar FPGA: EG4S20BG256
3. Agregar todos los archivos .v
4. Configurar constraints (pines de clock, UART)
5. Ejecutar síntesis
6. Generar bitstream

### Paso 6: Programar FPGA
```bash
openFPGALoader -b colorlight-5a-75e bitstream.bit
```

### Paso 7: Probar por UART
```bash
# Conectar terminal serial (115200 baud)
screen /dev/ttyUSB0 115200

# O con minicom
minicom -D /dev/ttyUSB0 -b 115200
```

---

## Programa de Prueba (calc_test.s)

El firmware incluido probará automáticamente:
- ✅ Multiplicación: 12 × 8 = 96
- ✅ División: 17 ÷ 5 = 3 resto 2
- ✅ Raíz cuadrada: √144 = 12
- ✅ BCD: 123 → 1-2-3

Mostrará resultados por UART.

---

## Mapa de Memoria

| Dirección | Periférico | Función |
|-----------|------------|---------|
| 0x00000400 | Multiplicador | Escribe A,B → Lee resultado |
| 0x00000410 | Divisor | Escribe A,B → Lee Q,R |
| 0x00000420 | Raíz Cuadrada | Escribe A → Lee √A |
| 0x00000430 | BCD | Escribe bin → Lee BCD |

---

## Troubleshooting

**Problema:** No sintetiza
- Verificar que todos los .v estén agregados
- Revisar rutas de archivos
- Verificar compatibilidad de módulos

**Problema:** No programa
- Verificar cable USB conectado
- Verificar drivers FTDI instalados
- Probar con openFPGALoader

**Problema:** No comunica por UART
- Verificar baud rate (115200)
- Verificar puerto correcto (/dev/ttyUSB0 o ttyUSB1)
- Verificar que FT232RL esté configurado

---

## Referencias

- FemtoRV32: https://github.com/BrunoLevy/learn-fpga
- Colorlight 5A-75E: https://github.com/q3k/chubby75
- Tang Dynasty IDE: https://www.anlogic.com
- OpenFPGALoader: https://github.com/trabucayre/openFPGALoader

---

## Checklist de Implementación

- [ ] FemtoRV32 clonado
- [ ] Periféricos copiados
- [ ] femtosoc.v modificado
- [ ] Firmware compilado
- [ ] Proyecto creado en Tang Dynasty
- [ ] Síntesis exitosa
- [ ] Bitstream generado
- [ ] FPGA programada
- [ ] UART funcionando
- [ ] Tests pasando

---


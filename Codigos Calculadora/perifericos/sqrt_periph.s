#------------------------------------------------------
# Programa de prueba para el periférico raíz cuadrada
#------------------------------------------------------
# Direcciones según SOC.v: 0x0044xxxx
# 0x00440000 -> A
# 0x00440004 -> done
# 0x00440008 -> X (resultado)
#------------------------------------------------------

    li t0, 144        # Número a calcular raíz

    sw t0, 0x00440000  # Escribir A

# Esperar a done
wait_sqrt:
    lw t1, 0x00440004
    beq t1, zero, wait_sqrt

# Leer resultado
    lw t2, 0x00440008  # Resultado raíz = 12


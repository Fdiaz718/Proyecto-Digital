#------------------------------------------------------
# Programa de prueba para el periférico multiplicador
#------------------------------------------------------
# Direcciones según SOC.v: 0x0042xxxx
# 0x00420000 -> A
# 0x00420004 -> B
# 0x00420008 -> done
# 0x0042000C -> resultado P
#------------------------------------------------------

    li t0, 12        # Cargar primer operando
    li t1, 15        # Cargar segundo operando

    sw t0, 0x00420000   # Escribir A
    sw t1, 0x00420004   # Escribir B

# Esperar a que done se active
wait_mult:
    lw t2, 0x00420008
    beq t2, zero, wait_mult

# Leer resultado
    lw t3, 0x0042000C
# Resultado en t3 -> 12 * 15 = 180


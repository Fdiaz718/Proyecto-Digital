#------------------------------------------------------
# Programa de prueba para el periférico conversor BCD
#------------------------------------------------------
# Direcciones según SOC.v: 0x0045xxxx
# 0x00450000 -> A
# 0x00450004 -> done
# 0x00450008 -> X   (ones)
# 0x0045000C -> X'  (tens)
# 0x00450010 -> X'' (hundreds)
#------------------------------------------------------

    li t0, 123        # Número a convertir

    sw t0, 0x00450000  # Escribir A

# Esperar a done
wait_bcd:
    lw t1, 0x00450004
    beq t1, zero, wait_bcd

# Leer resultado
    lw t2, 0x00450008   # Ones
    lw t3, 0x0045000C   # Tens
    lw t4, 0x00450010   # Hundreds


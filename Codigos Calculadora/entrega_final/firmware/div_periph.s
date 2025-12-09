#------------------------------------------------------
# Programa de prueba para el periférico divisor
#------------------------------------------------------
# Direcciones según SOC.v: 0x0043xxxx
# 0x00430000 -> A (dividendo)
# 0x00430004 -> B (divisor)
# 0x00430008 -> done
# 0x0043000C -> Q
# 0x00430010 -> R
#------------------------------------------------------

    li t0, 25         # A
    li t1, 4          # B

    sw t0, 0x00430000
    sw t1, 0x00430004

# Esperar a done
wait_div:
    lw t2, 0x00430008
    beq t2, zero, wait_div

# Leer resultado
    lw t3, 0x0043000C   # cociente Q
    lw t4, 0x00430010   # residuo R


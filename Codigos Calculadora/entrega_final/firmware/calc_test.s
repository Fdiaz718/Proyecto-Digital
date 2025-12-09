# calc_test.s
# Programa de pruebas para multiplicador, divisor, sqrt y bcd


    .section .text
    .globl _start
_start:

    # -------------------------
    # TEST MULTIPLICADOR
    # -------------------------
    li   t0, 12                # A = 12
    li   t1, 15                # B = 15
    sw   t0, 0x00420000        # escribir A
    sw   t1, 0x00420004        # escribir B

wait_mult:
    lw   t2, 0x00420008        # leer done
    beq  t2, zero, wait_mult

    lw   t3, 0x0042000C        # leer resultado (32-bit)
    # t3 tiene 12*15 = 180

    # -------------------------
    # TEST DIVISOR
    # -------------------------
    li   t0, 25
    li   t1, 4
    sw   t0, 0x00430000
    sw   t1, 0x00430004

wait_div:
    lw   t2, 0x00430008
    beq  t2, zero, wait_div

    lw   t3, 0x0043000C        # Q
    lw   t4, 0x00430010        # R
    # t3 = 6, t4 = 1

    # -------------------------
    # TEST SQRT
    # -------------------------
    li   t0, 144
    sw   t0, 0x00440000

wait_sqrt:
    lw   t2, 0x00440004
    beq  t2, zero, wait_sqrt

    lw   t3, 0x00440008        # sqrt(144) = 12

    # -------------------------
    # TEST BCD
    # -------------------------
    li   t0, 123
    sw   t0, 0x00450000

wait_bcd:
    lw   t2, 0x00450004
    beq  t2, zero, wait_bcd

    lw   t3, 0x00450008        # ones
    lw   t4, 0x0045000C        # tens
    lw   t5, 0x00450010        # hundreds
    # t5,t4,t3 = 1,2,3

done_loop:
    j done_loop                # quedarnos aquí (en el testbench se termina)


`timescale 1ns/1ps

// ============================================
// TESTBENCH - Pruebas del algoritmo
// ============================================
module testbench;
    reg clk;
    reg reset;
    reg Start;
    reg [7:0] A;
    wire [9:0] Result;
    wire Done;
    
    // Instancia del módulo top
    top DUT (
        .clk(clk),
        .reset(reset),
        .Start(Start),
        .A(A),
        .Result(Result),
        .Done(Done)
    );
    
    // Generar reloj (periodo 10ns)
    always #5 clk = ~clk;
    
    // Pruebas
    initial begin
        $dumpfile("sqrt.vcd");
        $dumpvars(0, testbench);
        
        $display("=====================================");
        $display("  RAIZ CUADRADA - ALGORITMO");
        $display("=====================================\n");
        
        // Inicializar
        clk = 0;
        reset = 1;
        Start = 0;
        A = 0;
        
        // Quitar reset
        #20 reset = 0;
        #10;
        
        // PRUEBA 1: sqrt(144) = 12
        $display("Test 1: A = 144");
        A = 8'd144;
        Start = 1;
        #10 Start = 0;
        wait(Done);
        #20;
        $display("  Resultado = %d (esperado: 12)", Result);
        if (Result == 12) $display("  [PASS]\n");
        else $display("  [FAIL]\n");
        
        // PRUEBA 2: sqrt(85) = 9
        $display("Test 2: A = 85");
        A = 8'd85;
        Start = 1;
        #10 Start = 0;
        wait(Done);
        #20;
        $display("  Resultado = %d (esperado: 9)", Result);
        if (Result == 9) $display("  [PASS]\n");
        else $display("  [FAIL]\n");
        
        // PRUEBA 3: sqrt(200) = 14
        $display("Test 3: A = 200");
        A = 8'd200;
        Start = 1;
        #10 Start = 0;
        wait(Done);
        #20;
        $display("  Resultado = %d (esperado: 14)", Result);
        if (Result == 14) $display("  [PASS]\n");
        else $display("  [FAIL]\n");
        
        // PRUEBA 4: sqrt(16) = 4
        $display("Test 4: A = 36");
        A = 8'd36;
        Start = 1;
        #10 Start = 0;
        wait(Done);
        #20;
        $display("  Resultado = %d (esperado: 6)", Result);
        if (Result == 2) $display("  [PASS]\n");
        else $display("  [FAIL]\n");
        
        // PRUEBA 5: sqrt(1) = 1
        $display("Test 5: A = 1");
        A = 8'd1;
        Start = 1;
        #10 Start = 0;
        wait(Done);
        #20;
        $display("  Resultado = %d (esperado: 1)", Result);
        if (Result == 1) $display("  [PASS]\n");
        else $display("  [FAIL]\n");
        
        // PRUEBA 6: sqrt(64) = 8
        $display("Test 6: A = 64");
        A = 8'd64;
        Start = 1;
        #10 Start = 0;
        wait(Done);
        #20;
        $display("  Resultado = %d (esperado: 8)", Result);
        if (Result == 8) $display("  [PASS]\n");
        else $display("  [FAIL]\n");
        
        // PRUEBA 7: sqrt(255) = 15
        $display("Test 7: A = 255");
        A = 8'd255;
        Start = 1;
        #10 Start = 0;
        wait(Done);
        #20;
        $display("  Resultado = %d (esperado: 15)", Result);
        if (Result == 15) $display("  [PASS]\n");
        else $display("  [FAIL]\n");
        
        $display("=====================================");
        $display("  FIN DE PRUEBAS");
        $display("=====================================");
        $finish;
    end
    
    // Timeout
    initial begin
        #100000;
        $display("ERROR: Timeout");
        $finish;
    end

endmodule

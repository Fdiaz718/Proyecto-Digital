`timescale 1ns/1ps

module tb_calc_core;

    reg clk, reset, start;
    reg [1:0] op;
    reg [7:0] A, B;
    wire [15:0] result;
    wire busy, done, error;
    
    calc_core dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .op(op),
        .A(A),
        .B(B),
        .result(result),
        .busy(busy),
        .done(done),
        .error(error)
    );
    
    initial clk = 0;
    always #10 clk = ~clk;
    
    initial begin
        $dumpfile("calc_core.vcd");
        $dumpvars(0, tb_calc_core);
        
        reset = 1; start = 0; op = 0; A = 0; B = 0;
        #50 reset = 0;
        
        $display("");
        $display("╔════════════════════════════════════════╗");
        $display("║   PRUEBA CALCULADORA INTEGRADA        ║");
        $display("╚════════════════════════════════════════╝");
        $display("");
        
        // Test 1: Multiplicación
        $display("Test 1: Multiplicación 12 × 8");
        op = 2'b00; A = 8'd12; B = 8'd8;
        start = 1; #20; start = 0;
        wait(done); #20;
        $display("  Resultado: %d (esperado: 96)", result);
        if (result == 16'd96) $display("  ✅ PASS");
        else $display("  ❌ FAIL");
        $display("");
        #100;
        
        // Test 2: División
        $display("Test 2: División 17 ÷ 5");
        op = 2'b01; A = 8'd17; B = 8'd5;
        start = 1; #20; start = 0;
        wait(done); #20;
        $display("  Cociente: %d, Residuo: %d", result[15:8], result[7:0]);
        if (result[15:8] == 8'd3 && result[7:0] == 8'd2) $display("  ✅ PASS");
        else $display("  ❌ FAIL");
        $display("");
        #100;
        
        // Test 3: Raíz cuadrada
        $display("Test 3: Raíz cuadrada √144");
        op = 2'b10; A = 8'd144; B = 8'd0;
        start = 1; #20; start = 0;
        wait(done); #20;
        $display("  Resultado: %d (esperado: 12)", result[9:0]);
        if (result[9:0] == 10'd12) $display("  ✅ PASS");
        else $display("  ❌ FAIL");
        $display("");
        #100;
        
        // Test 4: BCD
        $display("Test 4: Binario 123 → BCD");
        op = 2'b11; A = 8'd123; B = 8'd0;
        start = 1; #20; start = 0;
        wait(done); #20;
        $display("  BCD: %d%d%d", result[11:8], result[7:4], result[3:0]);
        if (result[11:8] == 4'd1 && result[7:4] == 4'd2 && result[3:0] == 4'd3) 
            $display("  ✅ PASS");
        else $display("  ❌ FAIL");
        $display("");
        #100;
        
        // Test 5: División por cero
        $display("Test 5: División por cero 100 ÷ 0");
        op = 2'b01; A = 8'd100; B = 8'd0;
        start = 1; #20; start = 0;
        wait(done); #20;
        if (error) $display("  ✅ PASS - Error detectado");
        else $display("  ❌ FAIL - Error no detectado");
        
        #200;
        $display("");
        $display("════════════════════════════════════════");
        $display("  FIN DE PRUEBAS");
        $display("════════════════════════════════════════");
        $display("");
        $finish;
    end

endmodule

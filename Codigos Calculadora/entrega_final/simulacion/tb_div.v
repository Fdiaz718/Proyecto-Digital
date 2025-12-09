`timescale 1ns/1ps

module tb_div;

    reg clk;
    reg reset;
    reg start;
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] Q;
    wire [7:0] R;
    wire busy;
    wire done;
    wire div_zero;
    
    div_top dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .A(A),
        .B(B),
        .Q(Q),
        .R(R),
        .busy(busy),
        .done(done),
        .div_zero(div_zero)
    );
    
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    initial begin
        reset = 1;
        start = 0;
        A = 8'd0;
        B = 8'd0;
        
        $dumpfile("divisor.vcd");
        $dumpvars(0, tb_div);
        
        $display("Inicio de pruebas - Divisor");
        
        #50;
        reset = 0;
        #20;
        
        // Test 1: 15 / 3 = 5, residuo 0
        $display("\nTest 1: 15 / 3");
        A = 8'd15;
        B = 8'd3;
        start = 1;
        #20;
        start = 0;
        wait(done == 1);
        #20;
        
        if (Q == 8'd5 && R == 8'd0)
            $display("PASS - Cociente: %d, Residuo: %d", Q, R);
        else
            $display("FAIL - Esperado: Q=5 R=0, Obtenido: Q=%d R=%d", Q, R);
        
        #100;
        
        // Test 2: 20 / 4 = 5, residuo 0
        $display("\nTest 2: 20 / 4");
        A = 8'd20;
        B = 8'd4;
        start = 1;
        #20;
        start = 0;
        wait(done == 1);
        #20;
        
        if (Q == 8'd5 && R == 8'd0)
            $display("PASS - Cociente: %d, Residuo: %d", Q, R);
        else
            $display("FAIL - Esperado: Q=5 R=0, Obtenido: Q=%d R=%d", Q, R);
        
        #100;
        
        // Test 3: 17 / 5 = 3, residuo 2
        $display("\nTest 3: 17 / 5");
        A = 8'd17;
        B = 8'd5;
        start = 1;
        #20;
        start = 0;
        wait(done == 1);
        #20;
        
        if (Q == 8'd3 && R == 8'd2)
            $display("PASS - Cociente: %d, Residuo: %d", Q, R);
        else
            $display("FAIL - Esperado: Q=3 R=2, Obtenido: Q=%d R=%d", Q, R);
        
        #100;
        
        // Test 4: 255 / 10 = 25, residuo 5
        $display("\nTest 4: 255 / 10");
        A = 8'd255;
        B = 8'd10;
        start = 1;
        #20;
        start = 0;
        wait(done == 1);
        #20;
        
        if (Q == 8'd25 && R == 8'd5)
            $display("PASS - Cociente: %d, Residuo: %d", Q, R);
        else
            $display("FAIL - Esperado: Q=25 R=5, Obtenido: Q=%d R=%d", Q, R);
        
        #100;
        
        // Test 5: division por cero 100 / 0
        $display("\nTest 5: 100 / 0 (div por cero)");
        A = 8'd100;
        B = 8'd0;
        start = 1;
        #20;
        start = 0;
        wait(done == 1);
        #20;
        
        if (div_zero == 1'b1)
            $display("PASS - Flag div_zero activo");
        else
            $display("FAIL - Flag div_zero debería estar activo");
        
        #200;
        
        $display("\nFin de pruebas");
        $finish;
    end
    
    initial begin
        $monitor("t=%0t | A=%d B=%d | Q=%d R=%d | busy=%b done=%b div_zero=%b", 
                 $time, A, B, Q, R, busy, done, div_zero);
    end

endmodule


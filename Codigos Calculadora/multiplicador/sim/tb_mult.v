`timescale 1ns/1ps

module tb_mult;

    reg clk;
    reg reset;
    reg start;
    reg [7:0] A;
    reg [7:0] B;
    wire [15:0] P;
    wire busy;
    wire done;
    
    mult_top dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .A(A),
        .B(B),
        .P(P),
        .busy(busy),
        .done(done)
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
        
        $dumpfile("multiplicador.vcd");
        $dumpvars(0, tb_mult);
        
        $display("Inicio de pruebas");
        
        #50;
        reset = 0;
        #20;
        
        // Acà està el test 1: 5 x 3
        $display("Test 1: 5 x 3");
        A = 8'd5;
        B = 8'd3;
        start = 1;
        #20;
        start = 0;
        wait(done == 1);
        #20;
        
        if (P == 16'd15)
            $display("PASS - Resultado: %d", P);
        else
            $display("FAIL - Esperado: 15, Obtenido: %d", P);
        
        #100;
        
        // Este serìa el test 2: 12 x 8
        $display("Test 2: 12 x 8");
        A = 8'd12;
        B = 8'd8;
        start = 1;
        #20;
        start = 0;
        wait(done == 1);
        #20;
        
        if (P == 16'd96)
            $display("PASS - Resultado: %d", P);
        else
            $display("FAIL - Esperado: 96, Obtenido: %d", P);
        
        #100;
        
        // Acà tenemos el test 3: 255 x 255
        $display("Test 3: 255 x 255");
        A = 8'd255;
        B = 8'd255;
        start = 1;
        #20;
        start = 0;
        wait(done == 1);
        #20;
        
        if (P == 16'd65025)
            $display("PASS - Resultado: %d", P);
        else
            $display("FAIL - Esperado: 65025, Obtenido: %d", P);
        
        #100;
        
        //Despuès el test 4: multiplicacion por 0
        $display("Test 4: 100 x 0");
        A = 8'd100;
        B = 8'd0;
        start = 1;
        #20;
        start = 0;
        wait(done == 1);
        #20;
        
        if (P == 16'd0)
            $display("PASS - Resultado: %d", P);
        else
            $display("FAIL - Esperado: 0, Obtenido: %d", P);
        
        #100;
        
        // Y por el ùltimo el test 5: 15 x 7
        $display("Test 5: 15 x 7");
        A = 8'd15;
        B = 8'd7;
        start = 1;
        #20;
        start = 0;
        wait(done == 1);
        #20;
        
        if (P == 16'd105)
            $display("PASS - Resultado: %d", P);
        else
            $display("FAIL - Esperado: 105, Obtenido: %d", P);
        
        #200;
        
        $display("Fin de pruebas");
        $finish;
    end
    
    initial begin
        $monitor("t=%0t | A=%d B=%d | P=%d | busy=%b done=%b", 
                 $time, A, B, P, busy, done);
    end

endmodule

// =============================================================================
// BCD CONVERTER TESTBENCH 
// =============================================================================

`timescale 1ns/1ps

module bcd_converter_tb;

reg clk;
reg reset;
reg start;
reg [7:0] A;

wire [3:0] X;              // Ones
wire [3:0] X_prime;        // Tens
wire [3:0] X_prime_prime;  // Hundreds
wire done;
wire valid;

// Instantiate BCD converter
bcd_converter #(
    .WIDTH(8)
) uut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .A(A),
    .X(X),
    .X_prime(X_prime),
    .X_prime_prime(X_prime_prime),
    .done(done),
    .valid(valid)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
    $display("Starting BCD testbench...");
end

// Test stimulus
integer passed = 0;
integer failed = 0;

initial begin
    $dumpfile("bcd_converter.vcd");
    $dumpvars(0, bcd_converter_tb);
    
    $display("\n=========================================");
    $display("BCD Converter Test");
    $display("=========================================\n");
    
    // Reset
    reset = 1;
    start = 0;
    A = 0;
    #20;
    reset = 0;
    #10;
    
    // Test cases
    test_bcd(0, 0, 0, 0);      // 0 → 000
    test_bcd(9, 0, 0, 9);      // 9 → 009
    test_bcd(10, 0, 1, 0);     // 10 → 010
    test_bcd(25, 0, 2, 5);     // 25 → 025
    test_bcd(99, 0, 9, 9);     // 99 → 099
    test_bcd(100, 1, 0, 0);    // 100 → 100
    test_bcd(123, 1, 2, 3);    // 123 → 123
    test_bcd(255, 2, 5, 5);    // 255 → 255
    
    // Summary
    $display("\n=========================================");
    $display("Test Summary:");
    $display("PASSED: %0d", passed);
    $display("FAILED: %0d", failed);
    $display("=========================================\n");
    
    #100;
    $finish;
end

// Task to test BCD conversion
task test_bcd;
    input [7:0] input_val;
    input [3:0] exp_hundreds;
    input [3:0] exp_tens;
    input [3:0] exp_ones;
    reg [11:0] result_bcd;
    reg [11:0] expected_bcd;
    begin
        // Reset
        reset = 1;
        #10;
        reset = 0;
        #10;
        
        // Start conversion
        A = input_val;
        start = 1;
        #10;
        start = 0;
        
        // Wait for done
        wait(done == 1);
        #10;
        
        // Check result
        result_bcd = {X_prime_prime, X_prime, X};
        expected_bcd = {exp_hundreds, exp_tens, exp_ones};
        
        if (result_bcd == expected_bcd) begin
            $display("PASS: %3d → %1d%1d%1d", input_val, X_prime_prime, X_prime, X);
            passed = passed + 1;
        end else begin
            $display("FAIL: %3d → %1d%1d%1d (expected %1d%1d%1d)", 
                     input_val, X_prime_prime, X_prime, X,
                     exp_hundreds, exp_tens, exp_ones);
            failed = failed + 1;
        end
    end
endtask

endmodule

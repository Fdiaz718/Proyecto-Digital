// ---------------------------------------------------------
// Calculadora Digital - Núcleo Integrador
// ---------------------------------------------------------
module calc_core (
    input  wire        clk,
    input  wire        reset,
    input  wire        start,
    input  wire [1:0]  op,
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output reg  [15:0] result,
    output reg         busy,
    output reg         done,
    output reg         error
);

    // Señales del multiplicador
    wire [15:0] mult_result;
    wire        mult_busy, mult_done;
    reg         mult_start;
    
    // Señales del divisor
    wire [7:0]  div_Q, div_R;
    wire        div_busy, div_done, div_zero;
    reg         div_start;
    
    // Señales de raíz cuadrada
    wire [9:0]  sqrt_result;
    wire        sqrt_done;
    reg         sqrt_start;
    
    // Señales de BCD
    wire [3:0]  bcd_ones, bcd_tens, bcd_hundreds;
    wire        bcd_done, bcd_valid;
    reg         bcd_start;
    
    // Instanciar multiplicador
    mult_top mult (
        .clk(clk),
        .reset(reset),
        .start(mult_start),
        .A(A),
        .B(B),
        .P(mult_result),
        .busy(mult_busy),
        .done(mult_done)
    );
    
    // Instanciar divisor
    div_top div (
        .clk(clk),
        .reset(reset),
        .start(div_start),
        .A(A),
        .B(B),
        .Q(div_Q),
        .R(div_R),
        .busy(div_busy),
        .done(div_done),
        .div_zero(div_zero)
    );
    
    // Instanciar raíz cuadrada
    top sqrt (
        .clk(clk),
        .reset(reset),
        .Start(sqrt_start),
        .A(A),
        .Result(sqrt_result),
        .Done(sqrt_done)
    );
    
    // Instanciar conversor BCD
    bcd_converter #(.WIDTH(8)) bcd (
        .clk(clk),
        .reset(reset),
        .start(bcd_start),
        .A(A),
        .X(bcd_ones),
        .X_prime(bcd_tens),
        .X_prime_prime(bcd_hundreds),
        .done(bcd_done),
        .valid(bcd_valid)
    );
    
    // Lógica de control
    always @(*) begin
        mult_start = 1'b0;
        div_start = 1'b0;
        sqrt_start = 1'b0;
        bcd_start = 1'b0;
        
        case (op)
            2'b00: mult_start = start;
            2'b01: div_start = start;
            2'b10: sqrt_start = start;
            2'b11: bcd_start = start;
        endcase
    end
    
    // Multiplexar salidas
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 16'd0;
            busy <= 1'b0;
            done <= 1'b0;
            error <= 1'b0;
        end else begin
            case (op)
                2'b00: begin
                    result <= mult_result;
                    busy <= mult_busy;
                    done <= mult_done;
                    error <= 1'b0;
                end
                
                2'b01: begin
                    result <= {div_Q, div_R};
                    busy <= div_busy;
                    done <= div_done;
                    error <= div_zero;
                end
                
                2'b10: begin
                    result <= {6'd0, sqrt_result};
                    busy <= ~sqrt_done;
                    done <= sqrt_done;
                    error <= 1'b0;
                end
                
                2'b11: begin
                    result <= {4'd0, bcd_hundreds, bcd_tens, bcd_ones};
                    busy <= ~bcd_done;
                    done <= bcd_done;
                    error <= ~bcd_valid;
                end
            endcase
        end
    end

endmodule

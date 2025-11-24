// peripheral_sqrt.v
// Estè serìa el wrapper de la raiz cuadrada para conectarlo al SOC

module peripheral_sqrt(
    input wire clk,
    input wire reset,
    input wire [7:0] d_in,   // solo un operando
    input wire cs,
    input wire [4:0] addr,
    input wire rd,
    input wire wr,
    output reg [31:0] d_out
);

    reg start;
    reg [7:0] A;
    wire [3:0] X;
    wire done, valid;

    sqrt_calculator sqrt1 (
        .clk(clk),
        .reset(reset),
        .start(start),
        .A(A),
        .X(X),
        .done(done),
        .valid(valid)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 0;
            start <= 0;
        end else if (cs & wr) begin
            A <= d_in;
            start <= 1;
        end else begin
            start <= 0;
        end
    end

    // logica de lectura
    always @(*) begin
        if (cs & rd) begin
            d_out = {28'd0, X}; 
        end else begin
            d_out = 32'd0;
        end
    end

endmodule



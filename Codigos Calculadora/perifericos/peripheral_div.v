// peripheral_div.v
// Nuestro wrapper del divisor para conectarlo al SOC

module peripheral_div(
    input wire clk,
    input wire reset,
    input wire [15:0] d_in,  
    input wire cs,
    input wire [4:0] addr,
    input wire rd,
    input wire wr,
    output reg [31:0] d_out
);

    reg start;
    reg [7:0] A, B;
    wire [7:0] Q, R;
    wire busy, done, div_zero;

    div_top div1 (
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

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 0;
            B <= 0;
            start <= 0;
        end else if (cs & wr) begin
            A <= d_in[7:0];
            B <= d_in[15:8];
            start <= 1;
        end else begin
            start <= 0;
        end
    end

    // logica de lectura
    always @(*) begin
        if (cs & rd) begin
            d_out = {16'd0, Q}; // para simplificar, solo devuelvo el cociente
        end else begin
            d_out = 32'd0;
        end
    end

endmodule
e


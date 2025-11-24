// Wrapper de raíz cuadrada para FemtoRV32

module peripheral_sqrt (
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
    reg [7:0] A;
    wire [7:0] X;
    wire done, valid;

    sqrt_calculator sqrt (
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
            start <= 0;
            A <= 0;
            d_out <= 0;
        end else if (cs) begin
            if (wr) begin
                A <= d_in[7:0];
                start <= 1;
            end else begin
                start <= 0;
            end

            if (rd) begin
                d_out <= {24'd0, X};
            end
        end
    end

endmodule


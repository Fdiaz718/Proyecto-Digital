// Wrapper del divisor 8÷8 para FemtoRV32

module peripheral_div (
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

    div_top div (
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
            start <= 0;
            A <= 0;
            B <= 0;
            d_out <= 0;
        end else if (cs) begin
            if (wr) begin
                A <= d_in[15:8];
                B <= d_in[7:0];
                start <= 1;
            end else begin
                start <= 0;
            end

            if (rd) begin
                d_out <= {24'd0, Q, R}; 
            end
        end
    end

endmodule


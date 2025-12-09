// Este serìa nuestro Wrapper del conversor binario a BCD para FemtoRV32

module peripheral_bcd (
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
    wire [3:0] X, X_prime, X_prime_prime;
    wire done, valid;

    bcd_converter #(.WIDTH(8)) bcd (
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
                d_out <= {20'd0, X_prime_prime, X_prime, X};
            end
        end
    end

endmodule

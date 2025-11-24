// peripheral_bcd.v
// ESte serìa el wrapper del conversor BCD para conectarlo al SOC

module peripheral_bcd(
    input wire clk,
    input wire reset,
    input wire [7:0] d_in,  
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

    bcd_converter bcd1 (
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
            A <= 0;
            start <= 0;
        end else if (cs & wr) begin
            A <= d_in;
            start <= 1;
        end else begin
            start <= 0;
        end
    end

 
    always @(*) begin
        if (cs & rd) begin
            d_out = {X_prime_prime, X_prime, X, 20'd0}; // concateno en 32 bits
        end else begin
            d_out = 32'd0;
        end
    end

endmodule

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
    reg Start;
    reg [7:0] A;
    wire [9:0] Result;
    wire Done;
    
    top sqrt (
        .clk(clk),
        .reset(reset),
        .Start(Start),
        .A(A),
        .Result(Result),
        .Done(Done)
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Start <= 0;
            A <= 0;
            d_out <= 0;
        end else if (cs) begin
            if (wr) begin
                A <= d_in[7:0];
                Start <= 1;
            end else begin
                Start <= 0;
            end
            
            if (rd) begin
                d_out <= {22'd0, Result};  // Result es de 10 bits
            end
        end
    end
endmodule

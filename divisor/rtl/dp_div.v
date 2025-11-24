// Datapath del divisor - metodo de restas secuenciales
module dp_div (
    input wire clk,
    input wire reset,
    input wire [7:0] A_in,
    input wire [7:0] B_in,
    input wire load,
    input wire subtract,
    input wire inc_Q,
    output reg [7:0] Q,
    output reg [7:0] R,
    output wire div_zero,
    output wire R_gte_B
);

    reg [7:0] B_reg;
    
    assign div_zero = (B_reg == 8'd0);
    assign R_gte_B = (R >= B_reg);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 8'd0;
            R <= 8'd0;
            B_reg <= 8'd0;
        end 
        else begin
            if (load) begin
                R <= A_in;
                Q <= 8'd0;
                B_reg <= B_in;
            end
            
            if (subtract) begin
                R <= R - B_reg;
            end
            
            if (inc_Q) begin
                Q <= Q + 1;
            end
        end
    end

endmodule

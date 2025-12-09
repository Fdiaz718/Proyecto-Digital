// En el presente archivo tengo el datapath del multiplicador
module dp_mult (
    input wire clk,
    input wire reset,
    input wire [7:0] A_in,
    input wire [7:0] B_in,
    input wire load,
    input wire add,
    input wire shift,
    input wire clear_P,
    input wire dec_count,
    output reg [15:0] P,
    output wire [7:0] A_reg_out,
    output wire [7:0] B_reg_out,
    output wire B_bit0,
    output wire count_zero
);

    reg [15:0] A_reg;  
    reg [7:0] B_reg;
    reg [3:0] count;
    
    assign A_reg_out = A_reg[7:0];  
    assign B_reg_out = B_reg;
    assign B_bit0 = B_reg[0];
    assign count_zero = (count == 4'd0);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A_reg <= 16'd0;
            B_reg <= 8'd0;
            P <= 16'd0;
            count <= 4'd0;
        end 
        else begin
            if (load) begin
                A_reg <= {8'd0, A_in};  // EN esta parte se carga con extensión a 16 bits
                B_reg <= B_in;
                count <= 4'd8;
            end
            
            if (clear_P) 
                P <= 16'd0;
            
            if (add) 
                P <= P + A_reg;  //Aqui especificamente se lleva a cabo lo que serìa la suma directa
            
            if (shift) begin
                A_reg <= A_reg << 1;  //Este es el esplazamiento de 16 bits
                B_reg <= B_reg >> 1;
            end
            
            if (dec_count) 
                count <= count - 1;
        end
    end

endmodule

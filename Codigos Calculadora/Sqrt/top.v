// ============================================
// TOP - Según el flujo exacto del algoritmo
// ============================================
module top(
    input wire clk,
    input wire reset,
    input wire Start,
    input wire [7:0] A,
    output wire [9:0] Result,
    output wire Done
);

    wire Init, Sub1, Shift_A, Compare, Sub_X, Set_X0, Set_X1, Update_X;
    wire Rsl_X;
    wire [3:0] n;
    
    reg [9:0] A_pp;
    reg [7:0] A_reg;
    reg [9:0] X_pp;
    reg       X;
    reg [3:0] n_reg;
    
    assign n = n_reg;
    assign Result = X_pp;
    assign Rsl_X = (A_pp >= ((X_pp << 2) + 10'd1));
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A_pp   <= 10'd0;
            A_reg  <= 8'd0;
            X_pp   <= 10'd0;
            X      <= 1'b0;
            n_reg  <= 4'd0;
        end
        else begin
            // Paso 1: X'' = 1, cargar primeros 2 bits
            if (Init) begin
                X_pp  <= 10'd1;               // X'' = 1
                A_pp  <= {8'd0, A[7:6]};      // Cargar primeros 2 bits en A''
                A_reg <= {A[5:0], 2'b00};     // Resto alineado (6 bits = 3 pares)
                X     <= 1'b0;
                n_reg <= 4'd3;                // Solo 3 iteraciones más
            end
            
            // Paso 2: A'' = A'' - 1
            if (Sub1) begin
                A_pp <= A_pp - 10'd1;
            end
            
            // Paso 3: Correr A'' 2 posiciones
            if (Shift_A) begin
                A_pp  <= {A_pp[7:0], A_reg[7:6]};
                A_reg <= {A_reg[5:0], 2'b00};
            end
            
            // Paso 5: A'' = A'' - [(X''<<2) + 1]
            if (Sub_X) begin
                A_pp <= A_pp - ((X_pp << 2) + 10'd1);
            end
            
            // Paso 6: X = 0
            if (Set_X0) begin
                X <= 1'b0;
            end
            
            // Paso 5: X = 1
            if (Set_X1) begin
                X <= 1'b1;
            end
            
            // Paso 7: X'' = X''<<1 + X
            if (Update_X) begin
                X_pp  <= {X_pp[8:0], X};
                n_reg <= n_reg - 4'd1;
            end
        end
    end
    
    control fsm(
        .clk(clk),
        .reset(reset),
        .Start(Start),
        .Rsl_X(Rsl_X),
        .n(n),
        .Init(Init),
        .Sub1(Sub1),
        .Shift_A(Shift_A),
        .Compare(Compare),
        .Sub_X(Sub_X),
        .Set_X0(Set_X0),
        .Set_X1(Set_X1),
        .Update_X(Update_X),
        .Done(Done)
    );

endmodule

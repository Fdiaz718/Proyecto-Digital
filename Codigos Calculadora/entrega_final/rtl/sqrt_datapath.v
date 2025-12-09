// ============================================
// DATAPATH - Camino de datos
// ============================================
module datapath(
    input wire clk,
    input wire reset,
    input wire [7:0] A,           // Entrada original (8 bits)
    
    // Señales de control desde FSM
    input wire Ld_A,              // Cargar A en registros
    input wire Ld_A_pp,           // Cargar A'' (vacío)
    input wire Ld_X,              // Cargar X'' = 1
    input wire Shf_A_pp,          // Shift A''
    input wire Shf_X,             // Shift X
    
    // Señales hacia FSM
    output wire Rsl_X,            // Resultado de comparacion
    output wire Act_X             // Estado de X (no usado pero en diagrama)
);

    // Registros internos
    reg [9:0] A_pp;          // A'' - parte procesada (10 bits)
    reg [7:0] A_reg;         // A - copia interna de entrada
    reg [9:0] X_pp;          // X'' - resultado (10 bits)
    reg       X;             // X - bit temporal
    reg [3:0] n;             // Contador
    
    // Salidas
    assign Rsl_X = (A_pp >= (X_pp << 2));  // Comparacion: A'' >= (X''<<2)?
    assign Act_X = X;
    
    // Logica del datapath
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A_pp   <= 10'd0;
            A_reg  <= 8'd0;
            X_pp   <= 10'd0;
            X      <= 1'b0;
            n      <= 4'd0;
        end
        else begin
            // Cargar A
            if (Ld_A) begin
                A_reg <= A;           // Guardar entrada
                n     <= 4'd4;        // n = 4 iteraciones
            end
            
            // Cargar A'' (inicializar vacío)
            if (Ld_A_pp) begin
                A_pp <= 10'd0;        // A'' empieza vacío
            end
            
            // Cargar X'' = 1
            if (Ld_X) begin
                X_pp <= 10'd1;        // X'' = 1
                X    <= 1'b1;         // X = 1
            end
            
            // Shift A'': A'' = A''<<2 + 2 bits de A_reg, X=1
            if (Shf_A_pp) begin
                A_pp  <= {A_pp[7:0], A_reg[7:6]};  // Desplazar A'' y tomar 2 bits
                A_reg <= {A_reg[5:0], 2'b00};      // Consumir bits de A_reg
                X     <= 1'b1;                     // X = 1
            end
            
            // Shift X: X'' = X''<<1 + X, n = n-1
            if (Shf_X) begin
                X_pp <= {X_pp[8:0], X};   // Desplazar X'' e insertar X
                n    <= n - 4'd1;         // Decrementar contador
            end
        end
    end

endmodule

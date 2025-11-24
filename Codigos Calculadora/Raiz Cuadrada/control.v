// ============================================
// CONTROL - FSM según el flujo exacto
// ============================================
module control(
    input wire clk,
    input wire reset,
    input wire Start,
    input wire Rsl_X,
    input wire [3:0] n,
    
    output reg Init,         // Paso 1: X''=1, correr A''
    output reg Sub1,         // Paso 2: A'' = A'' - 1
    output reg Shift_A,      // Paso 3: correr A'' 2 posiciones
    output reg Compare,      // Paso 4: comparar
    output reg Sub_X,        // Paso 5: A'' = A'' - [(X''<<2)+1]
    output reg Set_X0,       // Paso 6: X = 0
    output reg Set_X1,       // Paso 5: X = 1
    output reg Update_X,     // Paso 7: X'' = X''<<1 + X
    output reg Done
);

    localparam [2:0]
        S_Idle    = 3'd0,
        S_Init    = 3'd1,    // Paso 1
        S_Sub1    = 3'd2,    // Paso 2
        S_Shift   = 3'd3,    // Paso 3
        S_Compare = 3'd4,    // Paso 4
        S_Sub     = 3'd5,    // Pasos 5 y 6
        S_Update  = 3'd6,    // Paso 7
        S_End     = 3'd7;
    
    reg [2:0] estado;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            estado <= S_Idle;
        end
        else begin
            case (estado)
                S_Idle:
                    if (Start) estado <= S_Init;
                
                S_Init:     // Paso 1
                    estado <= S_Sub1;
                
                S_Sub1:     // Paso 2
                    estado <= S_Shift;
                
                S_Shift:    // Paso 3
                    estado <= S_Compare;
                
                S_Compare:  // Paso 4
                    estado <= S_Sub;
                
                S_Sub:      // Pasos 5/6
                    estado <= S_Update;
                
                S_Update:   // Paso 7
                    if (n > 4'd1)  // Usar > 1 en lugar de != 0
                        estado <= S_Shift;  // Volver a paso 3
                    else
                        estado <= S_End;
                
                S_End:
                    estado <= S_Idle;
                
                default:
                    estado <= S_Idle;
            endcase
        end
    end
    
    always @(*) begin
        Init      = 0;
        Sub1      = 0;
        Shift_A   = 0;
        Compare   = 0;
        Sub_X     = 0;
        Set_X0    = 0;
        Set_X1    = 0;
        Update_X  = 0;
        Done      = 0;
        
        case (estado)
            S_Init: begin
                Init = 1;  // Paso 1: X''=1, cargar primeros bits
            end
            
            S_Sub1: begin
                Sub1 = 1;  // Paso 2: A'' = A'' - 1
            end
            
            S_Shift: begin
                Shift_A = 1;  // Paso 3: correr A''
            end
            
            S_Compare: begin
                Compare = 1;  // Paso 4: comparar
            end
            
            S_Sub: begin
                if (Rsl_X) begin
                    Sub_X  = 1;  // Paso 5: restar
                    Set_X1 = 1;  // X = 1
                end else begin
                    Set_X0 = 1;  // Paso 6: X = 0
                end
            end
            
            S_Update: begin
                Update_X = 1;  // Paso 7: X'' = X''<<1 + X
            end
            
            S_End: begin
                Done = 1;
            end
        endcase
    end

endmodule

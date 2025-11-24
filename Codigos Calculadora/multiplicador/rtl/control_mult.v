// Acà se muestra el FSM para control del multiplicador
// LOs distintos estados son: IDLE, LOAD, CHECK, ADD, SHIFT, DONE
module control_mult (
    input wire clk,
    input wire reset,
    input wire start,
    input wire B_bit0,
    input wire count_zero,
    output reg load,
    output reg add,
    output reg shift,
    output reg clear_P,
    output reg dec_count,
    output reg busy,
    output reg done
);

    // Acà tengo la definicion de estados
    localparam [2:0] 
        IDLE    = 3'd0,
        LOAD    = 3'd1,
        CHECK   = 3'd2,
        ADD     = 3'd3,
        SHIFT   = 3'd4,
        DONE_ST = 3'd5;
    
    reg [2:0] state, next_state;
    
    // Esta secciòn serìa correspondiente al registro de estado
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    // En esta parte se encuentra la lògica combinacional - siguiente estado
    always @(*) begin
        next_state = state;
        
        case (state)
            IDLE: begin
                if (start)
                    next_state = LOAD;
            end
            
            LOAD: begin
                next_state = CHECK;
            end
            
            CHECK: begin
                if (B_bit0)
                    next_state = ADD;
                else
                    next_state = SHIFT;
            end
            
            ADD: begin
                next_state = SHIFT;
            end
            
            SHIFT: begin
                if (count_zero)
                    next_state = DONE_ST;
                else
                    next_state = CHECK;
            end
            
            DONE_ST: begin
                next_state = IDLE;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end
    
    // Aca lo que tengo es la combinacional - salidas
    always @(*) begin
        // Valores por defecto
        load = 1'b0;
        add = 1'b0;
        shift = 1'b0;
        clear_P = 1'b0;
        dec_count = 1'b0;
        busy = 1'b0;
        done = 1'b0;
        
        case (state)
            IDLE: begin
                busy = 1'b0;
                done = 1'b0;
            end
            
            LOAD: begin
                load = 1'b1;
                clear_P = 1'b1;
                busy = 1'b1;
            end
            
            CHECK: begin
                busy = 1'b1;
            end
            
            ADD: begin
                add = 1'b1;
                busy = 1'b1;
            end
            
            SHIFT: begin
                shift = 1'b1;
                dec_count = 1'b1;
                busy = 1'b1;
            end
            
            DONE_ST: begin
                done = 1'b1;
                busy = 1'b0;
            end
            
            default: begin
                busy = 1'b0;
                done = 1'b0;
            end
        endcase
    end

endmodule

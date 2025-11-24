// FSM para control del divisor - restas secuenciales
module control_div (
    input wire clk,
    input wire reset,
    input wire start,
    input wire div_zero,
    input wire R_gte_B,
    output reg load,
    output reg subtract,
    output reg inc_Q,
    output reg busy,
    output reg done
);

    localparam [2:0] 
        IDLE       = 3'd0,
        LOAD       = 3'd1,
        CHECK_ZERO = 3'd2,
        CHECK      = 3'd3,
        SUBTRACT   = 3'd4,
        DONE_ST    = 3'd5;
    
    reg [2:0] state, next_state;
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    always @(*) begin
        next_state = state;
        
        case (state)
            IDLE: begin
                if (start)
                    next_state = LOAD;
            end
            
            LOAD: begin
                next_state = CHECK_ZERO;
            end
            
            CHECK_ZERO: begin
                if (div_zero)
                    next_state = DONE_ST;
                else
                    next_state = CHECK;
            end
            
            CHECK: begin
                if (R_gte_B)
                    next_state = SUBTRACT;
                else
                    next_state = DONE_ST;
            end
            
            SUBTRACT: begin
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
    
    always @(*) begin
        load = 1'b0;
        subtract = 1'b0;
        inc_Q = 1'b0;
        busy = 1'b0;
        done = 1'b0;
        
        case (state)
            IDLE: begin
                busy = 1'b0;
                done = 1'b0;
            end
            
            LOAD: begin
                load = 1'b1;
                busy = 1'b1;
            end
            
            CHECK_ZERO: begin
                busy = 1'b1;
            end
            
            CHECK: begin
                busy = 1'b1;
            end
            
            SUBTRACT: begin
                subtract = 1'b1;
                inc_Q = 1'b1;
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

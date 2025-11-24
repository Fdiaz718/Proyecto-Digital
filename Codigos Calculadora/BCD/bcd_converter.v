module bcd_converter #(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [WIDTH-1:0] A,
    output reg [3:0] X,
    output reg [3:0] X_prime,
    output reg [3:0] X_prime_prime,
    output reg done,
    output reg valid
);

// FSM states
localparam START  = 3'd0;
localparam INIT   = 3'd1;
localparam CHECK  = 3'd2;
localparam ADD3   = 3'd3;
localparam SHIFT  = 3'd4;
localparam DONE   = 3'd5;

reg [2:0] state, next_state;

// Registers
reg [3:0] X_reg, X_prime_reg, X_prime_prime_reg;
reg [WIDTH-1:0] binary;
reg [4:0] n;

reg add3_ones, add3_tens, add3_hundreds;

// FSM: state register
always @(posedge clk or posedge reset) begin
    if (reset)
        state <= START;
    else
        state <= next_state;
end

// FSM: next state logic
always @(*) begin
    case (state)
        START:
            next_state = (start) ? INIT : START;

        INIT:
            next_state = CHECK;

        CHECK:
            next_state = ADD3;

        ADD3:
            next_state = SHIFT;

        SHIFT:
            next_state = (n == 1) ? DONE : CHECK;

        DONE:
            next_state = (start) ? INIT : START;

        default:
            next_state = START;
    endcase
end

// Main logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        X_reg <= 0;
        X_prime_reg <= 0;
        X_prime_prime_reg <= 0;
        binary <= 0;
        n <= 0;
        add3_ones <= 0;
        add3_tens <= 0;
        add3_hundreds <= 0;
        X <= 0;
        X_prime <= 0;
        X_prime_prime <= 0;
        done <= 0;
        valid <= 0;
    end else begin
        case (state)
            START: begin
                done <= 0;
                valid <= 0;
            end

            INIT: begin
                X_reg <= 0;
                X_prime_reg <= 0;
                X_prime_prime_reg <= 0;
                binary <= A;
                n <= WIDTH;
                done <= 0;
                valid <= 0;
            end

            CHECK: begin
                add3_ones     <= (X_reg >= 5);
                add3_tens     <= (X_prime_reg >= 5);
                add3_hundreds <= (X_prime_prime_reg >= 5);
            end

            ADD3: begin
                if (add3_ones)
                    X_reg <= X_reg + 3;

                if (add3_tens)
                    X_prime_reg <= X_prime_reg + 3;

                if (add3_hundreds)
                    X_prime_prime_reg <= X_prime_prime_reg + 3;
            end

            SHIFT: begin
                X_prime_prime_reg <= {X_prime_prime_reg[2:0], X_prime_reg[3]};
                X_prime_reg        <= {X_prime_reg[2:0], X_reg[3]};
                X_reg              <= {X_reg[2:0], binary[WIDTH-1]};
                binary             <= {binary[WIDTH-2:0], 1'b0};
                n <= n - 1;
            end

            DONE: begin
                X <= X_reg;
                X_prime <= X_prime_reg;
                X_prime_prime <= X_prime_prime_reg;
                done <= 1;
                valid <= 1;
                $display("BCD Result: %1d%1d%1d", X_prime_prime_reg, X_prime_reg, X_reg);  // Optional debug
            end
        endcase
    end
end

endmodule


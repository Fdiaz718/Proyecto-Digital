
// Módulo superior del divisor 8÷8

module div_top (
    input  wire        clk,
    input  wire        reset,
    input  wire        start,
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output wire [7:0]  Q,
    output wire [7:0]  R,
    output wire        busy,
    output wire        done,
    output wire        div_zero
);

    wire load;
    wire subtract;
    wire inc_Q;
    wire R_gte_B;

    dp_div datapath (
        .clk(clk),
        .reset(reset),
        .A_in(A),
        .B_in(B),
        .load(load),
        .subtract(subtract),
        .inc_Q(inc_Q),
        .Q(Q),
        .R(R),
        .div_zero(div_zero),
        .R_gte_B(R_gte_B)
    );

    control_div fsm (
        .clk(clk),
        .reset(reset),
        .start(start),
        .div_zero(div_zero),
        .R_gte_B(R_gte_B),
        .load(load),
        .subtract(subtract),
        .inc_Q(inc_Q),
        .busy(busy),
        .done(done)
    );

endmodule

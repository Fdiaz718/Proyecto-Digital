
// Este es el mòdulo superior del multiplicador secuencial 8x8
// Lo que hace es que conecta la máquina de estados con el camino
// de datos. La FSM genera las señales de control y el 
// datapath hace las operaciones las cuales vedrìan siedo:
//
//  - la carga de operandos
//  - la suma condicional
//  - los respectivos desplazamientos
//  - y el contador de iteraciones
//
// El resultado final aparece en P y la FSM indica cuando
// el cálculo ya se terminó.
module mult_top (
    input  wire        clk,
    input  wire        reset,
    input  wire        start,
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output wire [15:0] P,
    output wire        busy,
    output wire        done
);

    // Estas son mis señales internas entre control y datapath
    wire load;
    wire add;
    wire shift;
    wire clear_P;
    wire dec_count;
    wire B_bit0;
    wire count_zero;

 
    // Esta parte corresponde al camino de datos
    dp_mult datapath (
        .clk(clk),
        .reset(reset),
        .A_in(A),
        .B_in(B),
        .load(load),
        .add(add),
        .shift(shift),
        .clear_P(clear_P),
        .dec_count(dec_count),
        .P(P),
        .A_reg_out(),
        .B_reg_out(),
        .B_bit0(B_bit0),
        .count_zero(count_zero)
    );


    // Maq de control
    control_mult fsm (
        .clk(clk),
        .reset(reset),
        .start(start),
        .B_bit0(B_bit0),
        .count_zero(count_zero),
        .load(load),
        .add(add),
        .shift(shift),
        .clear_P(clear_P),
        .dec_count(dec_count),
        .busy(busy),
        .done(done)
    );

endmodule

module SOC (
    input        clk,      // reloj del sistema
    input        resetn,   // botón de reset activo en bajo
    output wire  LEDS,     // LEDs del sistema
    input        RXD,      // UART RX
    output       TXD       // UART TX
);

    // -------------------------------
    // Señales del bus
    // -------------------------------
    wire [31:0] mem_addr;
    reg  [31:0] mem_rdata;
    wire mem_rstrb;
    wire [31:0] mem_wdata;
    wire [3:0]  mem_wmask;

    // -------------------------------
    // Instanciamos CPU FemtoRV32
    // -------------------------------
    FemtoRV32 CPU(
        .clk(clk),
        .reset(resetn),
        .mem_addr(mem_addr),
        .mem_rdata(mem_rdata),
        .mem_rstrb(mem_rstrb),
        .mem_wdata(mem_wdata),
        .mem_wmask(mem_wmask),
        .mem_rbusy(1'b0),
        .mem_wbusy(1'b0)
    );

    // -------------------------------
    // RAM simple (BRAM)
    // -------------------------------
    wire [31:0] RAM_rdata;
    wire wr = |mem_wmask;
    wire rd = mem_rstrb;

    bram RAM(
        .clk(clk),
        .mem_addr(mem_addr),
        .mem_rdata(RAM_rdata),
        .mem_rstrb(cs[0] & rd),
        .mem_wdata(mem_wdata),
        .mem_wmask({4{cs[0]}} & mem_wmask)
    );

    // -------------------------------
    // Señales de salida de periféricos
    // -------------------------------
    wire [31:0] uart_dout;
    wire [31:0] mult_dout;
    wire [31:0] div_dout;
    wire [31:0] sqrt_dout;
    wire [31:0] bcd_dout;

    // -------------------------------
    // Instanciamos periféricos
    // -------------------------------
    peripheral_uart per_uart(
        .clk(clk),
        .reset(!resetn),
        .d_in(mem_wdata),
        .cs(cs[5]),
        .addr(mem_addr[4:0]),
        .rd(rd),
        .wr(wr),
        .d_out(uart_dout),
        .uart_tx(TXD),
        .uart_rx(RXD),
        .ledout(LEDS)
    );

    peripheral_mult mult1(
        .clk(clk),
        .reset(!resetn),
        .d_in(mem_wdata[15:0]),
        .cs(cs[3]),
        .addr(mem_addr[4:0]),
        .rd(rd),
        .wr(wr),
        .d_out(mult_dout)
    );

    peripheral_div div1(
        .clk(clk),
        .reset(!resetn),
        .d_in(mem_wdata[15:0]),
        .cs(cs[2]),
        .addr(mem_addr[4:0]),
        .rd(rd),
        .wr(wr),
        .d_out(div_dout)
    );

    peripheral_sqrt sqrt1(
        .clk(clk),
        .reset(!resetn),
        .d_in(mem_wdata[7:0]),
        .cs(cs[6]),
        .addr(mem_addr[4:0]),
        .rd(rd),
        .wr(wr),
        .d_out(sqrt_dout)
    );

    peripheral_bcd bcd1(
        .clk(clk),
        .reset(!resetn),
        .d_in(mem_wdata[7:0]),
        .cs(cs[7]),
        .addr(mem_addr[4:0]),
        .rd(rd),
        .wr(wr),
        .d_out(bcd_dout)
    );

    // -------------------------------
    // Decodificador de chip select
    // -------------------------------
    reg [7:0] cs;
    always @* begin
        case (mem_addr[31:16])
            16'h0040: cs = 8'b01000000; // UART
            16'h0042: cs = 8'b00001000; // Multiplicador
            16'h0043: cs = 8'b00000100; // Divisor
            16'h0044: cs = 8'b00000010; // BCD
            16'h0046: cs = 8'b00000001; // Raíz cuadrada
            16'h0000: cs = 8'b00010000; // RAM
            default: cs = 8'b00010000;
        endcase
    end

    // -------------------------------
    // MUX de lectura para CPU
    // -------------------------------
    always @* begin
        case (1'b1)
            cs[5]: mem_rdata = uart_dout;
            cs[3]: mem_rdata = mult_dout;
            cs[2]: mem_rdata = div_dout;
            cs[7]: mem_rdata = bcd_dout;
            cs[6]: mem_rdata = sqrt_dout;
            cs[0]: mem_rdata = RAM_rdata;
            default: mem_rdata = RAM_rdata;
        endcase
    end

    // -------------------------------
    // UART debug (solo para testbench)
    // -------------------------------
    `ifdef BENCH
    always @(posedge clk) begin
        if(cs[5] & wr) begin
            $write("%c", mem_wdata[7:0]);
            $fflush(32'h8000_0001);
        end
    end
    `endif

endmodule


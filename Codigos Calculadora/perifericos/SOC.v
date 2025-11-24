// SOC.v


module SOC (
    input        clk,       
    input        resetn,    
    output wire  LEDS,     
    input        RXD,       
    output       TXD        
);

    
    // Señales internas del bus de memoria
  
    wire [31:0] mem_addr;
    reg  [31:0] mem_rdata;
    wire mem_rstrb;
    wire [31:0] mem_wdata;
    wire [3:0]  mem_wmask;

    FemtoRV32 CPU (
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

    wire [31:0] RAM_rdata;
    wire wr = |mem_wmask;
    wire rd = mem_rstrb;

    bram RAM (
        .clk(clk),
        .mem_addr(mem_addr),
        .mem_rdata(RAM_rdata),
        .mem_rstrb(cs[0] & rd),
        .mem_wdata(mem_wdata),
        .mem_wmask({4{cs[0]}} & mem_wmask)
    );

    wire [31:0] uart_dout;
    wire [31:0] mult_dout;
    wire [31:0] div_dout;
    wire [31:0] sqrt_dout;
    wire [31:0] bcd_dout;


    peripheral_uart #(
        .clk_freq(26000000),
        .baud(115200)
    ) per_uart (
        .clk(clk),
        .rst(!resetn),
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

    peripheral_mult mult1 (
        .clk(clk),
        .reset(!resetn),
        .d_in(mem_wdata[15:0]),
        .cs(cs[3]),
        .addr(mem_addr[4:0]),
        .rd(rd),
        .wr(wr),
        .d_out(mult_dout)
    );

    peripheral_div div1 (
        .clk(clk),
        .reset(!resetn),
        .d_in(mem_wdata[15:0]),
        .cs(cs[2]),
        .addr(mem_addr[4:0]),
        .rd(rd),
        .wr(wr),
        .d_out(div_dout)
    );

    peripheral_sqrt sqrt1 (
        .clk(clk),
        .reset(!resetn),
        .d_in(mem_wdata[7:0]),
        .cs(cs[1]),
        .addr(mem_addr[4:0]),
        .rd(rd),
        .wr(wr),
        .d_out(sqrt_dout)
    );

    peripheral_bcd bcd1 (
        .clk(clk),
        .reset(!resetn),
        .d_in(mem_wdata[7:0]),
        .cs(cs[4]),
        .addr(mem_addr[4:0]),
        .rd(rd),
        .wr(wr),
        .d_out(bcd_dout)
    );

 
    // Decodificador de direcciones
  
    reg [6:0] cs;

    always @* begin
        case (mem_addr[31:16])
            16'h0040: cs = 7'b0100000; // UART
            16'h0041: cs = 7'b0010000; // GPIO (si aplica)
            16'h0042: cs = 7'b0001000; // MULT
            16'h0043: cs = 7'b0000100; // DIV
            16'h0044: cs = 7'b0000010; // BCD
            16'h0045: cs = 7'b1000000; // DP RAM (si aplica)
            16'h0000: cs = 7'b0000001;  // RAM
            default:  cs = 7'b0000001;
        endcase
    end


    // MUX de lectura de datos

    always @* begin
        case (cs)
            7'b0100000: mem_rdata = uart_dout;
            7'b0001000: mem_rdata = mult_dout;
            7'b0000100: mem_rdata = div_dout;
            7'b0000010: mem_rdata = bcd_dout;
            7'b0000001: mem_rdata = RAM_rdata;
            default:     mem_rdata = 32'd0;
        endcase
    end

`ifdef BENCH
    always @(posedge clk) begin
        if(cs[5] & wr) begin
            $write("%c", mem_wdata[7:0]);
            $fflush(32'h8000_0001);
        end
    end
`endif

endmodule



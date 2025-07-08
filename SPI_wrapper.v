module SPI_wrapper(
    input clk,rst_n,
    input SS_n , MOSI,
    output MISO
);
    localparam MEM_DEPTH = 256;
    localparam ADDR_SIZE = 8;
    wire tx_valid;
    wire [7:0] dout;
    wire rx_valid;
    wire [9:0] rx_data;

    SPI_interface slave(
        .clk(clk) ,
        .MOSI(MOSI) ,
        .SS_n(SS_n),
        .rst_n(rst_n),
        .MISO(MISO),
        .tx_valid(tx_valid),
        .tx_data(dout),
        .rx_valid(rx_valid),
        .rx_data(rx_data)
    );
    memory_access #(
        .ADDR_SIZE(ADDR_SIZE),
        .MEM_DEPTH(MEM_DEPTH)
    ) memo (
        .clk(clk) ,
        .rst_n(rst_n),
        .din(rx_data),
        .rx_valid(rx_valid),
        .tx_valid(tx_valid),
        .dout(dout)
    );
endmodule
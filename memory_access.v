module memory_access #(
    parameter MEM_DEPTH = 8,
    parameter ADDR_SIZE = 8
)(
    input [9:0] din,
    input clk, rst_n,
    input rx_valid,
    output reg [7:0] dout,
    output reg tx_valid
);

    reg [ADDR_SIZE-1 : 0] memory [MEM_DEPTH - 1 : 0];
    reg [ADDR_SIZE-1 : 0] write_addr , read_addr ;

    always @(posedge clk) begin
        if (!rst_n) begin
            dout <= 8'd0;
            tx_valid <= 1'b0;
        end
        else begin
            if(rx_valid) begin
                if(~din[8]) begin
                    if(~din[9])
                        write_addr = din[7:0] ;   // write address
                    else
                        read_addr = din[7:0];  // read address
                end
                else begin
                    if(~din[9]) 
                        memory[write_addr] = din[7:0];     // write data
                    else begin
                        tx_valid = 1;
                        dout = memory[read_addr];  // read data
                    end
                end 
            end
        end

    end

endmodule
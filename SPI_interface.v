module SPI_interface(
    input clk,rst_n,
    input MOSI, SS_n,
    input tx_valid,
    input [7:0] tx_data,
    output MISO,
    output rx_valid,
    output reg [9:0] rx_data
);
    localparam  idle = 0,
                CHK = 1,
                write = 2,
                read_data = 3,
                read_addr = 4;

    wire started_receiving;
    reg [2:0] state,next;
    reg [3:0] nbit;
    reg copied;
    reg [7:0] tx_data_shifted;

    always@(posedge clk) begin
        if(started_receiving) begin
            if( ~rst_n || (nbit == 4'd10) ) begin
                nbit <= 1 ;
                rx_data <= {9'd0,MOSI} ;
            end
            else if((~SS_n) && (nbit < 4'd10)) begin
                rx_data <= { rx_data[8:0] , MOSI };
                nbit <= nbit + 1;
            end
        end
        else
            nbit = 4'd0;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_data_shifted <= 8'd0;
            copied <= 0;
        end 
        else begin
            if(tx_valid && ~copied) begin
                tx_data_shifted <= tx_data;
                copied = 1;    
            end
            else if (~SS_n) begin
                if(copied)
                tx_data_shifted <= {tx_data_shifted[6:0], 1'b0};
            end 
        end
    end

    always@(posedge clk or negedge rst_n) begin
        if(SS_n || ~rst_n)
            state <= idle;
        else
            state <= next;
    end

    always@(*) begin
        case(state)
            idle : next = SS_n ? idle : CHK ;
            CHK  : begin
                if(SS_n) next = idle;
                else begin
                    if(~rx_data[0])
                        next = write;
                    else
                        next = read_addr;
                end
            end
            write : begin
                if(SS_n) next = idle;
            end
            read_data : begin
                if(SS_n) next = idle;
            end            
            read_addr : begin
                if(SS_n) next = idle;
                else if(nbit == 4'd10) next = read_data;
            end
        default : next = idle;
        endcase

    end

    assign MISO = (~SS_n) ? tx_data_shifted[7] : 1'bz;
    assign rx_valid = (nbit == 4'd10);
    assign started_receiving = (state != idle) ;

endmodule
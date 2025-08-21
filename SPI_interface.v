module SPI_interface(
    input clk,rst_n,
    input MOSI, SS_n,
    input tx_valid,
    input [7:0] tx_data,
    output reg MISO,
    output rx_valid,
    output reg [9:0] rx_data
);
    localparam  idle = 0,
                CHK = 1,
                write = 2,
                read_data = 3,
                read_addr = 4;

    reg [2:0] state,next;
    reg [3:0] nbit;

    assign rx_valid = (nbit == 4'd10);

    always@(posedge clk or negedge rst_n) begin
        if(~rst_n)
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
                    if(~MOSI)
                        next = write;
                    else
                        next = read_addr;
                end
            end
            write : begin
                next = (SS_n) ? idle : state;
            end
            read_data : begin
                next = (SS_n) ? idle : state;
            end            
            read_addr : begin
                if(SS_n) next = idle;
                else if(nbit == 4'd10) next = read_data;
                else next = state;
            end
        default : next = idle;
        endcase
    end

        
    always@(posedge clk) begin
        case(state)
            idle : begin
                nbit <= 4'd0;
                MISO <= 0;
            end
            CHK  : begin
                MISO <= 0;
                rx_data <= {rx_data,MOSI};
                nbit <= nbit + 1;
            end
            write : begin
                rx_data <= {rx_data,MOSI};
                nbit <= nbit + 1;
                if(nbit==10) begin
                    nbit <= 0;  
                end 
            end
            read_data : begin
                MISO <= tx_data [7 - nbit] ;
                nbit <= nbit + 1 ;
                if (nbit == 4'h7) begin
                    nbit <= 0 ;
                end
            end            
            read_addr : begin
                rx_data <= {rx_data,MOSI};
                nbit <= nbit + 1;
                if(nbit==10) begin
                    nbit <= 0;  
                end 
            end
        default : begin
            nbit <= 0;
            rx_data <= 0;
            MISO <= 0;
        end
        endcase

    end
endmodule

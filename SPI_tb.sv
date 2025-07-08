module SPI_tb();

    logic SS_n;
    logic clk;
    logic rst_n;
    logic MISO;
    logic MOSI;

    SPI_wrapper DUT(
        .SS_n(SS_n),
        .clk(clk),
        .rst_n(rst_n),
        .MISO(MISO),
        .MOSI(MOSI)
    );
    initial begin
        clk = 0;
        forever begin 
        #20 clk = ~clk ;
        end
    end

    initial begin
        SS_n = 0;
        rst_n = 0;

        @(negedge clk); rst_n = 1; SS_n = 1;

        @(negedge clk); SS_n = 0;
        //start protocol
        // write address 
        @(negedge clk);  MOSI = 0;      //1
        @(negedge clk);  MOSI = 0;      //2
        @(negedge clk);  MOSI = 0;      //3
        @(negedge clk);  MOSI = 0;      //4
        @(negedge clk);  MOSI = 0;      //5
        @(negedge clk);  MOSI = 0;      //6
        @(negedge clk);  MOSI = 0;      //7
        @(negedge clk);  MOSI = 1;      //8
        @(negedge clk);  MOSI = 1;      //9
        @(negedge clk);  MOSI = 1;      //10
        @(negedge clk);
        @(negedge clk) rst_n = 0;
        @(negedge clk) rst_n = 1;

        // write data 
        @(negedge clk);  MOSI = 0;      //1
        @(negedge clk);  MOSI = 1;      //2
        @(negedge clk);  MOSI = 0;      //3
        @(negedge clk);  MOSI = 0;      //4
        @(negedge clk);  MOSI = 0;      //5
        @(negedge clk);  MOSI = 0;      //6
        @(negedge clk);  MOSI = 0;      //7
        @(negedge clk);  MOSI = 1;      //8
        @(negedge clk);  MOSI = 0;      //9
        @(negedge clk);  MOSI = 1;      //10
        @(negedge clk);
        @(negedge clk) rst_n = 0;
        @(negedge clk) rst_n = 1;

        //read address 
        @(negedge clk);  MOSI = 1;      //1
        @(negedge clk);  MOSI = 0;      //2
        @(negedge clk);  MOSI = 0;      //3
        @(negedge clk);  MOSI = 0;      //4
        @(negedge clk);  MOSI = 0;      //5
        @(negedge clk);  MOSI = 0;      //6
        @(negedge clk);  MOSI = 0;      //7
        @(negedge clk);  MOSI = 1;      //8
        @(negedge clk);  MOSI = 1;      //9
        @(negedge clk);  MOSI = 1;      //10
        @(negedge clk);
        @(negedge clk) rst_n = 0;
        @(negedge clk) rst_n = 1;

        // read data from address 0 --> 1111_0000
        @(negedge clk); MOSI = 1;
        @(negedge clk); MOSI = 1;
        repeat(25) begin
            @(negedge clk);
        end

        @(negedge clk);
        $stop;

    end
endmodule

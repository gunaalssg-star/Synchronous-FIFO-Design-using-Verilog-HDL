`timescale 1ns/1ps

module fifo_tb;

    parameter DATA_WIDTH = 8;

    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] data_in;

    wire [DATA_WIDTH-1:0] data_out;
    wire full;
    wire empty;
    wire almost_full;
    wire almost_empty;

    fifo uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty),
        .almost_full(almost_full),
        .almost_empty(almost_empty)
    );

    always #5 clk = ~clk;

    initial begin

        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        #20;
        rst = 0;

        // Write operation
        @(negedge clk);
        wr_en = 1;
        data_in = 8'h11;

        @(negedge clk);
        data_in = 8'h22;

        @(negedge clk);
        data_in = 8'h33;

        @(negedge clk);
        wr_en = 0;

        // Read operation
        @(negedge clk);
        rd_en = 1;

        @(negedge clk);
        @(negedge clk);
        @(negedge clk);

        rd_en = 0;

        #20;

        $finish;

    end

    initial begin
        $monitor("Time=%0t | Write=%b | Read=%b | Input=%h | Output=%h | Full=%b | Empty=%b",
        $time, wr_en, rd_en, data_in, data_out, full, empty);
    end

endmodule

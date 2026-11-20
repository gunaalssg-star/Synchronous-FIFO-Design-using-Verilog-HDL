module fifo #(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 4,
    parameter DEPTH = (1 << ADDR_WIDTH)
)(
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [DATA_WIDTH-1:0] data_in,

    output reg [DATA_WIDTH-1:0] data_out,
    output wire full,
    output wire empty,
    output wire almost_full,
    output wire almost_empty
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;

    reg [ADDR_WIDTH:0] count;

    wire write = wr_en && !full;
    wire read = rd_en && !empty;

    assign full = (count == DEPTH);
    assign empty = (count == 0);

    assign almost_full = (count >= DEPTH-1);
    assign almost_empty = (count <= 1);

    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            data_out <= 0;
        end
        else begin

            if (write) begin
                mem[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1'b1;
            end

            if (read) begin
                data_out <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1'b1;
            end

            case ({write, read})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                default: count <= count;
            endcase
        end
    end

endmodule


//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2026 22:04:27
// Design Name: 
// Module Name: tb_fifo_queue
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module tb_fifo_queue();

reg clk;
reg rst;

reg write_en;
reg read_en;

reg [63:0] data_in;

wire [63:0] data_out;

wire full;
wire empty;

fifo_queue uut(

    .clk(clk),
    .rst(rst),

    .write_en(write_en),
    .read_en(read_en),

    .data_in(data_in),

    .data_out(data_out),

    .full(full),
    .empty(empty)

);

always #5 clk = ~clk;

initial
begin

    clk = 0;
    rst = 1;

    write_en = 0;
    read_en  = 0;
    data_in  = 0;

    #20;
    rst = 0;

    // Write four packets
    repeat(4)
    begin
        @(posedge clk);
        write_en = 1;
        data_in = data_in + 64'd1;
    end

    @(posedge clk);
    write_en = 0;

    // Read four packets
    repeat(4)
    begin
        @(posedge clk);
        read_en = 1;
    end

    @(posedge clk);
    read_en = 0;

    #50;

    $finish;

end

endmodule



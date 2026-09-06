`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2026 21:18:29
// Design Name: 
// Module Name: tb_packet_generator
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

module tb_packet_generator;

reg clk;
reg rst;

wire [63:0] packet;
wire valid;

packet_generator uut(

    .clk(clk),
    .rst(rst),
    .packet(packet),
    .valid(valid)

);

always

#5 clk = ~clk;

initial

begin

clk = 0;

rst = 1;

#20;

rst = 0;

#200;

$finish;

end

endmodule

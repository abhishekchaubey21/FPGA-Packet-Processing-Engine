`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 06.08.2026
// Design Name: Packet Processing Engine
// Module Name: packet_parser
// Description:
// Extracts packet fields from a 64-bit packet.
//
// Packet Format:
// ------------------------------------------------------------
// |63:48|47:45|44:43|42:35|34:19|18:0|
// | ID  | Prio | Prot | Dest | Len | Reserved |
// ------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////

module packet_parser #

(

    parameter DATA_WIDTH = 64

)

(

    input clk,
    input rst,

    input [DATA_WIDTH-1:0] packet,
    input valid,

    output reg [15:0]  packet_id,
    output reg [2:0]   priority,
    output reg [1:0]   protocol,
    output reg [7:0]   destination,
    output reg [15:0]  length

);

always @(posedge clk)
begin

    if (rst)
    begin
        packet_id   <= 16'd0;
        priority    <= 3'd0;
        protocol    <= 2'd0;
        destination <= 8'd0;
        length      <= 16'd0;
    end

    else if (valid)
    begin
        // Decode packet fields
        packet_id   <= packet[63:48];
        priority    <= packet[47:45];
        protocol    <= packet[44:43];
        destination <= packet[42:35];
        length      <= packet[34:19];
    end

    else
    begin
        // Hold previous values
        packet_id   <= packet_id;
        priority    <= priority;
        protocol    <= protocol;
        destination <= destination;
        length      <= length;
    end

end

endmodule
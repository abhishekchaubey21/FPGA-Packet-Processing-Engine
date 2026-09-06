`timescale 1ns / 1ps

module fairness_index_calculator(

    input clk,
    input rst,

    input [31:0] high_packets,
    input [31:0] medium_packets,
    input [31:0] low_packets,

    output reg [6:0] fairness_index

);

//=======================================================
// Internal Registers
//=======================================================

reg [31:0] total_packets;
reg [63:0] numerator;
reg [63:0] denominator;

always @(posedge clk)
begin

    if(rst)
    begin

        fairness_index <= 0;

        total_packets <= 0;
        numerator <= 0;
        denominator <= 0;

    end

    else
    begin

        total_packets <= high_packets +
                         medium_packets +
                         low_packets;

        numerator <= (high_packets +
                      medium_packets +
                      low_packets) *
                     (high_packets +
                      medium_packets +
                      low_packets);

        denominator <= 3 *
                      ((high_packets * high_packets) +
                       (medium_packets * medium_packets) +
                       (low_packets * low_packets));

        if(denominator != 0)
            fairness_index <= (numerator * 100) / denominator;
        else
            fairness_index <= 0;

    end

end

endmodule
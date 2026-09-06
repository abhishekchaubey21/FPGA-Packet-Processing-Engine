`timescale 1ns/1ps

module packet_statistics(

    input clk,
    input rst,

    input valid,
    input [2:0] priority,

    input output_valid,

    output reg [31:0] total_packets,
    output reg [31:0] high_packets,
    output reg [31:0] medium_packets,
    output reg [31:0] low_packets,
    output reg [31:0] transmitted_packets

);

always @(posedge clk)
begin

    if(rst)
    begin
        total_packets       <= 0;
        high_packets        <= 0;
        medium_packets      <= 0;
        low_packets         <= 0;
        transmitted_packets <= 0;
    end

    else
    begin

        // Count incoming packets
        if(valid)
        begin

            total_packets <= total_packets + 1;

            if(priority >= 6)
                high_packets <= high_packets + 1;

            else if(priority >= 3)
                medium_packets <= medium_packets + 1;

            else
                low_packets <= low_packets + 1;

        end

        // Count transmitted packets
        if(output_valid)
            transmitted_packets <= transmitted_packets + 1;

    end

end

endmodule
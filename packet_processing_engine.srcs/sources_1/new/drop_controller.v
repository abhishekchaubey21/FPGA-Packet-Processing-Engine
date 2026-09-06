`timescale 1ns/1ps

module drop_controller(

    input clk,
    input rst,

    input valid,

    input high_write,
    input medium_write,
    input low_write,

    input high_full,
    input medium_full,
    input low_full,

    output reg drop_packet,
    output reg [31:0] dropped_packets

);

always @(posedge clk)
begin

    if(rst)
    begin
        drop_packet <= 0;
        dropped_packets <= 0;
    end

    else
    begin

        drop_packet <= 0;

        if(valid)
        begin

            if(high_write && high_full)
            begin
                drop_packet <= 1;
                dropped_packets <= dropped_packets + 1;
            end

            else if(medium_write && medium_full)
            begin
                drop_packet <= 1;
                dropped_packets <= dropped_packets + 1;
            end

            else if(low_write && low_full)
            begin
                drop_packet <= 1;
                dropped_packets <= dropped_packets + 1;
            end

        end

    end

end

endmodule

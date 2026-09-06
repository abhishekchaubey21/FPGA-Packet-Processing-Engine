`timescale 1ns / 1ps

module red_controller(

    input clk,
    input rst,

    input [4:0] high_level,
    input [4:0] medium_level,
    input [4:0] low_level,

    output reg drop_high,
    output reg drop_medium,
    output reg drop_low

);

// RED Thresholds
parameter HIGH_THRESHOLD   = 12;
parameter MEDIUM_THRESHOLD = 10;
parameter LOW_THRESHOLD    = 8;

always @(posedge clk)
begin

    if(rst)
    begin

        drop_high   <= 0;
        drop_medium <= 0;
        drop_low    <= 0;

    end

    else
    begin

        drop_high   <= (high_level   >= HIGH_THRESHOLD);
        drop_medium <= (medium_level >= MEDIUM_THRESHOLD);
        drop_low    <= (low_level    >= LOW_THRESHOLD);

    end

end

endmodule

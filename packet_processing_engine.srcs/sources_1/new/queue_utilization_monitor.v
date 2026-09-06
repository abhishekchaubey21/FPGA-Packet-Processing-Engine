`timescale 1ns / 1ps

module queue_utilization_monitor(

    input clk,
    input rst,

    input [4:0] high_level,
    input [4:0] medium_level,
    input [4:0] low_level,

    output reg [6:0] high_utilization,
    output reg [6:0] medium_utilization,
    output reg [6:0] low_utilization

);

// FIFO Depth
parameter FIFO_DEPTH = 16;

always @(posedge clk)
begin

    if(rst)
    begin

        high_utilization   <= 0;
        medium_utilization <= 0;
        low_utilization    <= 0;

    end

    else
    begin

        // Utilization = (Queue Level × 100) / FIFO Depth

        high_utilization   <= (high_level   * 100) / FIFO_DEPTH;
        medium_utilization <= (medium_level * 100) / FIFO_DEPTH;
        low_utilization    <= (low_level    * 100) / FIFO_DEPTH;

    end

end

endmodule
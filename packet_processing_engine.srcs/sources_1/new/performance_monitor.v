`timescale 1ns/1ps

module performance_monitor(

    input clk,
    input rst,

    input valid,
    input output_valid,

    output reg [31:0] clock_cycles,
    output reg [31:0] throughput

);

always @(posedge clk)
begin

    if(rst)
    begin
        clock_cycles <= 0;
        throughput   <= 0;
    end

    else
    begin

        // Count total clock cycles
        clock_cycles <= clock_cycles + 1;

        // Count transmitted packets
        if(output_valid)
            throughput <= throughput + 1;

    end

end

endmodule
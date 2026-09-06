`timescale 1ns / 1ps

module lfsr_random(

    input clk,
    input rst,

    output [3:0] random_value

);

reg [3:0] lfsr;

always @(posedge clk)
begin

    if(rst)
        lfsr <= 4'b1011;

    else
        lfsr <= {lfsr[2:0], lfsr[3]^lfsr[2]};

end

assign random_value = lfsr;

endmodule
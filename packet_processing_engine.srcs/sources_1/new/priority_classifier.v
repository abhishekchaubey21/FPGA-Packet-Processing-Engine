`timescale 1ns / 1ps

module priority_classifier(

    input clk,
    input rst,

    input [2:0] priority,

    output reg [1:0] queue_select

);

always @(posedge clk)
begin

    if(rst)

        queue_select <= 2'b00;

    else

    begin

        if(priority <= 2)

            queue_select <= 2'b00;      // LOW Queue

        else if(priority <= 5)

            queue_select <= 2'b01;      // MEDIUM Queue

        else

            queue_select <= 2'b10;      // HIGH Queue

    end

end

endmodule

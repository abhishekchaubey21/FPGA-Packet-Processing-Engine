`timescale 1ns / 1ps

module qos_controller(

    input clk,
    input rst,

    input high_empty,
    input medium_empty,
    input low_empty,

    input high_full,
    input medium_full,
    input low_full,

    output reg [3:0] high_weight,
    output reg [3:0] medium_weight,
    output reg [3:0] low_weight

);

always @(posedge clk)
begin

    if(rst)
    begin

        high_weight   <= 4'd4;
        medium_weight <= 4'd2;
        low_weight    <= 4'd1;

    end

    else
    begin

        //=============================
        // HIGH Queue
        //=============================

        if(high_full)
            high_weight <= 4'd6;

        else if(high_empty)
            high_weight <= 4'd2;

        else
            high_weight <= 4'd4;

        //=============================
        // MEDIUM Queue
        //=============================

        if(medium_full)
            medium_weight <= 4'd4;

        else if(medium_empty)
            medium_weight <= 4'd1;

        else
            medium_weight <= 4'd2;

        //=============================
        // LOW Queue
        //=============================

        if(low_full)
            low_weight <= 4'd2;

        else if(low_empty)
            low_weight <= 4'd0;

        else
            low_weight <= 4'd1;

    end

end

endmodule

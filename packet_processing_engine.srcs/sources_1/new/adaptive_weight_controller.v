`timescale 1ns / 1ps

module adaptive_weight_controller(

    input clk,
    input rst,

    input [4:0] high_level,
    input [4:0] medium_level,
    input [4:0] low_level,

    output reg [3:0] high_weight,
    output reg [3:0] medium_weight,
    output reg [3:0] low_weight

);

always @(posedge clk)
begin

    if(rst)
    begin

        // Default WRR Weights
        high_weight   <= 4;
        medium_weight <= 2;
        low_weight    <= 1;

    end

    else
    begin

        //--------------------------------------------------
        // High Queue Adaptive Weight
        //--------------------------------------------------

        if(high_level >= 12)
            high_weight <= 8;

        else if(high_level >= 8)
            high_weight <= 6;

        else if(high_level >= 4)
            high_weight <= 4;

        else
            high_weight <= 2;

        //--------------------------------------------------
        // Medium Queue Adaptive Weight
        //--------------------------------------------------

        if(medium_level >= 12)
            medium_weight <= 8;

        else if(medium_level >= 8)
            medium_weight <= 6;

        else if(medium_level >= 4)
            medium_weight <= 4;

        else
            medium_weight <= 2;

        //--------------------------------------------------
        // Low Queue Adaptive Weight
        //--------------------------------------------------

        if(low_level >= 12)
            low_weight <= 8;

        else if(low_level >= 8)
            low_weight <= 6;

        else if(low_level >= 4)
            low_weight <= 4;

        else
            low_weight <= 2;

    end

end

endmodule
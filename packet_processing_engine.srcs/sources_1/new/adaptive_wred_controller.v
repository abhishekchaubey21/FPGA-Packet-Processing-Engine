`timescale 1ns / 1ps

module adaptive_wred_controller(

    input clk,
    input rst,

    input [4:0] high_level,
    input [4:0] medium_level,
    input [4:0] low_level,

    input [3:0] high_weight,
    input [3:0] medium_weight,
    input [3:0] low_weight,

    input [3:0] random_value,
    input [1:0] drop_level,

    output reg drop_high,
    output reg drop_medium,
    output reg drop_low

);

//=======================================================
// HIGH PRIORITY
//=======================================================

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

        //---------------- HIGH QUEUE ----------------

        if(high_level >= 12)
            drop_high <= 1'b1;

        else if(high_level >= 8)
        begin

            if(high_weight >= 6)
                drop_high <= (random_value < 2);     // 12.5%

            else if(high_weight >= 4)
                drop_high <= (random_value < 4);     // 25%

            else
                drop_high <= (random_value < 8);     // 50%

        end

        else if(high_level >= 4)
        begin

            if(high_weight >= 6)
                drop_high <= 1'b0;

            else if(high_weight >= 4)
                drop_high <= (random_value < 2);

            else
                drop_high <= (random_value < 4);

        end

        else
            drop_high <= 1'b0;

        //---------------- MEDIUM QUEUE ----------------

        if(medium_level >= 12)
            drop_medium <= 1'b1;

        else if(medium_level >= 8)
        begin

            if(medium_weight >= 6)
                drop_medium <= (random_value < 4);

            else if(medium_weight >= 4)
                drop_medium <= (random_value < 6);

            else
                drop_medium <= (random_value < 8);

        end

        else if(medium_level >= 4)
        begin

            if(medium_weight >= 6)
                drop_medium <= (random_value < 2);

            else if(medium_weight >= 4)
                drop_medium <= (random_value < 3);

            else
                drop_medium <= (random_value < 4);

        end

        else
            drop_medium <= 1'b0;

        //---------------- LOW QUEUE ----------------

        if(low_level >= 12)
            drop_low <= 1'b1;

        else if(low_level >= 8)
        begin

            if(low_weight >= 6)
                drop_low <= (random_value < 6);

            else if(low_weight >= 4)
                drop_low <= (random_value < 8);

            else
                drop_low <= (random_value < 12);

        end

        else if(low_level >= 4)
        begin

            if(low_weight >= 6)
                drop_low <= (random_value < 3);

            else if(low_weight >= 4)
                drop_low <= (random_value < 4);

            else
                drop_low <= (random_value < 6);

        end

        else
            drop_low <= 1'b0;

    end

end

endmodule
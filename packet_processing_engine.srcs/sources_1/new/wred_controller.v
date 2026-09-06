`timescale 1ns / 1ps

module wred_controller(

    input clk,
    input rst,

    input [4:0] high_level,
    input [4:0] medium_level,
    input [4:0] low_level,

    input [3:0] random_value,
    input [1:0] drop_level,

    output reg drop_high,
    output reg drop_medium,
    output reg drop_low

);

//----------------------------------------------------
// High Queue
//----------------------------------------------------

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

    //---------------- HIGH ----------------

    if(drop_level == 2'd0)
    begin
        if(high_level >= 12)
            drop_high <= 1;
        else if(high_level >= 8)
            drop_high <= (random_value < 8);
        else if(high_level >= 4)
            drop_high <= (random_value < 4);
        else
            drop_high <= 0;
    end

    else if(drop_level == 2'd1)
    begin
        if(high_level >= 10)
            drop_high <= 1;
        else if(high_level >= 6)
            drop_high <= (random_value < 8);
        else if(high_level >= 3)
            drop_high <= (random_value < 4);
        else
            drop_high <= 0;
    end

    else if(drop_level == 2'd2)
    begin
        if(high_level >= 8)
            drop_high <= 1;
        else if(high_level >= 5)
            drop_high <= (random_value < 10);
        else if(high_level >= 2)
            drop_high <= (random_value < 6);
        else
            drop_high <= 0;
    end

    else
    begin
        if(high_level >= 6)
            drop_high <= 1;
        else if(high_level >= 3)
            drop_high <= (random_value < 12);
        else
            drop_high <= 0;
    end


    //---------------- MEDIUM ----------------

    if(drop_level == 2'd0)
    begin
        if(medium_level >= 12)
            drop_medium <= 1;
        else if(medium_level >= 8)
            drop_medium <= (random_value < 8);
        else if(medium_level >= 4)
            drop_medium <= (random_value < 4);
        else
            drop_medium <= 0;
    end

    else if(drop_level == 2'd1)
    begin
        if(medium_level >= 10)
            drop_medium <= 1;
        else if(medium_level >= 6)
            drop_medium <= (random_value < 8);
        else if(medium_level >= 3)
            drop_medium <= (random_value < 4);
        else
            drop_medium <= 0;
    end

    else if(drop_level == 2'd2)
    begin
        if(medium_level >= 8)
            drop_medium <= 1;
        else if(medium_level >= 5)
            drop_medium <= (random_value < 10);
        else if(medium_level >= 2)
            drop_medium <= (random_value < 6);
        else
            drop_medium <= 0;
    end

    else
    begin
        if(medium_level >= 6)
            drop_medium <= 1;
        else if(medium_level >= 3)
            drop_medium <= (random_value < 12);
        else
            drop_medium <= 0;
    end


    //---------------- LOW ----------------

    if(drop_level == 2'd0)
    begin
        if(low_level >= 12)
            drop_low <= 1;
        else if(low_level >= 8)
            drop_low <= (random_value < 8);
        else if(low_level >= 4)
            drop_low <= (random_value < 4);
        else
            drop_low <= 0;
    end

    else if(drop_level == 2'd1)
    begin
        if(low_level >= 10)
            drop_low <= 1;
        else if(low_level >= 6)
            drop_low <= (random_value < 8);
        else if(low_level >= 3)
            drop_low <= (random_value < 4);
        else
            drop_low <= 0;
    end

    else if(drop_level == 2'd2)
    begin
        if(low_level >= 8)
            drop_low <= 1;
        else if(low_level >= 5)
            drop_low <= (random_value < 10);
        else if(low_level >= 2)
            drop_low <= (random_value < 6);
        else
            drop_low <= 0;
    end

    else
    begin
        if(low_level >= 6)
            drop_low <= 1;
        else if(low_level >= 3)
            drop_low <= (random_value < 12);
        else
            drop_low <= 0;
    end

end
end
endmodule
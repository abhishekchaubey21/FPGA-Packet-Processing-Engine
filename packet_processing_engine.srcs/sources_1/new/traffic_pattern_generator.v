`timescale 1ns / 1ps

module traffic_pattern_generator(

    input clk,
    input rst,

    input [2:0] traffic_mode,

    output reg [2:0] priority

);

// Counter for traffic generation
reg [7:0] counter;

always @(posedge clk)
begin

    if(rst)
    begin
        counter <= 0;
        priority <= 0;
    end

    else
    begin

        counter <= counter + 1;

        case(traffic_mode)

        //=========================================
        // Uniform
        //=========================================
        3'd0:
            priority <= counter % 3;

        //=========================================
        // Burst High Priority
        //=========================================
        3'd1:
        begin
            if(counter[4])
                priority <= 3'd2;
            else
                priority <= 3'd0;
        end

        //=========================================
        // High Priority Dominated
        //=========================================
        3'd2:
        begin
            if(counter[2:0] < 6)
                priority <= 3'd2;
            else
                priority <= counter % 3;
        end

        //=========================================
        // Low Priority Dominated
        //=========================================
        3'd3:
        begin
            if(counter[2:0] < 6)
                priority <= 3'd0;
            else
                priority <= counter % 3;
        end

        //=========================================
        // Random
        //=========================================
        default:
            priority <= counter[2:0];

        endcase

    end

end

endmodule
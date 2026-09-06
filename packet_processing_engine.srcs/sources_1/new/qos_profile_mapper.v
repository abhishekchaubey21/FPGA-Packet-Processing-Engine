`timescale 1ns / 1ps

module qos_profile_mapper(

    input clk,
    input rst,

    input [1:0] qos_profile,

    // Scheduler Weights
    output reg [3:0] high_weight,
    output reg [3:0] medium_weight,
    output reg [3:0] low_weight,

    // Drop Aggressiveness
    output reg [1:0] drop_level

);

// QoS Profiles
localparam PROFILE_P0 = 2'd0;
localparam PROFILE_P1 = 2'd1;
localparam PROFILE_P2 = 2'd2;
localparam PROFILE_P3 = 2'd3;

always @(posedge clk)
begin

    if(rst)
    begin
        high_weight   <= 4'd4;
        medium_weight <= 4'd2;
        low_weight    <= 4'd1;

        drop_level    <= 2'd0;
    end

    else
    begin

        case(qos_profile)

        //=========================================
        // Profile P0 : Normal
        //=========================================

        PROFILE_P0:
        begin
            high_weight   <= 4'd4;
            medium_weight <= 4'd2;
            low_weight    <= 4'd1;

            drop_level    <= 2'd0;
        end

        //=========================================
        // Profile P1 : Busy
        //=========================================

        PROFILE_P1:
        begin
            high_weight   <= 4'd5;
            medium_weight <= 4'd3;
            low_weight    <= 4'd1;

            drop_level    <= 2'd1;
        end

        //=========================================
        // Profile P2 : Congested
        //=========================================

        PROFILE_P2:
        begin
            high_weight   <= 4'd6;
            medium_weight <= 4'd2;
            low_weight    <= 4'd1;

            drop_level    <= 2'd2;
        end

        //=========================================
        // Profile P3 : Emergency
        //=========================================

        default:
        begin
            high_weight   <= 4'd7;
            medium_weight <= 4'd2;
            low_weight    <= 4'd0;

            drop_level    <= 2'd3;
        end

        endcase

    end

end

endmodule

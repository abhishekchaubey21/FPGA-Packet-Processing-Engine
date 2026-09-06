`timescale 1ns / 1ps

module adaptive_decision_unit(

    input clk,
    input rst,

    input [7:0] qos_score,

    output reg [1:0] qos_profile,
    output reg [1:0] congestion_mode

);

// QoS Profiles
localparam PROFILE_P0 = 2'd0;
localparam PROFILE_P1 = 2'd1;
localparam PROFILE_P2 = 2'd2;
localparam PROFILE_P3 = 2'd3;

// Congestion Modes
localparam NORMAL      = 2'd0;
localparam BUSY        = 2'd1;
localparam CONGESTED   = 2'd2;
localparam EMERGENCY   = 2'd3;

always @(posedge clk)
begin

    if(rst)
    begin
        qos_profile     <= PROFILE_P0;
        congestion_mode <= NORMAL;
    end

    else
    begin

        if(qos_score <= 8'd30)
        begin
            qos_profile     <= PROFILE_P0;
            congestion_mode <= NORMAL;
        end

        else if(qos_score <= 8'd60)
        begin
            qos_profile     <= PROFILE_P1;
            congestion_mode <= BUSY;
        end

        else if(qos_score <= 8'd90)
        begin
            qos_profile     <= PROFILE_P2;
            congestion_mode <= CONGESTED;
        end

        else
        begin
            qos_profile     <= PROFILE_P3;
            congestion_mode <= EMERGENCY;
        end

    end

end

endmodule

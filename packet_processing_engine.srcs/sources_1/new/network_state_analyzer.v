`timescale 1ns / 1ps

module network_state_analyzer(

    input clk,
    input rst,

    // Queue Occupancy
    input [4:0] high_level,
    input [4:0] medium_level,
    input [4:0] low_level,

    // Performance Metrics
    input [31:0] avg_latency,
    input [31:0] throughput,
    input [6:0] fairness_index,

    // Network State Outputs
    output reg [1:0] load_state,
    output reg [1:0] latency_state,
    output reg [1:0] fairness_state,
    output reg [1:0] congestion_state

);

//--------------------------------------------
// State Encoding
//--------------------------------------------

// Load State
localparam LOAD_LOW    = 2'd0;
localparam LOAD_MEDIUM = 2'd1;
localparam LOAD_HIGH   = 2'd2;

// Latency State
localparam LAT_LOW     = 2'd0;
localparam LAT_MEDIUM  = 2'd1;
localparam LAT_HIGH    = 2'd2;

// Fairness State
localparam FAIR_GOOD   = 2'd0;
localparam FAIR_AVG    = 2'd1;
localparam FAIR_POOR   = 2'd2;

// Congestion State
localparam NORMAL      = 2'd0;
localparam BUSY        = 2'd1;
localparam CONGESTED   = 2'd2;

always @(posedge clk)
begin

    if(rst)
    begin
        load_state        <= LOAD_LOW;
        latency_state     <= LAT_LOW;
        fairness_state    <= FAIR_GOOD;
        congestion_state  <= NORMAL;
    end

    else
    begin

        //----------------------------------------
        // Load Analysis
        //----------------------------------------

        if((high_level + medium_level + low_level) < 12)
            load_state <= LOAD_LOW;

        else if((high_level + medium_level + low_level) < 24)
            load_state <= LOAD_MEDIUM;

        else
            load_state <= LOAD_HIGH;

        //----------------------------------------
        // Latency Analysis
        //----------------------------------------

        if(avg_latency < 5)
            latency_state <= LAT_LOW;

        else if(avg_latency < 10)
            latency_state <= LAT_MEDIUM;

        else
            latency_state <= LAT_HIGH;

        //----------------------------------------
        // Fairness Analysis
        //----------------------------------------

        if(fairness_index >= 90)
            fairness_state <= FAIR_GOOD;

        else if(fairness_index >= 70)
            fairness_state <= FAIR_AVG;

        else
            fairness_state <= FAIR_POOR;

        //----------------------------------------
        // Overall Congestion
        //----------------------------------------

        if(load_state == LOAD_HIGH || latency_state == LAT_HIGH)
            congestion_state <= CONGESTED;

        else if(load_state == LOAD_MEDIUM)
            congestion_state <= BUSY;

        else
            congestion_state <= NORMAL;

    end

end

endmodule
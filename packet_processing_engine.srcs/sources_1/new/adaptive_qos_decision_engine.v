`timescale 1ns / 1ps

module adaptive_qos_decision_engine(

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

    // Scheduler Outputs
    output reg [3:0] high_weight,
    output reg [3:0] medium_weight,
    output reg [3:0] low_weight,

    // Congestion Outputs
    output reg [1:0] congestion_state

);

// Congestion States
localparam NORMAL     = 2'b00;
localparam BUSY       = 2'b01;
localparam CONGESTED  = 2'b10;
localparam RECOVERY   = 2'b11;

always @(posedge clk)
begin

    if(rst)
    begin
        congestion_state <= NORMAL;

        high_weight   <= 4;
        medium_weight <= 2;
        low_weight    <= 1;
    end

    else
    begin

        // -----------------------------
        // NORMAL
        // -----------------------------
        if((high_level < 6) &&
           (medium_level < 6) &&
           (low_level < 6) &&
           (avg_latency < 5))
        begin

            congestion_state <= NORMAL;

            high_weight   <= 4;
            medium_weight <= 2;
            low_weight    <= 1;

        end

        // -----------------------------
        // BUSY
        // -----------------------------
        else if((high_level < 10) &&
                (avg_latency < 10))
        begin

            congestion_state <= BUSY;

            high_weight   <= 5;
            medium_weight <= 3;
            low_weight    <= 1;

        end

        // -----------------------------
        // CONGESTED
        // -----------------------------
        else if((high_level >= 10) ||
                (avg_latency >= 10))
        begin

            congestion_state <= CONGESTED;

            high_weight   <= 6;
            medium_weight <= 2;
            low_weight    <= 1;

        end

        // -----------------------------
        // RECOVERY
        // -----------------------------
        else
        begin

            congestion_state <= RECOVERY;

            high_weight   <= 5;
            medium_weight <= 3;
            low_weight    <= 2;

        end

    end

end

endmodule

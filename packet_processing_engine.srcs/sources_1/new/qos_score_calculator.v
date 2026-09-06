`timescale 1ns / 1ps

module qos_score_calculator(

    input clk,
    input rst,

    input [1:0] load_state,
    input [1:0] latency_state,
    input [1:0] fairness_state,

    input [31:0] throughput,

    output reg [7:0] qos_score

);

//----------------------------------------------------
// Penalty Registers
//----------------------------------------------------

reg [7:0] load_penalty;
reg [7:0] latency_penalty;
reg [7:0] fairness_penalty;
reg [7:0] throughput_penalty;

always @(posedge clk)
begin

    if(rst)
    begin

        qos_score <= 0;

    end

    else
    begin

        //------------------------------------------------
        // Load
        //------------------------------------------------

        case(load_state)

        2'd0: load_penalty <= 0;
        2'd1: load_penalty <= 20;
        default: load_penalty <= 40;

        endcase

        //------------------------------------------------
        // Latency
        //------------------------------------------------

        case(latency_state)

        2'd0: latency_penalty <= 0;
        2'd1: latency_penalty <= 20;
        default: latency_penalty <= 40;

        endcase

        //------------------------------------------------
        // Fairness
        //------------------------------------------------

        case(fairness_state)

        2'd0: fairness_penalty <= 0;
        2'd1: fairness_penalty <= 10;
        default: fairness_penalty <= 20;

        endcase

        //------------------------------------------------
        // Throughput
        //------------------------------------------------

        if(throughput > 80)
            throughput_penalty <= 0;
        else if(throughput > 50)
            throughput_penalty <= 10;
        else
            throughput_penalty <= 20;

        //------------------------------------------------
        // Final Score
        //------------------------------------------------

        qos_score <= load_penalty +
                     latency_penalty +
                     fairness_penalty +
                     throughput_penalty;

    end

end

endmodule
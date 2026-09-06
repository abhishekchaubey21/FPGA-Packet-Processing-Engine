`timescale 1ns / 1ps

module experiment_controller(

    input clk,
    input rst,

    input [2:0] experiment_mode,

    output reg [1:0] scheduler_mode,
    output reg [2:0] traffic_mode

);

always @(posedge clk)
begin

    if(rst)
    begin
        scheduler_mode <= 2'd0;
        traffic_mode   <= 3'd0;
    end

    else
    begin

        case(experiment_mode)

        //=========================================
        // Static WRR + Uniform
        //=========================================
        3'd0:
        begin
            scheduler_mode <= 2'd0;
            traffic_mode   <= 3'd0;
        end

        //=========================================
        // Adaptive WRR + Uniform
        //=========================================
        3'd1:
        begin
            scheduler_mode <= 2'd1;
            traffic_mode   <= 3'd0;
        end

        //=========================================
        // Adaptive WRR + Adaptive WRED
        //=========================================
        3'd2:
        begin
            scheduler_mode <= 2'd2;
            traffic_mode   <= 3'd0;
        end

        //=========================================
        // Static WRR + Burst
        //=========================================
        3'd3:
        begin
            scheduler_mode <= 2'd0;
            traffic_mode   <= 3'd1;
        end

        //=========================================
        // Adaptive WRR + Burst
        //=========================================
        3'd4:
        begin
            scheduler_mode <= 2'd1;
            traffic_mode   <= 3'd1;
        end

        //=========================================
        // Adaptive WRR + Adaptive WRED + Burst
        //=========================================
        3'd5:
        begin
            scheduler_mode <= 2'd2;
            traffic_mode   <= 3'd1;
        end

        //=========================================
        // Adaptive WRR + High Priority Traffic
        //=========================================
        3'd6:
        begin
            scheduler_mode <= 2'd1;
            traffic_mode   <= 3'd2;
        end

        //=========================================
        // Adaptive WRR + Random Traffic
        //=========================================
        default:
        begin
            scheduler_mode <= 2'd2;
            traffic_mode   <= 3'd4;
        end

        endcase

    end

end

endmodule
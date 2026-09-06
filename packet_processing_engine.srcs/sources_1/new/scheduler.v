`timescale 1ns / 1ps

module scheduler(

    input clk,
    input rst,

    input high_empty,
    input medium_empty,
    input low_empty,

    // Dynamic QoS Weights
    input [3:0] high_weight,
    input [3:0] medium_weight,
    input [3:0] low_weight,
    input m_axis_tready,

    output reg high_read,
    output reg medium_read,
    output reg low_read

);

//======================================================
// Internal Registers
//======================================================

reg [1:0] current_queue;

reg [3:0] high_count;
reg [3:0] medium_count;
reg [3:0] low_count;

//======================================================
// Weighted Round Robin Scheduler
//======================================================

always @(posedge clk)
begin

    if(rst)
    begin

        current_queue <= 2'd0;

        high_count   <= 4'd0;
        medium_count <= 4'd0;
        low_count    <= 4'd0;

        high_read   <= 1'b0;
        medium_read <= 1'b0;
        low_read    <= 1'b0;

    end

    else
    begin

        // Default outputs
        high_read   <= 1'b0;
        medium_read <= 1'b0;
        low_read    <= 1'b0;

        case(current_queue)

        //==================================================
        // HIGH QUEUE
        //==================================================

        2'd0:
        begin

            if(!high_empty && m_axis_tready)
            begin

                high_read <= 1'b1;

                if(high_count >= (high_weight - 1))
                begin
                    high_count   <= 4'd0;
                    current_queue <= 2'd1;
                end
                else
                begin
                    high_count <= high_count + 1'b1;
                end

            end
            else
            begin
                high_count   <= 4'd0;
                current_queue <= 2'd1;
            end

        end

        //==================================================
        // MEDIUM QUEUE
        //==================================================

        2'd1:
        begin

            if(!medium_empty && m_axis_tready)
            begin

                medium_read <= 1'b1;

                if(medium_count >= (medium_weight - 1))
                begin
                    medium_count <= 4'd0;
                    current_queue <= 2'd2;
                end
                else
                begin
                    medium_count <= medium_count + 1'b1;
                end

            end
            else
            begin
                medium_count <= 4'd0;
                current_queue <= 2'd2;
            end

        end

        //==================================================
        // LOW QUEUE
        //==================================================

        2'd2:
        begin

            if(!low_empty && m_axis_tready)
            begin

                low_read <= 1'b1;

                if(low_count >= (low_weight - 1))
                begin
                    low_count <= 4'd0;
                    current_queue <= 2'd0;
                end
                else
                begin
                    low_count <= low_count + 1'b1;
                end

            end
            else
            begin
                low_count <= 4'd0;
                current_queue <= 2'd0;
            end

        end

        default:
        begin
            current_queue <= 2'd0;
        end

        endcase

    end

end

endmodule
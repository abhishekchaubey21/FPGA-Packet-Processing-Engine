`timescale 1ns / 1ps

module latency_analyzer(

    input clk,
    input rst,

    // Packet enters system
    input valid,

    // Packet leaves system
    input output_valid,

    output reg [31:0] current_latency,
    output reg [31:0] min_latency,
    output reg [31:0] max_latency,
    output reg [31:0] avg_latency,
    output reg [31:0] packets_measured

);

//======================================================
// Internal Registers
//======================================================

reg [31:0] cycle_counter;
reg [31:0] entry_time;
reg [31:0] total_latency;

//======================================================
// Latency Measurement
//======================================================

always @(posedge clk)
begin

    if(rst)
    begin
        cycle_counter     <= 32'd0;
        entry_time        <= 32'd0;

        current_latency   <= 32'd0;
        min_latency       <= 32'hFFFFFFFF;
        max_latency       <= 32'd0;
        avg_latency       <= 32'd0;

        total_latency     <= 32'd0;
        packets_measured  <= 32'd0;
    end

    else
    begin

        // Global clock counter
        cycle_counter <= cycle_counter + 1'b1;

        // Packet entered system
        if(valid)
        begin
            entry_time <= cycle_counter;
        end

        // Packet transmitted
        if(output_valid)
        begin

            current_latency <= cycle_counter - entry_time;

            if((cycle_counter - entry_time) < min_latency)
                min_latency <= cycle_counter - entry_time;

            if((cycle_counter - entry_time) > max_latency)
                max_latency <= cycle_counter - entry_time;

            total_latency <= total_latency + (cycle_counter - entry_time);

            packets_measured <= packets_measured + 1'b1;

            if(packets_measured != 0)
                avg_latency <= (total_latency + (cycle_counter - entry_time))
                               / (packets_measured + 1'b1);

        end

    end

end

endmodule
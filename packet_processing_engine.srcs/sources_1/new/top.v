`timescale 1ns / 1ps

module top #

(

parameter DATA_WIDTH = 64

)

(

input clk,
input rst,

//=============================
// Experiment Control
//=============================

input [1:0] scheduler_mode,
input [2:0] traffic_mode,

output [63:0] m_axis_tdata,
output        m_axis_tvalid,
input         m_axis_tready,
output        m_axis_tlast

);

//=========================================================
// Packet Generator Signals
//=========================================================

wire [DATA_WIDTH-1:0] packet;
wire valid;

//=========================================================
// Parser Outputs
//=========================================================

wire [2:0] priority;
wire [1:0] protocol;
wire [15:0] length;
wire [7:0] destination;
wire [15:0] packet_id;

//=========================================================
// Generator
//=========================================================

packet_generator #(

    .DATA_WIDTH(DATA_WIDTH)

) gen(

    .clk(clk),
    .rst(rst),

    .packet(packet),
    .valid(valid)

);

//=========================================================
// Parser
//=========================================================

packet_parser #(

    .DATA_WIDTH(DATA_WIDTH)

) parser(

    .clk(clk),
    .rst(rst),

    .packet(packet),
    .valid(valid),

    .packet_id(packet_id),
    .priority(priority),
    .protocol(protocol),
    .destination(destination),
    .length(length)

);

//=========================================================
// Priority Classifier
//=========================================================

wire [1:0] queue_select;

priority_classifier classifier(

    .clk(clk),
    .rst(rst),

    .priority(priority),

    .queue_select(queue_select)

);

//=========================================================
// Queue Dispatcher
//=========================================================

wire high_write;
wire medium_write;
wire low_write;

wire [DATA_WIDTH-1:0] high_packet;
wire [DATA_WIDTH-1:0] medium_packet;
wire [DATA_WIDTH-1:0] low_packet;

queue_dispatcher #(

    .DATA_WIDTH(DATA_WIDTH)

) dispatcher(

    .clk(clk),
    .rst(rst),

    .packet(packet),
    .valid(valid),

    .queue_select(queue_select),

    .high_write(high_write),
    .medium_write(medium_write),
    .low_write(low_write),

    .high_packet(high_packet),
    .medium_packet(medium_packet),
    .low_packet(low_packet)

);

//=========================================================
// Scheduler Read Signals
//=========================================================

wire high_read;
wire medium_read;
wire low_read;

//=========================================================
// HIGH FIFO
//=========================================================

wire [DATA_WIDTH-1:0] high_data_out;
wire high_empty;
wire high_full;
wire [4:0] high_level;

fifo_queue #(

    .DATA_WIDTH(DATA_WIDTH)

) high_fifo(

    .clk(clk),
    .rst(rst),

    .write_en(high_write && !drop_high),
    .read_en(high_read),

    .data_in(high_packet),
    .data_out(high_data_out),

    .full(high_full),
    .empty(high_empty),
    .fifo_level(high_level)

);

//=========================================================
// MEDIUM FIFO
//=========================================================

wire [DATA_WIDTH-1:0] medium_data_out;
wire medium_empty;
wire medium_full;
wire [4:0] medium_level;

fifo_queue #(

    .DATA_WIDTH(DATA_WIDTH)

) medium_fifo(

    .clk(clk),
    .rst(rst),

    .write_en(medium_write && !drop_medium),
    .read_en(medium_read),

    .data_in(medium_packet),
    .data_out(medium_data_out),

    .full(medium_full),
    .empty(medium_empty),
    .fifo_level(medium_level)

);

//=========================================================
// LOW FIFO
//=========================================================

wire [DATA_WIDTH-1:0] low_data_out;
wire low_empty;
wire low_full;
wire [4:0] low_level;

fifo_queue #(

    .DATA_WIDTH(DATA_WIDTH)

) low_fifo(

    .clk(clk),
    .rst(rst),

    .write_en(low_write && !drop_low),
    .read_en(low_read),

    .data_in(low_packet),
    .data_out(low_data_out),

    .full(low_full),
    .empty(low_empty),
    .fifo_level(low_level)

);

//=========================================================
// Adaptive Weight Controller (Research Version)
//=========================================================

wire [3:0] high_weight;
wire [3:0] medium_weight;
wire [3:0] low_weight;

adaptive_weight_controller adaptive_qos(

    .clk(clk),
    .rst(rst),

    .high_level(high_level),
    .medium_level(medium_level),
    .low_level(low_level),

    .high_weight(high_weight),
    .medium_weight(medium_weight),
    .low_weight(low_weight)

);

//=========================================================
// LFSR Random Generator
//=========================================================

wire [3:0] random_value;

lfsr_random rand_gen(

    .clk(clk),
    .rst(rst),

    .random_value(random_value)

);

//=========================================================
// Adaptive WRED Controller
//=========================================================

adaptive_wred_controller adaptive_wred(

    .clk(clk),
    .rst(rst),

    .high_level(high_level),
    .medium_level(medium_level),
    .low_level(low_level),

    .high_weight(high_weight),
    .medium_weight(medium_weight),
    .low_weight(low_weight),

    .random_value(random_value),
    .drop_level(drop_level),

    .drop_high(drop_high),
    .drop_medium(drop_medium),
    .drop_low(drop_low)

);
//=========================================================
// WRR Scheduler
//=========================================================

scheduler sched(

    .clk(clk),
    .rst(rst),

    .high_empty(high_empty),
    .medium_empty(medium_empty),
    .low_empty(low_empty),

    .high_weight(aqde_high_weight),
    .medium_weight(aqde_medium_weight),
    .low_weight(aqde_low_weight),

    .m_axis_tready(m_axis_tready),
    
    .high_read(high_read),
    .medium_read(medium_read),
    .low_read(low_read)

);

//=========================================================
// Output Mux
//=========================================================

wire [DATA_WIDTH-1:0] output_packet;
wire output_valid;

assign output_packet =
        high_read   ? high_data_out :
        medium_read ? medium_data_out :
        low_read    ? low_data_out :
        64'd0;

assign output_valid =
        (high_read | medium_read | low_read) &
        m_axis_tready;
        
//=========================================================
// Packet Statistics
//=========================================================

wire [31:0] total_packets;
wire [31:0] high_packets;
wire [31:0] medium_packets;
wire [31:0] low_packets;
wire [31:0] transmitted_packets;

packet_statistics stats(

    .clk(clk),
    .rst(rst),

    .valid(valid),
    .priority(priority),

    .output_valid(output_valid),

    .total_packets(total_packets),
    .high_packets(high_packets),
    .medium_packets(medium_packets),
    .low_packets(low_packets),
    .transmitted_packets(transmitted_packets)

);

//=========================================================
// Drop Controller
//=========================================================

wire drop_packet;
wire [31:0] dropped_packets;

drop_controller drop(

    .clk(clk),
    .rst(rst),

    .valid(valid),

    .high_write(high_write),
    .medium_write(medium_write),
    .low_write(low_write),

    .high_full(high_full),
    .medium_full(medium_full),
    .low_full(low_full),

    .drop_packet(drop_packet),
    .dropped_packets(dropped_packets)

);

//=========================================================
// Performance Monitor
//=========================================================

wire [31:0] clock_cycles;
wire [31:0] throughput;

//=========================================================
// Latency Analyzer Signals
//=========================================================

wire [31:0] current_latency;
wire [31:0] min_latency;
wire [31:0] max_latency;
wire [31:0] avg_latency;
wire [31:0] packets_measured;

performance_monitor perf(

    .clk(clk),
    .rst(rst),

    .valid(valid),
    .output_valid(output_valid),

    .clock_cycles(clock_cycles),
    .throughput(throughput)

);

//=========================================================
// Queue Utilization Monitor Signals
//=========================================================

wire [6:0] high_utilization;
wire [6:0] medium_utilization;
wire [6:0] low_utilization;

//=========================================================
// Fairness Index Signal
//=========================================================

wire [6:0] fairness_index;

//=========================================================
// Latency Analyzer
//=========================================================

latency_analyzer latency(

    .clk(clk),
    .rst(rst),

    .valid(valid),
    .output_valid(output_valid),

    .current_latency(current_latency),
    .min_latency(min_latency),
    .max_latency(max_latency),
    .avg_latency(avg_latency),
    .packets_measured(packets_measured)

);

//=========================================================
// Queue Utilization Monitor
//=========================================================

queue_utilization_monitor utilization(

    .clk(clk),
    .rst(rst),

    .high_level(high_level),
    .medium_level(medium_level),
    .low_level(low_level),

    .high_utilization(high_utilization),
    .medium_utilization(medium_utilization),
    .low_utilization(low_utilization)

);

//=========================================================
// Fairness Index Calculator
//=========================================================

fairness_index_calculator fairness(

    .clk(clk),
    .rst(rst),

    .high_packets(high_packets),
    .medium_packets(medium_packets),
    .low_packets(low_packets),

    .fairness_index(fairness_index)

);

//=========================================================
// AQDE Signals
//=========================================================

// Network State Analyzer
wire [1:0] load_state;
wire [1:0] latency_state;
wire [1:0] fairness_state;
wire [1:0] congestion_state;

// QoS Score
wire [7:0] qos_score;

// Decision Unit
wire [1:0] qos_profile;
wire [1:0] congestion_mode;

// Profile Mapper Outputs
wire [3:0] aqde_high_weight;
wire [3:0] aqde_medium_weight;
wire [3:0] aqde_low_weight;

wire [1:0] drop_level;

network_state_analyzer state_analyzer(

    .clk(clk),
    .rst(rst),

    .high_level(high_level),
    .medium_level(medium_level),
    .low_level(low_level),

    .avg_latency(avg_latency),
    .throughput(throughput),
    .fairness_index(fairness_index),

    .load_state(load_state),
    .latency_state(latency_state),
    .fairness_state(fairness_state),
    .congestion_state(congestion_state)

);

qos_score_calculator qos_score_calc(

    .clk(clk),
    .rst(rst),

    .load_state(load_state),
    .latency_state(latency_state),
    .fairness_state(fairness_state),

    .throughput(throughput),

    .qos_score(qos_score)

);

adaptive_decision_unit decision(

    .clk(clk),
    .rst(rst),

    .qos_score(qos_score),

    .qos_profile(qos_profile),
    .congestion_mode(congestion_mode)

);

qos_profile_mapper mapper(

    .clk(clk),
    .rst(rst),

    .qos_profile(qos_profile),

    .high_weight(aqde_high_weight),
    .medium_weight(aqde_medium_weight),
    .low_weight(aqde_low_weight),

    .drop_level(drop_level)

);

//=========================================================
// AXI4-Stream Output
//=========================================================

//=========================================================
// Multi-Beat AXI4-Stream Transmitter
//=========================================================

reg [1:0] beat_count;

reg [63:0] axi_data;
reg        axi_valid;
reg        axi_last;

always @(posedge clk)
begin

    if(rst)
    begin
        beat_count <= 2'd0;

        axi_data  <= 64'd0;
        axi_valid <= 1'b0;
        axi_last  <= 1'b0;
    end

    else
    begin

        axi_valid <= 1'b0;
        axi_last  <= 1'b0;

        if(output_valid && m_axis_tready)
        begin

            axi_valid <= 1'b1;

            // For now send the same packet four times
            axi_data <= output_packet;

            if(beat_count == 2'd3)
            begin
                axi_last   <= 1'b1;
                beat_count <= 2'd0;
            end
            else
            begin
                beat_count <= beat_count + 1'b1;
            end

        end

    end

end

assign m_axis_tdata  = axi_data;
assign m_axis_tvalid = axi_valid;
assign m_axis_tlast  = axi_last;

endmodule        
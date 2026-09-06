
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.08.2026 21:47:10
// Design Name: 
// Module Name: tb_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns/1ps

module tb_top();

//------------------------------------------------------
// Clock & Reset
//------------------------------------------------------

reg clk;
reg rst;

//------------------------------------------------------
// AXI-Stream Interface
//------------------------------------------------------

wire [63:0] m_axis_tdata;
wire        m_axis_tvalid;
wire        m_axis_tlast;

reg         m_axis_tready;

//------------------------------------------------------
// Instantiate Top Module
//------------------------------------------------------

top uut(

    .clk(clk),
    .rst(rst),

    .m_axis_tdata(m_axis_tdata),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tready(m_axis_tready),
    .m_axis_tlast(m_axis_tlast)

);

//------------------------------------------------------
// Clock Generation
//------------------------------------------------------

always #5 clk = ~clk;

//------------------------------------------------------
// Test Stimulus
//------------------------------------------------------

initial
begin

    clk = 0;
    rst = 1;
    m_axis_tready = 1;

    #20;
    rst = 0;

    //--------------------------------------------------
    // Normal Operation
    //--------------------------------------------------

    #100;

    //--------------------------------------------------
    // Congestion Starts
    //--------------------------------------------------

    m_axis_tready = 0;

    #150;

    //--------------------------------------------------
    // Receiver Recovers
    //--------------------------------------------------

    m_axis_tready = 1;

    #250;

    $finish;

end

endmodule
`timescale 1ns / 1ps

module packet_generator #

(

    parameter DATA_WIDTH = 64

)

(

    input clk,
    input rst,

    output reg [DATA_WIDTH-1:0] packet,
    output reg valid

);

reg [15:0] packet_id;
reg [2:0]  priority;
reg [1:0]  protocol;
reg [7:0]  destination;
reg [15:0] length;

always @(posedge clk)
begin

    if (rst)
    begin
        packet_id   <= 16'd0;
        priority    <= 3'd0;
        protocol    <= 2'd0;
        destination <= 8'd0;
        length      <= 16'd64;

        packet <= {DATA_WIDTH{1'b0}};
        valid  <= 1'b0;
    end

    else
    begin

        valid <= 1'b1;

        // Update internal registers
        packet_id   <= packet_id + 16'd1;
        priority    <= priority + 3'd1;
        protocol    <= protocol + 2'd1;
        destination <= destination + 8'd1;
        length      <= length + 16'd8;

        // Build packet using the NEXT values
       packet <= {

    packet_id + 16'd1,
    priority + 3'd1,
    protocol + 2'd1,
    destination + 8'd1,
    length + 16'd8,
    {(DATA_WIDTH-46){1'b0}}

};

    end

end

endmodule
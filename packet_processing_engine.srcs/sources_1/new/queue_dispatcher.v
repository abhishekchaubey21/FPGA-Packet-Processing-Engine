`timescale 1ns / 1ps

module queue_dispatcher #

(

    parameter DATA_WIDTH = 64

)

(

    input clk,
    input rst,

    input [DATA_WIDTH-1:0] packet,
    input valid,

    input [1:0] queue_select,

    output reg high_write,
    output reg medium_write,
    output reg low_write,

    output reg [DATA_WIDTH-1:0] high_packet,
output reg [DATA_WIDTH-1:0] medium_packet,
output reg [DATA_WIDTH-1:0] low_packet

);

always @(posedge clk)
begin

    if(rst)
    begin

        high_write   <= 1'b0;
        medium_write <= 1'b0;
        low_write    <= 1'b0;

        high_packet   <= {DATA_WIDTH{1'b0}};
medium_packet <= {DATA_WIDTH{1'b0}};
low_packet    <= {DATA_WIDTH{1'b0}};

    end

    else
    begin

        // Default values every clock
        high_write   <= 1'b0;
        medium_write <= 1'b0;
        low_write    <= 1'b0;

        high_packet   <= {DATA_WIDTH{1'b0}};
medium_packet <= {DATA_WIDTH{1'b0}};
low_packet    <= {DATA_WIDTH{1'b0}};

        if(valid)
        begin

            case(queue_select)

                2'b00:
                begin
                    low_write  <= 1'b1;
                    low_packet <= packet;
                end

                2'b01:
                begin
                    medium_write  <= 1'b1;
                    medium_packet <= packet;
                end

                2'b10:
                begin
                    high_write  <= 1'b1;
                    high_packet <= packet;
                end

                default:
                begin
                end

            endcase

        end

    end

end

endmodule
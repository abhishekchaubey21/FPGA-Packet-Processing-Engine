`timescale 1ns / 1ps

module fifo_queue #

(

    parameter DATA_WIDTH = 64,
    parameter DEPTH      = 16,
    parameter ADDR_WIDTH = 4

)

(

    input clk,
    input rst,

    input write_en,
    input read_en,

    input  [DATA_WIDTH-1:0] data_in,

    output reg [DATA_WIDTH-1:0] data_out,

    output full,
output empty,

output [ADDR_WIDTH:0] fifo_level

);



reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];

reg [ADDR_WIDTH-1:0] write_ptr;
reg [ADDR_WIDTH-1:0] read_ptr;

reg [4:0] count;

//-------------------------------------------
// Status Signals
//-------------------------------------------

assign empty      = (count == 0);
assign full       = (count == DEPTH);
assign fifo_level = count;

//-------------------------------------------
// FIFO Logic
//-------------------------------------------

always @(posedge clk)
begin

    if(rst)
    begin

        write_ptr <= 0;
        read_ptr  <= 0;
        count     <= 0;
        data_out <= {DATA_WIDTH{1'b0}};

    end

    else
    begin

        case ({write_en && !full, read_en && !empty})

        //=====================================
        // WRITE ONLY
        //=====================================

        2'b10:
        begin

            memory[write_ptr] <= data_in;
            write_ptr <= write_ptr + 1;
            count <= count + 1;

        end

        //=====================================
        // READ ONLY
        //=====================================

        2'b01:
        begin

            data_out <= memory[read_ptr];
            read_ptr <= read_ptr + 1;
            count <= count - 1;

        end

        //=====================================
        // READ + WRITE SAME CLOCK
        //=====================================

        2'b11:
        begin

            memory[write_ptr] <= data_in;
            write_ptr <= write_ptr + 1;

            data_out <= memory[read_ptr];
            read_ptr <= read_ptr + 1;

            // count remains unchanged

        end

        default:
        begin
            // No operation
        end

        endcase

    end

end

endmodule


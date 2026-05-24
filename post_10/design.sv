`timescale 1ns/1ps

module updown_counter (input clk, reset, up_down, output reg [3:0] count);

    always @(posedge clk, posedge reset) begin
      if (reset) count <= 4'b0000;
        else if (! reset) begin
          if (up_down) count <= count + 4'b0001;
            else count <= count - 4'b0001;
        end
        else count <= count;
    end
endmodule

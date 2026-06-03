// Code your design here
module mod_n_counter (input reset, clk, input [3:0] modulo, output reg [3:0] count );
    always @(posedge clk, posedge reset) begin
      if (reset) count <= 4'b0;
        else begin
            if (count < (modulo -1) ) begin
                 count <= count + 4'b0001;
            end
            else count <= 4'b0;
        end
    end
endmodule


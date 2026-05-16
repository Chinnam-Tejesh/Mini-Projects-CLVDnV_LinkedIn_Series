// Code your testbench here
// or browse Examples

`timescale 1ns / 1ps

module decoder3t8_tb ();
  reg [2:0] inp;
  wire [7:0] outp;
  integer i;

  decoder3t8 call0 (
      .in (inp),
      .out(outp)
  );

  initial begin
    $dumpfile("sim_waves.vcd");
    $dumpvars(0, decoder3t8_tb);

    $monitor("in= %b | out= %b", inp, outp);


    for (i = 0; i < 8; i = i + 1) begin
      inp = i;
      #5;
    end
  end
endmodule

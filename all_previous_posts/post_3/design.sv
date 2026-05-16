// Code your design here

`timescale 1ns / 1ps

module decoder3t8 (
    input  [2:0] in,
    output [7:0] out
);

  wire [3:0] dec1_out, dec2_out;

  decoder2t4 call0 (
      .ip(in[1:0]),
      .op(dec1_out),
      .en(~in[2])
  );
  decoder2t4 call1 (
      .ip(in[1:0]),
      .op(dec2_out),
      .en(in[2])
  );

  assign out = (in[2]) ? {dec2_out, 4'b0000} : {4'b0000, dec1_out};

endmodule


module decoder2t4 (
    input [1:0] ip,
    input en,
    output reg [3:0] op
);
  //using behaviroual modelling
  always @(*) begin
    op = 4'b0;
    if (en) op[ip] = 1'b1;
  end
  // using dataflow modeling
endmodule

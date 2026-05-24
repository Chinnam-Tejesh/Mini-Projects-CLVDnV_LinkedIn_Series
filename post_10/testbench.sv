`timescale 1ns/1ps

module updown_counter_tb ();
  reg clk_i, reset_i, up_down_i;
  wire [3:0] out;
  
  updown_counter Call0 (.clk(clk_i), .reset(reset_i), .up_down(up_down_i), .count(out));
  
  // clock behaviour
  initial begin 
    clk_i = 1'b1;
    forever
    #0.5 clk_i = ~clk_i; //clk with Tp of 1ns
  end
  
  //Tasks for testing
  task tst_upcnt();
    reg [3:0] exp_up;
  	begin
      //preset values
      up_down_i = 1'b1;
      
      //reset code
      reset_i = 1'b1;
      @(posedge clk_i);
      reset_i = 1'b0;
      @(posedge clk_i);
      
      //UP COUNT task code
      $display("ENTERED UP COUNT TASK");
      reset_i = 1'b0;
      exp_up = 0;
      repeat (16) 
        begin
          if (out == exp_up)
            $display("time: %t | out: %d | expected: %d", $time, out, exp_up);
          else
            $error("ISSUE IN UP COUNTING");
          
          exp_up += 1;
          @(posedge clk_i);
        end
        
      @(posedge clk_i);
      $display("[PASS if no Error(s) in LOG ] UPCOUNT TASK EXITED");
  	end
  endtask
  
  task tst_downcnt();
    reg [3:0] exp_down;
  	begin
      //preset values
      up_down_i = 1'b0;
      
      //reset code
      reset_i = 1'b1;
      @(posedge clk_i);
      reset_i = 1'b0;
      @(posedge clk_i);
      
      // DOWN COUNT task code
      $display("ENTERED DOWN COUNT TASK");
      reset_i = 1'b0;
      exp_down = 0;
      repeat (16)
        begin
          #0.01;
          exp_down -= 1;
          if (out == exp_down)
            $display("time: %t | out: %d | expected: %d", $time, out, exp_down);
          else
            $error("ISSUE IN DOWN COUNTING");
          
          @(posedge clk_i);
        end
      
      @(posedge clk_i);
      $display("[PASS if no Error(s) in LOG ] DOWNCOUNT TASK EXITED");
    end
  endtask
  
  // Test Flow
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, updown_counter_tb);
    
    @(posedge clk_i);
    tst_upcnt();
    tst_downcnt();
    
    #5 $finish();
  end
endmodule


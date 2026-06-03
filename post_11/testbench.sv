// Code your testbench here
// or browse Examples


//Using the default testbench from RTLHub

`timescale 1ns/1ps

module tb_top;
    // Testbench signals
  reg clk;
  reg reset;
  reg [3:0] modulo;
  wire [3:0] count;
    
    // Test counters
  integer test_count;
  integer pass_count;
  integer fail_count;

    // Instantiate the DUT (Device Under Test)
  mod_n_counter dut (
    .clk(clk),
    .reset(reset),
    .modulo(modulo),
    .count(count)
  );

    // Clock generation (10ns period = 100MHz)
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

    // Waveform dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_top);
  end

    // Test sequence
  initial begin
        // Initialize counters
    test_count = 0;
    pass_count = 0;
    fail_count = 0;
        
    $display("Testing Variable Mod-N Counter");
    $display("Time | reset | modulo | count | Notes");
        
        // Initialize with reset
    reset = 1;
    modulo <= 4'd5;
    #12;
    $display("%4t |   %b   |   %2d   |  %2d   | Reset active", $time, reset, modulo, count);
        
    test_count = test_count + 1;
    if (count !== 4'd0) begin
      $display("ERROR: Count should be 0 during reset, got %d", count);
      fail_count = fail_count + 1;
    end else begin
      pass_count = pass_count + 1;
    end
    
        // Test Mod-5 Counter (0→1→2→3→4→0)
    reset = 0;
    #2;
    $display("\n--- Testing Mod-5 Counter ---");
    $display("%4t |   %b   |   %2d   |  %2d   | Reset released", $time, reset, modulo, count);
        
        // Count through one complete cycle
    repeat(5) begin
      @(posedge clk);
      #2;
      $display("%4t |   %b   |   %2d   |  %2d   | Counting", $time, reset, modulo, count);
    end
        
        // After 5 clocks, should be back at 0
    test_count = test_count + 1;
    if (count !== 4'd0) begin
      $display("ERROR: Mod-5 counter should wrap to 0, got %d", count);
      fail_count = fail_count + 1;
    end else begin
      pass_count = pass_count + 1;
    end
        
        // Test Mod-3 Counter
    modulo <= 4'd3;
    $display("\n--- Testing Mod-3 Counter ---");
        
        // Reset to start clean
    reset = 1;
    #2;
    reset = 0;
    #2;
    $display("%4t |   %b   |   %2d   |  %2d   | Switched to Mod-3", $time, reset, modulo, count);
    
        // Count through one complete cycle
    repeat(3) begin
      @(posedge clk);
      #2;
      $display("%4t |   %b   |   %2d   |  %2d   | Counting", $time, reset, modulo, count);
    end
        
        // After 3 clocks, should be back at 0
    test_count = test_count + 1;
    if (count !== 4'd0) begin
      $display("ERROR: Mod-3 counter should wrap to 0, got %d", count);
      fail_count = fail_count + 1;
    end else begin
      pass_count = pass_count + 1;
    end
        
    // Test Mod-10 Counter
    modulo <= 4'd10;
    $display("\n--- Testing Mod-10 Counter ---");
    reset = 1;
    #2;
    reset = 0;
    #2;
    $display("%4t |   %b   |   %2d   |  %2d   | Switched to Mod-10", $time, reset, modulo, count);
        
        // Count till 9
    repeat(9) begin
      @(posedge clk);
      #2;
    end
    $display("%4t |   %b   |   %2d   |  %2d   | At maximum (9)", $time, reset, modulo, count);
        
        // After 9 clocks, should be at 9
    test_count = test_count + 1;
    if (count !== 4'd9) begin
      $display("ERROR: Mod-10 counter should be at 9, got %d", count);
      fail_count = fail_count + 1;
    end else begin
      pass_count = pass_count + 1;
    end
        
        // next clock should wrap to 0
    @(posedge clk);
    #2;
    $display("%4t |   %b   |   %2d   |  %2d   | Wrapped to 0", $time, reset, modulo, count);
    test_count = test_count + 1;
    if (count !== 4'd0) begin
      $display("ERROR: Mod-10 counter should wrap to 0, got %d", count);
      fail_count = fail_count + 1;
    end else begin
      pass_count = pass_count + 1;
    end
        
        // Test Mod-16 Counter (or modulo=0 treated as 16)
    modulo <= 4'd0;
    $display("\n--- Testing Mod-16 Counter (modulo=0) ---");
        
    reset = 1;
    #2;
    reset = 0;
    #2;
    $display("%4t |   %b   |   %2d   |  %2d   | Switched to Mod-16", $time, reset, modulo, count);
    
        // Count to 15
    repeat(15) begin
      @(posedge clk);
      #2;
    end
    $display("%4t |   %b   |   %2d   |  %2d   | At maximum (15)", $time, reset, modulo, count);
    
      	// should be 15
    test_count = test_count + 1;
    if (count !== 4'd15) begin
      $display("ERROR: Mod-16 counter should be at 15, got %d", count);
      fail_count = fail_count + 1;
    end else begin
      pass_count = pass_count + 1;
    end
        
        // next clock should wrap to 0
    @(posedge clk);
    #2;
    $display("%4t |   %b   |   %2d   |  %2d   | Wrapped to 0", $time, reset, modulo, count);
        
    test_count = test_count + 1;
    if (count !== 4'd0) begin
      $display("ERROR: Mod-16 counter should wrap to 0, got %d", count);
      fail_count = fail_count + 1;
    end else begin
      pass_count = pass_count + 1;
    end
        
        // Test changing modulo during operation
    $display("\n--- Testing Modulo Change During Operation ---");
      
    modulo <= 4'd7;
      
    reset = 1;
    #2;
    reset = 0;
    #2;
        
        // Count to 3
    repeat(3) begin
      @(posedge clk);
      #2;
    end
    $display("%4t |   %b   |   %2d   |  %2d   | At count 3 with Mod-7", $time, reset, modulo, count);
    
        // Change to Mod-3 (should wrap on next clock since 3 >= 3)
    modulo <= 4'd3;
    @(posedge clk);
    #2;
    $display("%4t |   %b   |   %2d   |  %2d   | Changed to Mod-3", $time, reset, modulo, count);
        
        // Since count was 3 and modulo is now 3, it should wrap to 0
    test_count = test_count + 1;
    if (count !== 4'd0) begin
      $display("ERROR: Should wrap to 0 when count >= modulo, got %d", count);
      fail_count = fail_count + 1;
    end else begin
      pass_count = pass_count + 1;
    end
        
        // Test asynchronous reset during counting
    $display("\n--- Testing Asynchronous Reset ---");
    modulo <= 4'd8;
    reset = 1;
    #2;
    reset = 0;
    #2;
        
    repeat(5) begin
      @(posedge clk);
      #2;
    end
        
    $display("%4t |   %b   |   %2d   |  %2d   | Before reset", $time, reset, modulo, count);
        
        // Assert reset mid-cycle
    #3;
    reset = 1;
    #1;
    $display("%4t |   %b   |   %2d   |  %2d   | Async reset (mid-cycle)", $time, reset, modulo, count);
        
    test_count = test_count + 1;
    if (count !== 4'd0) begin
      $display("ERROR: Asynchronous reset failed, count=%d", count);
      fail_count = fail_count + 1;
    end else begin
      pass_count = pass_count + 1;
    end
        
    reset = 0;
    #10;
        
        // Display final summary
    $display("\n============================================================");
    $display("Test Summary:");
    $display("Total Tests: %0d", test_count);
    $display("Passed : %0.2f%%", (pass_count * 100)/test_count);
    $display("Failed : %0.2f%%", (fail_count * 100)/test_count);
    if (fail_count == 0)
      $display("\n*** ALL TESTS PASSED ***");
    else
      $display("\n*** SOME TESTS FAILED ***");
    $display("============================================================");
        
    $display("\nTest completed");
      
    #10;
    $finish();
  end

endmodule

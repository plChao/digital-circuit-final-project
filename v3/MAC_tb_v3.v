//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.11.2018 16:21:09
// Design Name: 
// Module Name: test_bench
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
//`include "PATTERN_example.v"


`ifdef RTL
  `include "MAC_v3.v"
`endif

`ifdef GATE
  `include "Netlist/MAC_v3_SYN.v"
`endif

`define clk_PERIOD  1.0
//initial begin
//    $dumpfile("Carry_Select_Adder.vcd");
//    $dumpvars;
//end

module MAC_tb;

initial begin
//  `ifdef RTL
    $fsdbDumpfile("MAC_v3.fsdb");
    $fsdbDumpvars();
//  `endif
  `ifdef GATE
    $sdf_annotate("Netlist/MAC_v2_SYN.sdf",u_MAC);
    $fsdbDumpfile("MAC_v3_SYN.fsdb");
    $fsdbDumpvars();    
  `endif
end

    reg clk, reset;
	reg [3:0] a;
	reg [3:0] b;
	reg in_valid;
	
	// Outputs
	wire [9:0] out;
	wire out_valid;
	real	CYCLE = `clk_PERIOD;
	initial clk = 0;
	always #(CYCLE/2) clk = ~clk;

	// Instantiate the Unit Under Test (UUT)
	MAC_v3 uut ( 
		.in1_IFM(a), 
		.in2_IFM(b),
		.in_valid(in_valid),
		.clk(clk),
		.rst_n(reset), 
		.out(out),
		.out_valid(out_valid)
	);

	initial begin
		// Initialize Inputs
        reset = 0;
		//clk = 0;
		a = 0;
		b = 0;

		// Wait 100 ns for global reset to finish
		#10;
		reset = 1;
		in_valid=1;
        //clk = 0;//01000001101010010100011110101110==21.16
        /*a = 4'h40DD0000;//-4.6;
		b = 4'h00DD0000;//-4.6*/
		a = 4'd1;
		b = 4'd2;
		
		// Add stimulus here
#1;
		    	//clk = 0;//11000000001100001010001111010111==-2.76
		    	//reset = 0;
		/*a = 4'h40400000;//-4.6;
		b = 4'h40000000;//0.6*/
		a = 4'd2;
		b = 4'd3;
		// Add stimulus here
#1;
		a = 4'd0;
		b = 4'd0;
#10;
/*
    	clk = 0;//10111111111101011100001010001111==-1.92
    	//reset = 0;
		a = 32'b01000000010011001100110011001101;//3.2;
		b = 32'b10111111000110011001100110011010;//-0.6
		// Add stimulus here
#40;
 	clk = 0;//01001010100101010000111101101110==4884407.0
 	//reset = 0;
		a = 32'b01000101000010100111000011001101;//2215.05;
		b = 32'b01000101000010011101000110011010;//2205.10
		// Add stimulus here
#50;
    clk = 0;
    //reset = 0;
    a = 32'b00000100000101001110010100101100;//1750.25;
    b = 32'b00000010010100001001100010000010;//1525.19;
    // Add stimulus here
#60;*/
  $finish;
	end	

     //always #1 clk=(~clk);  
	 	 
endmodule
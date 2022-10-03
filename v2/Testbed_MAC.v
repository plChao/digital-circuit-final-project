/////////////////////////////////////////////////////////////////////////
// Project Name: MAC							   					   //
// Task Name   : MAC									  			   //
// Module Name : MAC	                               	  			   //
// File Name   : TESTBED_MAC.v          TESTBED                	  	   //
// Description : MAC					                               //
// Author      : 			 		                                   //
// Revision History:                                                   //
/////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
`include "Pattern_MAC.v"


`ifdef RTL
  `include "MAC_v2.v"
`endif

`ifdef GATE
  `include "Netlist/MAC_v2_SYN.v"
`endif


module TESTBED;
   //input
	wire clk;
	wire rst_n;
	wire in_valid;  
	wire [3:0]In_IFM_a;
	wire [3:0]In_IFM_b;
	
	//output
	wire out_valid;
	wire [9:0] out;

	
	
initial begin
  `ifdef RTL
    $fsdbDumpfile("MAC_v2.fsdb");
    $fsdbDumpvars();
  `endif
  `ifdef GATE
    $sdf_annotate("Netlist/MAC_v2_SYN.sdf", u_MAC_v2);
    $fsdbDumpfile("MAC_v2_SYN.fsdb");
    $fsdbDumpvars();    
  `endif
end

`ifdef RTL	
MAC_v2		u_MAC_v2(
		.clk(clk),
		.rst_n(rst_n),
		.in_valid(in_valid),
		.in1_IFM(In_IFM_a), 
		.in2_IFM(In_IFM_b),
		.out_valid(out_valid),
		.out(out)
		);
`endif

`ifdef GATE
MAC_v2		u_MAC_v2	(
		.clk(clk),
		.rst_n(rst_n),
		.in_valid(in_valid),
		.in1_IFM(In_IFM_a), 
		.in2_IFM(In_IFM_b),
		.out_valid(out_valid),
		.out(out)
		);
`endif

Pattern_MAC	u_Pattern_MAC(
		.clk(clk),
		.rst_n(rst_n),
		.in_valid(in_valid),
		.in1_IFM(In_IFM_a), 
		.in2_IFM(In_IFM_b),
		.out_valid(out_valid),
		.Out_OFM(out)
		);
		
endmodule
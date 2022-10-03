
//==============================================
//==============================================					
//												
//	File Name		:	PATTERN_Conv.v					
//	Module Name		:	PATTERN_Conv						
//	Release version	:	v1.0				
//												
//==============================================
//==============================================
`define clk_PERIOD  1  //# the unit of the clk_PERIOD  in here is ns 
//`define clk_PERIOD  0.5
module Pattern_MAC	(
	// output
    clk,
	rst_n,
	in_valid,
	in1_IFM, 
	in2_IFM,

	
	//input
    out_valid, 
	Out_OFM

);

//------------------------------
//	I/O Pors
//------------------------------
output reg clk;
output reg rst_n;
output reg in_valid;

output reg[3:0]in1_IFM;
output reg[3:0]in2_IFM;

input wire out_valid;
input wire [9:0]Out_OFM;

//------------------------------
//	Parameter & Integer
//------------------------------
real	CYCLE = `clk_PERIOD;
parameter Delay = 2.5;
parameter Pattern_num = 4;


integer seed = 25;
integer j;
integer i;
//------------------------------
//	Register
//------------------------------


reg Pattern_in_valid;
reg [3:0]Pattern_In_IFM_a;
reg [3:0]Pattern_In_IFM_b;
// reg [3:0]Pattern_In_IFM_3;
// reg [3:0]Pattern_In_IFM_4;

reg [9:0]Golden_OFM;

reg [30:0]latency;
reg [30:0]total_latency;

//------------------------------
//	Clock
//------------------------------
initial clk = 0;
always #(CYCLE/2) clk = ~clk;


//------------------------------
//	Initial
//------------------------------
initial begin
	clk=0;
	rst_n = 1; 
	latency = 0;
	total_latency = 0;
	Pattern_in_valid = 0;
	Pattern_In_IFM_a = 0;
	Pattern_In_IFM_b = 0;
	
	Golden_OFM = 0;
	
	Reset_signal_task;

	for(j=0;j<Pattern_num; j=j+1)begin
				
		Pattern_in_valid = 1;
		Pattern_In_IFM_a = j;
		Pattern_In_IFM_b = j+1;
			
		// Pattern_In_IFM_a = $random(seed);        // For test, we will use random  IFMs   to check your design 
		// Pattern_In_IFM_b = $random(seed);        // For test, we will use random  IFMs   to check your design 

		input_task;
		ans_gen_task;

		while(out_valid == 0)begin   //Wait Conv_2x2 calculate output
			@(posedge clk);
			in_valid = 0;
			in1_IFM = 'dx;
			in2_IFM = 'dx;

			latency = latency +1;	
			if(latency>10000)begin
				fail;
			end
		end
		check_ans_task;
		latency = latency -2;
		total_latency = latency + total_latency;
		latency = 0;
	end
	
	PASS;
	
end

//-----------------------------
//	Task
//-----------------------------
task Reset_signal_task; begin
	#(5.0);
	rst_n = 0;
	#(5.0);
	in_valid = 0;
	in1_IFM = 'd0;
	in2_IFM = 'd0;

	Golden_OFM = 0;
	if((out_valid !== 1'd0)||(Out_OFM !== 10'd0)) begin
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
		$display ("                                                                        FAIL!                                                               ");
		$display ("                                                  Output signal should be 0 after initial RESET at %t                                 ",$time);
		$display ("--------------------------------------------------------------------------------------------------------------------------------------------");

		fail;
	end
	#(5.0)
	rst_n = 1;
	#(5.0)
	release clk;
end endtask

task input_task; begin
	@(posedge clk);
	in_valid = Pattern_in_valid;
	in1_IFM = Pattern_In_IFM_a;
	in2_IFM = Pattern_In_IFM_b;

end endtask



task ans_gen_task; begin		

	Golden_OFM = (Pattern_In_IFM_a * Pattern_In_IFM_b) + Golden_OFM;

end endtask




//task wait_PE_Received_task; begin
//	
//	while (Received ==0) begin
//		latency = latency +1;
//	end
//	total_latency = total_latency + latency;
//
//end endtask





task check_ans_task; begin
	
		if(Golden_OFM !== Out_OFM) begin
					$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
					$display ("                                                                        OUTPUT FAIL!                                                        ");
					$display ("                                                                       PATTERN NO.%4d                                                         ",j);
					$display ("                                                           Ans(OUT): %d,  Your output : %4d  at %8t                           ",Golden_OFM,Out_OFM,$time);
					$display ("--------------------------------------------------------------------------------------------------------------------------------------------");
					repeat(9) @(posedge clk);
					$finish;
		end	
end endtask















task PASS;begin
$display("\033[0;92m PASS \033[0;39m");
$finish;	
end endtask

task fail;begin
$display("\033[0;40;31m FAIL \033[0;39m");
$finish;
end
endtask


endmodule
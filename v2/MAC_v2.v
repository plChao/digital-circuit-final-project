module MAC_v2(in1_IFM, in2_IFM, out ,clk, rst_n,in_valid,out_valid);

input [3:0]in1_IFM;
input [3:0]in2_IFM;
reg [3:0]in1,in2;
input clk, rst_n;
input in_valid;
output reg out_valid;
output reg [9:0]out;  
reg [1:0]cstate;
reg [1:0]nstate;
//---------------------------------
//      Parameter declaration
//---------------------------------
parameter IDLE       = 2'd0;
parameter IN         = 2'd1;
parameter Cal        = 2'd2;
parameter Out        = 2'd3;

//----------------------------------------------------
//          Finite-state machine (FSM)
//----------------------------------------------------
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cstate <= IDLE;
	else 
		cstate <= nstate;
end

always@(*)
begin
	case(cstate)
		IDLE:  
			if(in_valid==1)   
				nstate = IN;      
			else
				nstate = cstate;
		IN:
			nstate = Cal;
		Cal:  
			nstate = Out;         
		
		Out: 	                           
			nstate = IDLE;
		default
			nstate = cstate;
	endcase
end

always@(posedge clk or negedge rst_n)  // receive weights
begin
	if(!rst_n)
		begin
			in1 <= 4'd0;
			in2 <= 4'd0;
			
		end
	else if(in_valid == 1)
		begin
			in1 <= in1_IFM;
			in2 <= in2_IFM;	
				
		end
	else if(cstate == IDLE)
		begin
			in1 <= 4'd0;
			in2 <= 4'd0;
		
		end	
	else
		begin
			in1 <= 0;
			in2 <= 0;
		end
end




reg [7:0] temp;
reg [7:0] ttemp;
reg [7:0] tttemp;

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		temp <= 0;
		ttemp <= 0;
		tttemp <= 0;
	end
	else begin
		temp <= in1*in2;
		ttemp <= temp;
		tttemp <= temp+tttemp;
	end
end





always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		out <= 19'd0;
	else if(cstate == Out)
		out <= tttemp;
	else 
		out <= 19'd0;
end

//output valid
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		out_valid <= 1'd0;
	else if(cstate == Out)
		out_valid <= 1'd1;
	else 
		out_valid <= 1'd0;

end

endmodule




module MAC_v5(in1_IFM, in2_IFM, out ,clk, rst_n,in_valid,out_valid); //mul+RCA

input [3:0]in1_IFM;
input [3:0]in2_IFM;
reg [3:0]in1,in2;
input clk, rst_n;
input in_valid;
output reg out_valid;
output reg [9:0]out;  //////
reg [5:0]counter;
wire [7:0] fprod;
wire [9:0]fadd;
wire temp_1;
wire [7:0]temp_0;
reg [7:0]fprod_1, sum;
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
			in1 <= 4'd0;
			in2 <= 4'd0;
	
		end
end


//wallace_mul wm_1(in1, in2, fprod);
//wallace_mul wm_1(data_a, data_b, fprod);
/*Adder addr_1(fprod_1, out, fadd);*/
//Adder addr_1(fprod_1, sum, 0, temp_0, temp_1);
assign fprod = in1*in2;
ripple_carry_adder RCA1(fprod_1, sum, 1'd0, temp_0, temp_1);

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		//data_a <= 0;
		//data_b <= 0;
		fprod_1 <= 0;
		sum <= 0;
		counter <= 0;
	end
	else begin
		if(counter>=3&&counter<=20)begin
			//data_a <= in1;
			//data_b <= in2;
			fprod_1 <= fprod;
			sum <= {temp_1 , temp_0};
			counter <= counter+1;
		end
		/*else if(counter>=20)begin
			counter<=0;
			data_a <= in1;
			data_b <= in2;
			fprod_1 <= fprod;
			out <= {temp_1 , temp_0};
		end*/
		else begin
			//data_a <= in1;
			//data_b <= in2;
			fprod_1 <= fprod;
			/*out <= fadd;*/
			sum <= {temp_1 , temp_0};
			counter <= counter +1;
		end
	end
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		out <= 19'd0;
	else if(cstate == Out)
		out <= sum;
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




//ADDER//

// ripple_carry_adder//
module ripple_carry_adder(   input [7:0] A,B,
            input cin,
            output [7:0] S,
            output cout
            );
   /*output [7:0] S;  // The 8-bit sum.
   output 	C;  // The 1-bit carry.
   input [7:0] 	A;  // The 8-bit augend.
   input [7:0] 	B;  // The 8-bit addend.*/

   wire 	C0; // The carry out bit of fa0, the carry in bit of fa1.
   wire 	C1; // The carry out bit of fa1, the carry in bit of fa2.
   wire 	C2; // The carry out bit of fa2, the carry in bit of fa3.
   wire 	C3; // The carry out bit of fa0, the carry in bit of fa4.
   wire 	C4; // The carry out bit of fa1, the carry in bit of fa5.
   wire 	C5; // The carry out bit of fa2, the carry in bit of fa6.
   wire 	C6; // The carry out bit of fa2, the carry in bit of fa7.
   
   fulladder fa0(A[0], B[0], 1'd0, S[0], C0);    // Least significant bit.
   fulladder fa1(A[1], B[1], C0, S[1], C1);
   fulladder fa2(A[2], B[2], C1, S[2], C2);
   fulladder fa3(A[3], B[3], C2, S[3], C3);    
   fulladder fa4(A[4], B[4], C3, S[4], C4);    
   fulladder fa5(A[5], B[5], C4, S[5], C5);
   fulladder fa6(A[6], B[6], C5, S[6], C6);
   fulladder fa7(A[7], B[7], C6, S[7], cout);    // Most significant bit.
   
endmodule 
// ripple_carry_adder//


//module of carry select adder
module fulladder(in1,in2,cin,sum,cout);
input in1,in2;
input cin;
output sum,cout;

assign {cout,sum}=in1+in2+cin;

endmodule

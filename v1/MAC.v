module MAC(in1_IFM, in2_IFM, out ,clk, rst_n,in_valid,out_valid); //wallace tree+serial adder

input [3:0]in1_IFM;
input [3:0]in2_IFM;
reg [3:0]in1,in2;
input clk, rst_n;
input in_valid;
output reg out_valid;
output reg [9:0]out;  //////
reg [8:0]sum;
reg [5:0]counter;
wire [7:0] fprod;
wire [9:0]fadd;
wire temp_1;
wire [7:0]temp_0;
reg [7:0] data_a, data_b, fprod_1;
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


wallace_mul wm_1(in1, in2, fprod);

Adder addr_1(fprod_1, sum, 1'd0, temp_0, temp_1);


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

/*Adder_Basic*///fulladder
module Adder(
    //Input Port
	A,	
	B,
	cin,
    //Output Port
	S,
	cout
    );
input [7:0]A;
input [8:0]B;
input cin;
output wire [7:0] S;
output wire cout;
assign {cout,S} = A + B;

endmodule
/*Adder_Basic*/




///ADDER//



//module of wallece tree multiplier
module wallace_mul(A,B,prod);
    
    //inputs and outputs
    input [3:0] A,B;
    output [7:0] prod;
    //internal variables.
    wire s11,s12,s13,s14,s15,s22,s23,s24,s25,s26,s32,s33,s34,s35,s36,s37;
    wire c11,c12,c13,c14,c15,c22,c23,c24,c25,c26,c32,c33,c34,c35,c36,c37;
    wire [6:0] p0,p1,p2,p3;

//initialize the p's.
    assign  p0 = A & {4{B[0]}};
    assign  p1 = A & {4{B[1]}};
    assign  p2 = A & {4{B[2]}};
    assign  p3 = A & {4{B[3]}};

//final product assignments    
    assign prod[0] = p0[0];
    assign prod[1] = s11;
    assign prod[2] = s22;
    assign prod[3] = s32;
    assign prod[4] = s34;
    assign prod[5] = s35;
    assign prod[6] = s36;
    assign prod[7] = s37;

//first stage
    half_adder ha11 (p0[1],p1[0],s11,c11);
    fulladder fa112(p0[2],p1[1],p2[0],s12,c12);
    fulladder fa113(p0[3],p1[2],p2[1],s13,c13);
    fulladder fa114(p1[3],p2[2],p3[1],s14,c14);
    half_adder ha15(p2[3],p3[2],s15,c15);

//second stage
    half_adder ha22 (c11,s12,s22,c22);
    fulladder fa123 (p3[0],c12,s13,s23,c23);
    fulladder fa124 (c13,c32,s14,s24,c24);
    fulladder fa125 (c14,c24,s15,s25,c25);
    fulladder fa126 (c15,c25,p3[3],s26,c26);

//third stage
    half_adder ha32(c22,s23,s32,c32);
    half_adder ha34(c23,s24,s34,c34);
    half_adder ha35(c34,s25,s35,c35);
    half_adder ha36(c35,s26,s36,c36);
    half_adder ha37(c36,c26,s37,c37);
	
endmodule



//module of half adder
module half_adder(in1,in2, sum, cout );
input in1,in2;
output sum,cout;

assign {cout,sum}=in1+in2;

endmodule


//module of full adder
module fulladder(in1,in2,cin,sum,cout);
input in1,in2;
input cin;
output sum,cout;

assign {cout,sum}=in1+in2+cin;

endmodule






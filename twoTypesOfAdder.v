//verilog Logic Circuit mid project
//by Amin Rashidbeigi
//November 2016 


//implementing halfadder module
module halfadder (S,C,x,y);
	input x,y;
	output S,C;
	xor #2 (S,x,y);
	and #2 (C,x,y);
endmodule

//implementing fulladder module by using two halfadders
module fulladder (S,C,x,y,z);
	input x,y,z;
	output S,C;
	wire S1,D1,D2;
	halfadder HA1 (S1,D1,x,y), 
			  HA2 (S,D2,S1,z);
	or #2 (C,D2,D1);
endmodule

//implementing 4 bit Carry look ahead adder for using it in 16 carry look ahead adder 
module CLA_4bit(A,B,Cin,S,Cout);
    input [3:0]A, B;
    input Cin; 
    output [3:0]S;
    output Cout;
    wire [3:0]g, p, C;
    wire [0:10]wires;
		
	//implementing Gi
    and #2 (g[0], A[0], B[0]);
    and #2 (g[1], A[1], B[1]);
    and #2 (g[2], A[2], B[2]);
    and #2 (g[3], A[3], B[3]);
    
	//implementing Pi
    xor #2 (p[0], A[0], B[0]);
    xor #2 (p[1], A[1], B[1]);
    xor #2 (p[2], A[2], B[2]);
    xor #2 (p[3], A[3], B[3]);
      
	//implementing C1
    and #2 (wires[0],p[0],Cin);
    or #2  (C[0],g[0],wires[0]);
  
	//implementing C2
    and #2 (wires[2],p[1],g[0]);
    and #3 (wires[3],p[1],p[0],Cin);
    or #3  (C[1],g[1],wires[2],wires[3]);
    
	//implementing C3
    and #2 (wires[4],p[2],g[1]);
    and #3 (wires[5],p[2],p[1],g[0]);
    and #4 (wires[6],p[2],p[1],p[0],Cin);
    or #4  (C[2],g[2],wires[4],wires[5],wires[6]);
  
	//implementing C4
    and #2 (wires[7],p[3],g[2]);
    and #3 (wires[8],p[3],p[2],g[1]);
    and #4 (wires[9],p[3],p[2],p[1],g[0]);
    and #5 (wires[10],p[3],p[2],p[1],p[0],Cin);
    or #5  (C[3],g[3],wires[7],wires[8],wires[9],wires[10]);

	//implementing Si  
    xor #(2) (S[0],p[0],Cin);
    xor #(2) (S[1],p[1],C[0]);
    xor #(2) (S[2],p[2],C[1]);
    xor #(2) (S[3],p[3],C[2]);
  
    assign Cout = C[3];
     
endmodule

//implementing ripple carry adder module
module Adder1_16bit(A,B,Cin,S,Cout);
    input [15:0]A, B;
    input Cin; 
    output [15:0]S;
    output Cout;
    wire wires[15:0];
    fulladder FA1 (S[0], wires[0], A[0], B[0], Cin),
              FA2 (S[1], wires[1], A[1], B[1], wires[0]),
              FA3 (S[2], wires[2], A[2], B[2], wires[1]),
              FA4 (S[3], wires[3], A[3], B[3], wires[2]),
              FA5 (S[4], wires[4], A[4], B[4], wires[3]),
              FA6 (S[5], wires[5], A[5], B[5], wires[4]),
              FA7 (S[6], wires[6], A[6], B[6], wires[5]),
              FA8 (S[7], wires[7], A[7], B[7], wires[6]),
              FA9 (S[8], wires[8], A[8], B[8], wires[7]),
              FA10 (S[9], wires[9], A[9], B[9], wires[8]),
              FA11 (S[10], wires[10], A[10], B[10], wires[9]),
              FA12 (S[11], wires[11], A[11], B[11], wires[10]),
              FA13 (S[12], wires[12], A[12], B[12], wires[11]),
              FA14 (S[13], wires[13], A[13], B[13], wires[12]),
              FA15 (S[14], wires[14], A[14], B[14], wires[13]),
              FA16 (S[15], Cout, A[15], B[15], wires[14]);
endmodule

//implementing 16 bit carry look ahead adder module
module Adder2_16bit(A,B,Cin,S,Cout);
    input [15:0]A,B;
    input Cin;
    output [15:0]S;
    output Cout;
    wire [2:0]wires;
    CLA_4bit CLA1(A[3:0], B[3:0], Cin, S[3:0], wires[0]);
    CLA_4bit CLA2(A[7:4], B[7:4], wires[0], S[7:4], wires[1]);
    CLA_4bit CLA3(A[11:8], B[11:8], wires[1], S[11:8], wires[2]);
    CLA_4bit CLA4(A[15:12], B[15:12], wires[2], S[15:12], Cout);
endmodule

//Testbench
module Adder16_TB;
  reg [15:0]A,B;
  reg Cin;
  wire [15:0]S1,S2;
  wire Cout1,Cout2;
  Adder1_16bit adder1 (A,B,Cin,S1,Cout1);
  Adder2_16bit adder2 (A,B,Cin,S2,Cout2);  
  
  initial
    begin
        Cin = 1'b0;
          #1
        A = 16'b0; B = 16'b0;
		  #200
        A = 16'b10010011010111; B = 16'b1111110001;
          #200
        A = 16'b1111110111101000;
          #200 $finish;
    end
endmodule

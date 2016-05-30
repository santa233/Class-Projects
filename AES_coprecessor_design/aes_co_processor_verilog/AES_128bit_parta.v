module AES_128bit(
clk, 
nreset, 
start_encrypt, 
plain_addr,
cipher_addr_off, 
frame_size, 
done, 
key_0, 
key_1, 
key_2,  
key_3, 
port_A_data_out, 
port_A_data_in, 
port_A_clk, 
port_A_addr,
port_A_we
); 
input		clk, nreset, start_encrypt;

input	[31:0]	key_0, key_1, key_2, key_3;
input	[31:0]	port_A_data_out;
input	[31:0]	plain_addr;
input	[15:0]	cipher_addr_off;
input 	[7:0] 	frame_size;
output  done, port_A_we, port_A_clk;
output	[31:0]	port_A_data_in;
output	[15:0]	port_A_addr;



////////////////////////////////////////////////////////////////////
//
// Local Wires
//

reg	[31:0]	cipher_word0, cipher_word1, cipher_word2, cipher_word3;
reg	[127:0]	plain_text;
reg	[7:0]	temp00, temp01, temp02, temp03;
reg	[7:0]	temp10, temp11, temp12, temp13;
reg	[7:0]	temp20, temp21, temp22, temp23;
reg	[7:0]	temp30, temp31, temp32, temp33;

reg	[7:0]	temp00_shiftsub, temp01_shiftsub, temp02_shiftsub, temp03_shiftsub;
reg	[7:0]	temp10_shiftsub, temp11_shiftsub, temp12_shiftsub, temp13_shiftsub;
reg	[7:0]	temp20_shiftsub, temp21_shiftsub, temp22_shiftsub, temp23_shiftsub;
reg	[7:0]	temp30_shiftsub, temp31_shiftsub, temp32_shiftsub, temp33_shiftsub;
reg	[7:0]	temp00_mixcolumn, temp01_mixcolumn, temp02_mixcolumn, temp03_mixcolumn;
reg	[7:0]	temp10_mixcolumn, temp11_mixcolumn, temp12_mixcolumn, temp13_mixcolumn;
reg	[7:0]	temp20_mixcolumn, temp21_mixcolumn, temp22_mixcolumn, temp23_mixcolumn;
reg	[7:0]	temp30_mixcolumn, temp31_mixcolumn, temp32_mixcolumn, temp33_mixcolumn, sboxin;
wire [7:0] sboxout;
reg	done, port_A_we, kld;
reg	[3:0]	round_count; 
wire [3:0] another_count;
reg	[7:0]	count;
reg [4:0] an_cnt; 
reg [2:0] roundkey_count;
reg [8:0] state;
reg	[15:0]	port_A_addr;
reg	[31:0]	port_A_data_in;
reg [31:0] subword;
wire [31:0] rcon;
reg f;


///////////////////////////////////////////////////////////////////
//
//State Machine
//

assign port_A_clk = clk;
assign another_count = round_count-1;
parameter
	S0 = 8'b00000000,
	S1 = 8'b00000001, 
	S2 = 8'b00000010,
	S3 = 8'b00000100,
	S4 = 8'b00001000,
	S5 = 8'b00010000,
	S6 = 8'b00100000,
	S7 = 8'b01000000,
	S8 = 8'b10000000;
 initial begin   f = 1'b0;
 end
always @(posedge clk) begin
	if (! nreset)
	  begin
		state <= S0;
		end
	else begin
		case(state)
		S0:	begin		//judge the stage 
		  			port_A_we <= 0;
		  			done <= 0;
		  			round_count <= 4'h0;
					count <= frame_size[7:0]>>2;
					an_cnt <= 5'b10000;
						roundkey_count <= 3'b100;
		      if (start_encrypt)
		        begin
		          f=~f;
		          state <= S1;
		          
		        end
		      else
		        state <= S0;
				end
		S1:	begin		// initialize the state from dps and the key 
					port_A_we <= 0;
					case(count)
						8'b00000100:	begin	
											port_A_addr[15:0] <= plain_addr[15:0];	
											state <= S2;
									  end
						8'b00000011:    begin
											plain_text[031:000] <= port_A_data_out[31:0];
										    //port_A_addr[15:0] <= port_A_addr[15:0] + 4;
										    port_A_addr[15:0] <= (f==1'b1)?16'h0004:16'h0014;
											state <= S2;
										end							
						8'b00000010:	begin
											port_A_addr[15:0] <= (f==1'b1)?16'h0008:16'h0018;
											//port_A_addr[15:0] <= port_A_addr[15:0] + 4;
											plain_text[063:032] <= port_A_data_out[31:0];
											state <= S2;
										end				
						8'b00000001:	begin
											port_A_addr[15:0] <= (f==1'b1)?16'h000c:16'h001c;
											//port_A_addr[15:0] <= port_A_addr[15:0] + 4;
											plain_text[095:064] <= port_A_data_out[31:0];
											state <= S2;
										end	
						8'b00000000:	begin
											plain_text[127:096] <= port_A_data_out[31:0];
											state <= S3;
											round_count <= round_count + 1;
											cipher_word0 <= key_0[31:0];
											cipher_word1 <= key_1[31:0]; 
											cipher_word2 <= key_2[31:0]; 
											cipher_word3 <= key_3[31:0]; 
										end	
					endcase
				count <= count - 1;
				end
		S2: begin		// give time for writing 
						state <= S1;	
				end
		S3: begin		// Add round key for the first round 
					count <= frame_size[7:0]>>2;
						begin
							temp00 <= plain_text[007:000] ^ cipher_word0[07:00];
							temp10 <= plain_text[015:008] ^ cipher_word0[15:08];
							temp20 <= plain_text[023:016] ^ cipher_word0[23:16];
							temp30 <= plain_text[031:024] ^ cipher_word0[31:24];
							temp01 <= plain_text[039:032] ^ cipher_word1[07:00];
							temp11 <= plain_text[047:040] ^ cipher_word1[15:08];
							temp21 <= plain_text[055:048] ^ cipher_word1[23:16];
							temp31 <= plain_text[063:056] ^ cipher_word1[31:24];
							temp02 <= plain_text[071:064] ^ cipher_word2[07:00];
							temp12 <= plain_text[079:072] ^ cipher_word2[15:08];
							temp22 <= plain_text[087:080] ^ cipher_word2[23:16];
							temp32 <= plain_text[095:088] ^ cipher_word2[31:24];
							temp03 <= plain_text[103:096] ^ cipher_word3[07:00];
							temp13 <= plain_text[111:104] ^ cipher_word3[15:08];
							temp23 <= plain_text[119:112] ^ cipher_word3[23:16];
							temp33 <= plain_text[127:120] ^ cipher_word3[31:24];
							state <= S4;
						end
				end	
		S4: begin // sub & shift
		  case(an_cnt)
		    5'b10000:begin
		             sboxin <= temp00;
		             state <= S4;
		             end
		    5'b01111: 		  begin         
		             temp00_shiftsub <= sboxout;	
		             sboxin <= temp01;
		             state <= S4;
		             end
		    5'b01110:         begin 
		             temp01_shiftsub <= sboxout;
		             sboxin <= temp02;
		             state <= S4;
		             end
		    5'b01101:         begin
		             temp02_shiftsub <= sboxout;
		             sboxin <= temp03;
		             state <= S4;
		             end
		    5'b01100:         begin
		             temp03_shiftsub <= sboxout;
		             sboxin <= temp10;
		             state <= S4;
		             end
		    5'b01011:         begin
		             temp13_shiftsub <= sboxout;
		             sboxin <= temp11;
		             state <= S4;
		             end
		    5'b01010:         begin
		             temp10_shiftsub <= sboxout;
		             sboxin <= temp12;
		             state <= S4;
		             end
		    5'b01001:         begin
		             temp11_shiftsub <= sboxout;
		             sboxin <= temp13;
		             state <= S4;
		             end
		    5'b01000:         begin
		             temp12_shiftsub <= sboxout;
		             sboxin <= temp20;
		             state <= S4;
		             end
		    5'b00111:        begin
		             temp22_shiftsub <= sboxout;
		             sboxin <= temp21;
		             state <= S4;
		             end
		    5'b00110:        begin
		             temp23_shiftsub <= sboxout;
		             sboxin <= temp22;
		             state <= S4;
		             end
		    5'b00101:        begin
		             temp20_shiftsub <= sboxout;
		             sboxin <= temp23;
		             state <= S4;
		             end
		    5'b00100:        begin
		             temp21_shiftsub <= sboxout;
		             sboxin <= temp30;
		             state <= S4;
		             end
		    5'b00011:        begin
		             temp31_shiftsub <= sboxout;	
		             sboxin <= temp31;
		             state <= S4;
		             end
		    5'b00010:        begin
		             temp32_shiftsub <= sboxout;
		             sboxin <= temp32;
		             state <= S4;
		             end
		    5'b00001:        begin
		             temp33_shiftsub <= sboxout;
		             sboxin <= temp33;
		             state <= S4;
		             end
		    5'b00000:begin
		             temp30_shiftsub <= sboxout;
		               if (round_count == 10)
		                 begin
						 round_count <= round_count + 1;
		                 state <= S6; // generate round key
		                 sboxin <= cipher_word3[07:00];
		                 end
		               else
		                 state <= S5; // mix
		             end
		    endcase
		    an_cnt <= an_cnt -1;
		    end 
		
		S5: begin							// Mix_Column
					round_count <= round_count+1;	
					{temp00_mixcolumn, temp10_mixcolumn, temp20_mixcolumn, temp30_mixcolumn}  <= mix_col(temp00_shiftsub,temp10_shiftsub,temp20_shiftsub,temp30_shiftsub);
					{temp01_mixcolumn, temp11_mixcolumn, temp21_mixcolumn, temp31_mixcolumn}  <= mix_col(temp01_shiftsub,temp11_shiftsub,temp21_shiftsub,temp31_shiftsub);
					{temp02_mixcolumn, temp12_mixcolumn, temp22_mixcolumn, temp32_mixcolumn}  <= mix_col(temp02_shiftsub,temp12_shiftsub,temp22_shiftsub,temp32_shiftsub);
					{temp03_mixcolumn, temp13_mixcolumn, temp23_mixcolumn, temp33_mixcolumn}  <= mix_col(temp03_shiftsub,temp13_shiftsub,temp23_shiftsub,temp33_shiftsub);
					sboxin <= cipher_word3[07:00];
					state <= S6;
				end
				
		S6: begin  // generating round key
			case(roundkey_count)
		      3'b100: begin
		            subword[31:24] <= sboxout;
		            sboxin <= cipher_word3[31:24];
					roundkey_count <= 3'b011;
		            state <= S6;
		            end
		      3'b011:
		            begin
		            subword[23:16] <= sboxout;
					sboxin <= cipher_word3[23:16];
					roundkey_count <= 3'b010;
		            state <= S6;
		            end
		      3'b010:  begin
		            subword[15:08] <= sboxout;
		            sboxin <= cipher_word3[15:08];
					roundkey_count <= 3'b001;
		            state <= S6;
		            end
		      3'b001:   begin
		            subword[07:00] <= sboxout;
		            sboxin <= cipher_word3[07:00];
					roundkey_count <= 3'b000;
		            state <= S6;
		            end
			  3'b000:
			        begin
					//round_count <= round_count + 1;
			        	cipher_word0 <=  cipher_word0^subword^rcon;
					cipher_word1 <=  cipher_word0^cipher_word1^subword^rcon;
					cipher_word2 <=  cipher_word0^cipher_word2^cipher_word1^subword^rcon;
					cipher_word3 <=  cipher_word0^cipher_word3^cipher_word2^cipher_word1^subword^rcon;
					roundkey_count <= 3'b100;
					state <= S7;
					end
				endcase
				end

		S7: begin							// Add round key
					if (round_count == 11)
						begin
						temp00 <=  temp00_shiftsub ^ cipher_word0[07:00];
						temp01 <=  temp01_shiftsub ^ cipher_word1[07:00];
						temp02 <=  temp02_shiftsub ^ cipher_word2[07:00];
						temp03 <=  temp03_shiftsub ^ cipher_word3[07:00];
						temp10 <=  temp10_shiftsub ^ cipher_word0[15:08];
						temp11 <=  temp11_shiftsub ^ cipher_word1[15:08];
						temp12 <=  temp12_shiftsub ^ cipher_word2[15:08];
						temp13 <=  temp13_shiftsub ^ cipher_word3[15:08];
						temp20 <=  temp20_shiftsub ^ cipher_word0[23:16];
						temp21 <=  temp21_shiftsub ^ cipher_word1[23:16];
						temp22 <=  temp22_shiftsub ^ cipher_word2[23:16];
						temp23 <=  temp23_shiftsub ^ cipher_word3[23:16];
						temp30 <=  temp30_shiftsub ^ cipher_word0[31:24];
						temp31 <=  temp31_shiftsub ^ cipher_word1[31:24];
						temp32 <=  temp32_shiftsub ^ cipher_word2[31:24];
						temp33 <=  temp33_shiftsub ^ cipher_word3[31:24];
						state <= S8;
						end
					else
						begin
						temp33 <= temp33_mixcolumn ^ cipher_word3[31:24];
						temp23 <= temp23_mixcolumn ^ cipher_word3[23:16];
						temp13 <= temp13_mixcolumn ^ cipher_word3[15:08];
						temp03 <= temp03_mixcolumn ^ cipher_word3[07:00];
						temp32 <= temp32_mixcolumn ^ cipher_word2[31:24];
						temp22 <= temp22_mixcolumn ^ cipher_word2[23:16];
						temp12 <= temp12_mixcolumn ^ cipher_word2[15:08];
						temp02 <= temp02_mixcolumn ^ cipher_word2[07:00];
						temp31 <= temp31_mixcolumn ^ cipher_word1[31:24];
						temp21 <= temp21_mixcolumn ^ cipher_word1[23:16];
						temp11 <= temp11_mixcolumn ^ cipher_word1[15:08];
						temp01 <= temp01_mixcolumn ^ cipher_word1[07:00];
						temp30 <= temp30_mixcolumn ^ cipher_word0[31:24];
						temp20 <= temp20_mixcolumn ^ cipher_word0[23:16];
						temp10 <= temp10_mixcolumn ^ cipher_word0[15:08];
						temp00 <= temp00_mixcolumn ^ cipher_word0[07:00];
						state <= S4;
						end
				end 		
		S8: begin
					port_A_we <= 1;					
					case(count)
						8'b100:	begin	
											port_A_addr[15:0] <= cipher_addr_off[15:0] + plain_addr[15:0];
											port_A_data_in[31:0] <= {temp30,temp20,temp10,temp00};												
											state <= S8;
										end							
						8'b11:	begin 
											port_A_addr[15:0] <= (f==1'b1)?16'h00cc:16'h0100;
											//port_A_addr[15:0] <= port_A_addr[15:0] + 4;
											port_A_data_in[31:0] <= {temp31,temp21,temp11,temp01};		
											state <= S8;
										end				
						8'b10:	begin
											port_A_addr[15:0] <= (f==1'b1)?16'h00d0:16'h0104;
											//port_A_addr[15:0] <= port_A_addr[15:0] + 4;
											port_A_data_in[31:0] <= {temp32,temp22,temp12,temp02};		
											state <= S8;
										end	
						8'b01:	begin
											port_A_addr[15:0] <= (f==1'b1)?16'h00d4:16'h0108;
											//port_A_addr[15:0] <= port_A_addr[15:0] + 4;
											port_A_data_in[31:0] <= {temp33,temp23,temp13,temp03};		
											done <= 1;
											state <= S0;
										end	
					endcase
					count <= count - 1;
				end
			endcase
	end
end

				
aes_sbox us ( .a(sboxin), .d(sboxout));
aes_rcon r0(	.clk(another_count), .out(rcon));

////////////////////////////////////////////////////////////////////
//
// Generic Functions
//

function [31:0] mix_col;
input	[7:0]	s0,s1,s2,s3;
reg	[7:0]	s0_o,s1_o,s2_o,s3_o;
begin
mix_col[31:24]=field(s0)^field(s1)^s1^s2^s3;
mix_col[23:16]=s0^field(s1)^field(s2)^s2^s3;
mix_col[15:08]=s0^s1^field(s2)^field(s3)^s3;
mix_col[07:00]=field(s0)^s0^s1^s2^field(s3);
end
endfunction 
 

function [7:0] field;
input [7:0] b; 
field={b[6:0],1'b0}^(8'h1b&{8{b[7]}});
endfunction

endmodule




module aes_rcon(clk, out);
input		[3:0] clk;
output	[31:0]	out;
reg	[31:0]	out;
reg	[3:0]	rcon_count;
wire	[3:0]	rcon_count_next;

always @(clk)
	if(clk == 1)		out <= 32'h00_00_00_01;
	else		out <=  frcon(rcon_count_next);

assign rcon_count_next = rcon_count + 4'h1;
always @(clk)
	if(clk == 1)		rcon_count <= 4'h0;
	else		rcon_count <=  rcon_count_next;

function [31:0]	frcon;
input	[3:0]	i;
case(i)	// synopsys parallel_case
   4'h0: frcon=32'h00_00_00_01;
   4'h1: frcon=32'h00_00_00_02;
   4'h2: frcon=32'h00_00_00_04;
   4'h3: frcon=32'h00_00_00_08;
   4'h4: frcon=32'h00_00_00_10;
   4'h5: frcon=32'h00_00_00_20;
   4'h6: frcon=32'h00_00_00_40;
   4'h7: frcon=32'h00_00_00_80;
   4'h8: frcon=32'h00_00_00_1b;
   4'h9: frcon=32'h00_00_00_36;
   default: frcon=32'h00_00_00_00;
endcase
endfunction
endmodule



module aes_sbox(a,d);
input	[7:0]	a;
output	[7:0]	d;
reg	[7:0]	d;

always @(a)
	case(a)		// synopsys full_case parallel_case
	   8'h00: d=8'h63;
	   8'h01: d=8'h7c;
	   8'h02: d=8'h77;
	   8'h03: d=8'h7b;
	   8'h04: d=8'hf2;
	   8'h05: d=8'h6b;
	   8'h06: d=8'h6f;
	   8'h07: d=8'hc5;
	   8'h08: d=8'h30;
	   8'h09: d=8'h01;
	   8'h0a: d=8'h67;
	   8'h0b: d=8'h2b;
	   8'h0c: d=8'hfe;
	   8'h0d: d=8'hd7;
	   8'h0e: d=8'hab;
	   8'h0f: d=8'h76;
	   8'h10: d=8'hca;
	   8'h11: d=8'h82;
	   8'h12: d=8'hc9;
	   8'h13: d=8'h7d;
	   8'h14: d=8'hfa;
	   8'h15: d=8'h59;
	   8'h16: d=8'h47;
	   8'h17: d=8'hf0;
	   8'h18: d=8'had;
	   8'h19: d=8'hd4;
	   8'h1a: d=8'ha2;
	   8'h1b: d=8'haf;
	   8'h1c: d=8'h9c;
	   8'h1d: d=8'ha4;
	   8'h1e: d=8'h72;
	   8'h1f: d=8'hc0;
	   8'h20: d=8'hb7;
	   8'h21: d=8'hfd;
	   8'h22: d=8'h93;
	   8'h23: d=8'h26;
	   8'h24: d=8'h36;
	   8'h25: d=8'h3f;
	   8'h26: d=8'hf7;
	   8'h27: d=8'hcc;
	   8'h28: d=8'h34;
	   8'h29: d=8'ha5;
	   8'h2a: d=8'he5;
	   8'h2b: d=8'hf1;
	   8'h2c: d=8'h71;
	   8'h2d: d=8'hd8;
	   8'h2e: d=8'h31;
	   8'h2f: d=8'h15;
	   8'h30: d=8'h04;
	   8'h31: d=8'hc7;
	   8'h32: d=8'h23;
	   8'h33: d=8'hc3;
	   8'h34: d=8'h18;
	   8'h35: d=8'h96;
	   8'h36: d=8'h05;
	   8'h37: d=8'h9a;
	   8'h38: d=8'h07;
	   8'h39: d=8'h12;
	   8'h3a: d=8'h80;
	   8'h3b: d=8'he2;
	   8'h3c: d=8'heb;
	   8'h3d: d=8'h27;
	   8'h3e: d=8'hb2;
	   8'h3f: d=8'h75;
	   8'h40: d=8'h09;
	   8'h41: d=8'h83;
	   8'h42: d=8'h2c;
	   8'h43: d=8'h1a;
	   8'h44: d=8'h1b;
	   8'h45: d=8'h6e;
	   8'h46: d=8'h5a;
	   8'h47: d=8'ha0;
	   8'h48: d=8'h52;
	   8'h49: d=8'h3b;
	   8'h4a: d=8'hd6;
	   8'h4b: d=8'hb3;
	   8'h4c: d=8'h29;
	   8'h4d: d=8'he3;
	   8'h4e: d=8'h2f;
	   8'h4f: d=8'h84;
	   8'h50: d=8'h53;
	   8'h51: d=8'hd1;
	   8'h52: d=8'h00;
	   8'h53: d=8'hed;
	   8'h54: d=8'h20;
	   8'h55: d=8'hfc;
	   8'h56: d=8'hb1;
	   8'h57: d=8'h5b;
	   8'h58: d=8'h6a;
	   8'h59: d=8'hcb;
	   8'h5a: d=8'hbe;
	   8'h5b: d=8'h39;
	   8'h5c: d=8'h4a;
	   8'h5d: d=8'h4c;
	   8'h5e: d=8'h58;
	   8'h5f: d=8'hcf;
	   8'h60: d=8'hd0;
	   8'h61: d=8'hef;
	   8'h62: d=8'haa;
	   8'h63: d=8'hfb;
	   8'h64: d=8'h43;
	   8'h65: d=8'h4d;
	   8'h66: d=8'h33;
	   8'h67: d=8'h85;
	   8'h68: d=8'h45;
	   8'h69: d=8'hf9;
	   8'h6a: d=8'h02;
	   8'h6b: d=8'h7f;
	   8'h6c: d=8'h50;
	   8'h6d: d=8'h3c;
	   8'h6e: d=8'h9f;
	   8'h6f: d=8'ha8;
	   8'h70: d=8'h51;
	   8'h71: d=8'ha3;
	   8'h72: d=8'h40;
	   8'h73: d=8'h8f;
	   8'h74: d=8'h92;
	   8'h75: d=8'h9d;
	   8'h76: d=8'h38;
	   8'h77: d=8'hf5;
	   8'h78: d=8'hbc;
	   8'h79: d=8'hb6;
	   8'h7a: d=8'hda;
	   8'h7b: d=8'h21;
	   8'h7c: d=8'h10;
	   8'h7d: d=8'hff;
	   8'h7e: d=8'hf3;
	   8'h7f: d=8'hd2;
	   8'h80: d=8'hcd;
	   8'h81: d=8'h0c;
	   8'h82: d=8'h13;
	   8'h83: d=8'hec;
	   8'h84: d=8'h5f;
	   8'h85: d=8'h97;
	   8'h86: d=8'h44;
	   8'h87: d=8'h17;
	   8'h88: d=8'hc4;
	   8'h89: d=8'ha7;
	   8'h8a: d=8'h7e;
	   8'h8b: d=8'h3d;
	   8'h8c: d=8'h64;
	   8'h8d: d=8'h5d;
	   8'h8e: d=8'h19;
	   8'h8f: d=8'h73;
	   8'h90: d=8'h60;
	   8'h91: d=8'h81;
	   8'h92: d=8'h4f;
	   8'h93: d=8'hdc;
	   8'h94: d=8'h22;
	   8'h95: d=8'h2a;
	   8'h96: d=8'h90;
	   8'h97: d=8'h88;
	   8'h98: d=8'h46;
	   8'h99: d=8'hee;
	   8'h9a: d=8'hb8;
	   8'h9b: d=8'h14;
	   8'h9c: d=8'hde;
	   8'h9d: d=8'h5e;
	   8'h9e: d=8'h0b;
	   8'h9f: d=8'hdb;
	   8'ha0: d=8'he0;
	   8'ha1: d=8'h32;
	   8'ha2: d=8'h3a;
	   8'ha3: d=8'h0a;
	   8'ha4: d=8'h49;
	   8'ha5: d=8'h06;
	   8'ha6: d=8'h24;
	   8'ha7: d=8'h5c;
	   8'ha8: d=8'hc2;
	   8'ha9: d=8'hd3;
	   8'haa: d=8'hac;
	   8'hab: d=8'h62;
	   8'hac: d=8'h91;
	   8'had: d=8'h95;
	   8'hae: d=8'he4;
	   8'haf: d=8'h79;
	   8'hb0: d=8'he7;
	   8'hb1: d=8'hc8;
	   8'hb2: d=8'h37;
	   8'hb3: d=8'h6d;
	   8'hb4: d=8'h8d;
	   8'hb5: d=8'hd5;
	   8'hb6: d=8'h4e;
	   8'hb7: d=8'ha9;
	   8'hb8: d=8'h6c;
	   8'hb9: d=8'h56;
	   8'hba: d=8'hf4;
	   8'hbb: d=8'hea;
	   8'hbc: d=8'h65;
	   8'hbd: d=8'h7a;
	   8'hbe: d=8'hae;
	   8'hbf: d=8'h08;
	   8'hc0: d=8'hba;
	   8'hc1: d=8'h78;
	   8'hc2: d=8'h25;
	   8'hc3: d=8'h2e;
	   8'hc4: d=8'h1c;
	   8'hc5: d=8'ha6;
	   8'hc6: d=8'hb4;
	   8'hc7: d=8'hc6;
	   8'hc8: d=8'he8;
	   8'hc9: d=8'hdd;
	   8'hca: d=8'h74;
	   8'hcb: d=8'h1f;
	   8'hcc: d=8'h4b;
	   8'hcd: d=8'hbd;
	   8'hce: d=8'h8b;
	   8'hcf: d=8'h8a;
	   8'hd0: d=8'h70;
	   8'hd1: d=8'h3e;
	   8'hd2: d=8'hb5;
	   8'hd3: d=8'h66;
	   8'hd4: d=8'h48;
	   8'hd5: d=8'h03;
	   8'hd6: d=8'hf6;
	   8'hd7: d=8'h0e;
	   8'hd8: d=8'h61;
	   8'hd9: d=8'h35;
	   8'hda: d=8'h57;
	   8'hdb: d=8'hb9;
	   8'hdc: d=8'h86;
	   8'hdd: d=8'hc1;
	   8'hde: d=8'h1d;
	   8'hdf: d=8'h9e;
	   8'he0: d=8'he1;
	   8'he1: d=8'hf8;
	   8'he2: d=8'h98;
	   8'he3: d=8'h11;
	   8'he4: d=8'h69;
	   8'he5: d=8'hd9;
	   8'he6: d=8'h8e;
	   8'he7: d=8'h94;
	   8'he8: d=8'h9b;
	   8'he9: d=8'h1e;
	   8'hea: d=8'h87;
	   8'heb: d=8'he9;
	   8'hec: d=8'hce;
	   8'hed: d=8'h55;
	   8'hee: d=8'h28;
	   8'hef: d=8'hdf;
	   8'hf0: d=8'h8c;
	   8'hf1: d=8'ha1;
	   8'hf2: d=8'h89;
	   8'hf3: d=8'h0d;
	   8'hf4: d=8'hbf;
	   8'hf5: d=8'he6;
	   8'hf6: d=8'h42;
	   8'hf7: d=8'h68;
	   8'hf8: d=8'h41;
	   8'hf9: d=8'h99;
	   8'hfa: d=8'h2d;
	   8'hfb: d=8'h0f;
	   8'hfc: d=8'hb0;
	   8'hfd: d=8'h54;
	   8'hfe: d=8'hbb;
	   8'hff: d=8'h16;
	endcase

endmodule

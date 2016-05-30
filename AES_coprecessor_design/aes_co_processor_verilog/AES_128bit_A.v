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
output 		done, port_A_we, port_A_clk;
output	[31:0]	port_A_data_in;
output	[15:0]	port_A_addr;



////////////////////////////////////////////////////////////////////
//
// Local Wires
//

reg	[31:0]	w0, w1, w2, w3;
reg	[127:0]	text_in_r;
reg	[7:0]	sa00, sa01, sa02, sa03;
reg	[7:0]	sa10, sa11, sa12, sa13;
reg	[7:0]	sa20, sa21, sa22, sa23;
reg	[7:0]	sa30, sa31, sa32, sa33;

reg	[7:0]	sa00_sr, sa01_sr, sa02_sr, sa03_sr;
reg	[7:0]	sa10_sr, sa11_sr, sa12_sr, sa13_sr;
reg	[7:0]	sa20_sr, sa21_sr, sa22_sr, sa23_sr;
reg	[7:0]	sa30_sr, sa31_sr, sa32_sr, sa33_sr;
reg	[7:0]	sa00_mc, sa01_mc, sa02_mc, sa03_mc;
reg	[7:0]	sa10_mc, sa11_mc, sa12_mc, sa13_mc;
reg	[7:0]	sa20_mc, sa21_mc, sa22_mc, sa23_mc;
reg	[7:0]	sa30_mc, sa31_mc, sa32_mc, sa33_mc, sin;
wire [7:0] sout;
reg					done, port_A_we, kld;
reg		[3:0]	rdcnt; 
wire [3:0] concnt;
reg		[7:0]	ldcnt;
reg  [4:0] cnt; 
reg [2:0] kcnt;
reg   [8:0] state;
reg	[15:0]	port_A_addr;
reg	[31:0]	port_A_data_in;
reg [31:0] subword;
wire [31:0] rcon;


///////////////////////////////////////////////////////////////////
//
//State Machine
//

assign port_A_clk = clk;
assign concnt = rdcnt-1;
parameter
	S0 = 7'b0000000,
	S1 = 7'b0000001, 
	S2 = 7'b0000010,
	S3 = 7'b0000100,
	S4 = 7'b0001000,
	S5 = 7'b0010000,
	S6 = 7'b0100000,
	S7 = 7'b1000000,
	S8 = 8'b10000000;
always @(posedge clk) begin
	if (! nreset)
	  begin
		state <= S0;
		end
	else begin
		case(state)
		S0:	begin		//judge the stage 
		  			rdcnt <= 4'h0;
					ldcnt <= frame_size[7:0]>>2;
					cnt <= 5'b10000;
						kcnt <= 3'b100;
		      if (start_encrypt)
		        begin
		          state <= S1;
		          done <= 0;
		        end
		      else
		        state <= S0;
				end
		S1:	begin		// initialize the state from dps and the key 
					port_A_we <= 0;
					case(ldcnt)
						8'b100:	begin	
											port_A_addr[15:0] <= plain_addr[15:0];	
											state <= S2;
									  end
						8'b11:  begin
											text_in_r[031:000] <= port_A_data_out[31:0];
										  port_A_addr[15:0] <= port_A_addr[15:0] + 4;
											state <= S2;
										end							
						8'b10:	begin
											port_A_addr[15:0] <= port_A_addr[15:0] + 4;
											text_in_r[063:032] <= port_A_data_out[31:0];
											state <= S2;
										end				
						8'b01:	begin
											port_A_addr[15:0] <= port_A_addr[15:0] + 4;
											text_in_r[095:064] <= port_A_data_out[31:0];
											state <= S2;
										end	
						8'b0:	begin
											text_in_r[127:096] <= port_A_data_out[31:0];
											state <= S3;
											rdcnt <= rdcnt + 1;
											w0 <= key_0[31:0];
											w1 <= key_1[31:0]; 
											w2 <= key_2[31:0]; 
											w3 <= key_3[31:0]; 
										end	
					endcase
				ldcnt <= ldcnt - 1;
				end
		S2: begin		// give time for writing 
						state <= S1;	
				end
		S3: begin		// Add round key for the first round 
					ldcnt <= frame_size[7:0]>>2;
						begin
							sa00 <= text_in_r[007:000] ^ w0[07:00];
							sa10 <= text_in_r[015:008] ^ w0[15:08];
							sa20 <= text_in_r[023:016] ^ w0[23:16];
							sa30 <= text_in_r[031:024] ^ w0[31:24];
							sa01 <= text_in_r[039:032] ^ w1[07:00];
							sa11 <= text_in_r[047:040] ^ w1[15:08];
							sa21 <= text_in_r[055:048] ^ w1[23:16];
							sa31 <= text_in_r[063:056] ^ w1[31:24];
							sa02 <= text_in_r[071:064] ^ w2[07:00];
							sa12 <= text_in_r[079:072] ^ w2[15:08];
							sa22 <= text_in_r[087:080] ^ w2[23:16];
							sa32 <= text_in_r[095:088] ^ w2[31:24];
							sa03 <= text_in_r[103:096] ^ w3[07:00];
							sa13 <= text_in_r[111:104] ^ w3[15:08];
							sa23 <= text_in_r[119:112] ^ w3[23:16];
							sa33 <= text_in_r[127:120] ^ w3[31:24];
							state <= S4;
						end
				end	
		S4: begin // sub & shift
		  case(cnt)
		    5'b10000:begin
		             sin <= sa00;
		             state <= S4;
		             end
		    5'b1111: begin         
		             sa00_sr <= sout;	
		             sin <= sa01;
		             state <= S4;
		             end
		    5'b1110:         begin 
		             sa01_sr <= sout;
		             sin <= sa02;
		             state <= S4;
		             end
		    5'b1101:         begin
		             sa02_sr <= sout;
		             sin <= sa03;
		             state <= S4;
		             end
		    5'b1100:         begin
		             sa03_sr <= sout;
		             sin <= sa10;
		             state <= S4;
		             end
		    5'b1011:         begin
		             sa13_sr <= sout;
		             sin <= sa11;
		             state <= S4;
		             end
		    5'b1010:        begin
		             sa10_sr <= sout;
		             sin <= sa12;
		             state <= S4;
		             end
		    5'b1001:         begin
		             sa11_sr <= sout;
		             sin <= sa13;
		             state <= S4;
		             end
		    5'b1000:         begin
		             sa12_sr <= sout;
		             sin <= sa20;
		             state <= S4;
		             end
		    5'b0111:         begin
		             sa22_sr <= sout;
		             sin <= sa21;
		             state <= S4;
		             end
		    5'b0110:         begin
		             sa23_sr <= sout;
		             sin <= sa22;
		             state <= S4;
		             end
		    5'b0101:        begin
		             sa20_sr <= sout;
		             sin <= sa23;
		             state <= S4;
		             end
		    5'b100:        begin
		             sa21_sr <= sout;
		             sin <= sa30;
		             state <= S4;
		             end
		    5'b11:        begin
		             sa31_sr <= sout;	
		             sin <= sa31;
		             state <= S4;
		             end
		    5'b10:        begin
		             sa32_sr <= sout;
		             sin <= sa32;
		             state <= S4;
		             end
		    5'b00001:        begin
		             sa33_sr <= sout;
		             sin <= sa33;
		             state <= S4;
		             end
		    5'b00000:begin
		             sa30_sr <= sout;
		               if (rdcnt == 10)
		                 begin
						 rdcnt <= rdcnt + 1;
		                 state <= S6; // generate round key
		                 sin <= w3[07:00];
		                 end
		               else
		                 state <= S5; // mix
		             end
		    endcase
		    cnt <= cnt -1;
		    end 
		
		S5: begin							// Mix_Column
					rdcnt <= rdcnt+1;	
					{sa00_mc, sa10_mc, sa20_mc, sa30_mc}  <= mix_col(sa00_sr,sa10_sr,sa20_sr,sa30_sr);
					{sa01_mc, sa11_mc, sa21_mc, sa31_mc}  <= mix_col(sa01_sr,sa11_sr,sa21_sr,sa31_sr);
					{sa02_mc, sa12_mc, sa22_mc, sa32_mc}  <= mix_col(sa02_sr,sa12_sr,sa22_sr,sa32_sr);
					{sa03_mc, sa13_mc, sa23_mc, sa33_mc}  <= mix_col(sa03_sr,sa13_sr,sa23_sr,sa33_sr);
					sin <= w3[07:00];
					state <= S6;
				end
				
		S6: begin  // generating round key
			case(kcnt)
		      3'b100: begin
		            subword[31:24] <= sout;
		            sin <= w3[31:24];
					kcnt <= 3'b011;
		            state <= S6;
		            end
		      3'b011:
		            begin
		            subword[23:16] <= sout;
					sin <= w3[23:16];
					kcnt <= 3'b010;
		            state <= S6;
		            end
		      3'b010:  begin
		            subword[15:08] <= sout;
		            sin <= w3[15:08];
					kcnt <= 3'b001;
		            state <= S6;
		            end
		      3'b001:   begin
		            subword[07:00] <= sout;
		            sin <= w3[07:00];
					kcnt <= 3'b000;
		            state <= S6;
		            end
			  3'b000:
			        begin
					//rdcnt <= rdcnt + 1;
			        w0 <=  w0^subword^rcon;
					w1 <=  w0^w1^subword^rcon;
					w2 <=  w0^w2^w1^subword^rcon;
					w3 <=  w0^w3^w2^w1^subword^rcon;
					kcnt <= 3'b100;
					state <= S7;
					end
				endcase
				end

		S7: begin							// Add round key
					if (rdcnt == 11)
						begin
						sa00 <=  sa00_sr ^ w0[07:00];
						sa01 <=  sa01_sr ^ w1[07:00];
						sa02 <=  sa02_sr ^ w2[07:00];
						sa03 <=  sa03_sr ^ w3[07:00];
						sa10 <=  sa10_sr ^ w0[15:08];
						sa11 <=  sa11_sr ^ w1[15:08];
						sa12 <=  sa12_sr ^ w2[15:08];
						sa13 <=  sa13_sr ^ w3[15:08];
						sa20 <=  sa20_sr ^ w0[23:16];
						sa21 <=  sa21_sr ^ w1[23:16];
						sa22 <=  sa22_sr ^ w2[23:16];
						sa23 <=  sa23_sr ^ w3[23:16];
						sa30 <=  sa30_sr ^ w0[31:24];
						sa31 <=  sa31_sr ^ w1[31:24];
						sa32 <=  sa32_sr ^ w2[31:24];
						sa33 <=  sa33_sr ^ w3[31:24];
						state <= S8;
						end
					else
						begin
						sa33 <= sa33_mc ^ w3[31:24];
						sa23 <= sa23_mc ^ w3[23:16];
						sa13 <= sa13_mc ^ w3[15:08];
						sa03 <= sa03_mc ^ w3[07:00];
						sa32 <= sa32_mc ^ w2[31:24];
						sa22 <= sa22_mc ^ w2[23:16];
						sa12 <= sa12_mc ^ w2[15:08];
						sa02 <= sa02_mc ^ w2[07:00];
						sa31 <= sa31_mc ^ w1[31:24];
						sa21 <= sa21_mc ^ w1[23:16];
						sa11 <= sa11_mc ^ w1[15:08];
						sa01 <= sa01_mc ^ w1[07:00];
						sa30 <= sa30_mc ^ w0[31:24];
						sa20 <= sa20_mc ^ w0[23:16];
						sa10 <= sa10_mc ^ w0[15:08];
						sa00 <= sa00_mc ^ w0[07:00];
						state <= S4;
						end
				end 		
		S8: begin
					port_A_we <= 1;					
					case(ldcnt)
						8'b100:	begin	
											port_A_addr[15:0] <= cipher_addr_off[15:0] + plain_addr[15:0];
											port_A_data_in[31:0] <= {sa30,sa20,sa10,sa00};												
											state <= S8;
										end							
						8'b11:	begin 
											port_A_addr[15:0] <= port_A_addr[15:0] + 4;
											port_A_data_in[31:0] <= {sa31,sa21,sa11,sa01};		
											state <= S8;
										end				
						8'b10:	begin
											port_A_addr[15:0] <= port_A_addr[15:0] + 4;
											port_A_data_in[31:0] <= {sa32,sa22,sa12,sa02};		
											state <= S8;
										end	
						8'b01:	begin
											port_A_addr[15:0] <= port_A_addr[15:0] + 4;
											port_A_data_in[31:0] <= {sa33,sa23,sa13,sa03};		
											done <= 1;
											state <= S0;
										end	
					endcase
					ldcnt <= ldcnt - 1;
				end
			endcase
	end
end

				
aes_sbox us ( .a(sin), .d(sout));
aes_rcon r0(	.clk(concnt), .out(rcon));

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
reg	[3:0]	rcnt;
wire	[3:0]	rcnt_next;

always @(clk)
	if(clk == 1)		out <= 32'h00_00_00_01;
	else		out <=  frcon(rcnt_next);

assign rcnt_next = rcnt + 4'h1;
always @(clk)
	if(clk == 1)		rcnt <= 4'h0;
	else		rcnt <=  rcnt_next;

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



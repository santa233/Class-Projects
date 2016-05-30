module AES_128bit(
clk,
nreset,
start_encrypt,
plain_addr,
cipher_addr_off,
frame_size,
key_3,
key_2,
key_1,
key_0,
port_A_clk,
port_A_data_in,
port_A_data_out,
port_A_addr,
port_A_we,
done
);

input clk;
input nreset;
// Initializes the AES_128bit module

input start_encrypt;
// Tells AES_128bit to start encrypting the given frame

input [31:0] plain_addr;
// Starting address of the plaintext frame
// i.e., specifies from where AES_128bit must read the plaintext frame

input [15:0] cipher_addr_off;
// Offset added to starting address of plaintext frame to obtain starting address of cipher text

input [7:0] frame_size;
// Length of the frame in bytes

input [31:0] key_0;
// Contains the least significant word of the 4 word (128 bit) key

input [31:0] key_1;
// Contains the second word of the 4 word (128 bit) key

input [31:0] key_2;
// Contains the third word of the 4 word (128 bit) key

input [31:0] key_3;
// Contains the most significant word of the 4 word (128 bit) key

input [31:0] port_A_data_out;
// read data from the dpsram (plaintext)

output [31:0] port_A_data_in;
// write data to the dpsram (ciphertext)

output [15:0] port_A_addr;
// address of dpsram being read/written 

output port_A_clk;
// clock to dpsram (drive this with the input clk) 

output port_A_we;
// read/write selector for dpsram

output done;
// done is a signal to indicate that encryption of the frame is complete

assign port_A_clk=clk;

reg done;
reg port_A_we;
//reg plain_addr;

reg [15:0] port_A_addr;
reg [31:0] port_A_data_in;

//assign port_A_addr=port_A_addr_r;
//assign port_A_data_in=port_A_data_in_r;
//assign port_A_we=port_A_we;
//assign done=done_r;
//reg [15:0] cipher_addr_off;
reg [7:0] pt_trans00;
reg [7:0] pt_trans01;
reg [7:0] pt_trans02;
reg [7:0] pt_trans03;
reg [7:0] pt_trans10;
reg [7:0] pt_trans11;
reg [7:0] pt_trans12;
reg [7:0] pt_trans13;
reg [7:0] pt_trans20;
reg [7:0] pt_trans21;
reg [7:0] pt_trans22;
reg [7:0] pt_trans23;
reg [7:0] pt_trans30;
reg [7:0] pt_trans31;
reg [7:0] pt_trans32;
reg [7:0] pt_trans33;

reg [7:0] pt_trans0;
reg [7:0] pt_trans1;
reg [7:0] pt_trans2;
reg [7:0] pt_trans3;




reg [7:0] rcon[9:0];


reg f;
reg [7:0] ct00;
reg [7:0] ct01;
reg [7:0] ct02;
reg [7:0] ct03;
reg [7:0] ct10;
reg [7:0] ct11;
reg [7:0] ct12;
reg [7:0] ct13;
reg [7:0] ct20;
reg [7:0] ct21;
reg [7:0] ct22;
reg [7:0] ct23;
reg [7:0] ct30;
reg [7:0] ct31;
reg [7:0] ct32;
reg [7:0] ct33;
reg [7:0] entries[15:0][15:0];
reg [3:0] cnt_rk;
//reg [7:0] tt;
reg [7:0] tt0;
reg [7:0] tt1;
reg [7:0] tt2;
reg [7:0] tt3;
reg [7:0] temp00;
reg [7:0] temp01;
reg [7:0] temp02;
reg [7:0] temp03;
reg [7:0] temp10;
reg [7:0] temp11;
reg [7:0] temp12;
reg [7:0] temp13;
reg [7:0] temp20;
reg [7:0] temp21;
reg [7:0] temp22;
reg [7:0] temp23;
reg [7:0] temp30;
reg [7:0] temp31;
reg [7:0] temp32;
reg [7:0] temp33;
//reg [31:0] plain_addr;

//reg done,port_A_we;
reg [1:0] status;
reg [31:0] w0,w1,w2,w3,text_in_r;
reg [7:0] ldcnt;
reg [1:0] check;
reg no;
//reg done_r;
wire p;

//assign port_A_addr=(n0==1'b0)?((state_1==1)?16'h0000:((state_1==2)?16'h0004:((state_1==3)?16'h0008:16'h000c))):((state_1==1)?16'h0010:((state_1==2)?16'h0014:((state_1==3)?16'h0018:16'h001c))); 
//assign port_A_addr=port_A_addr_r;   
//assign port_A_addr=(state_1==2)?16'h0004:16'h;    //
//assign port_A_addr=(state_1==3)?16'h0008:16'h0018;    //
//assign port_A_addr=(state_1==4)?16'h000c:16'h001c;    // 
//assign port_A_addr=(status==2'b00)?port_A_addr_r:8'hff;

assign p=(cnt_rk==0|cnt_rk==10)?1'b1:1'b0;
//(state_1==1)

/*reg [7:0] ttemp00;
reg [7:0] ttemp01;
reg [7:0] ttemp02;
reg [7:0] ttemp03;
reg [7:0] ttemp10;
reg [7:0] ttemp11;
reg [7:0] ttemp12;
reg [7:0] ttemp13;
reg [7:0] ttemp20;
reg [7:0] ttemp21;
reg [7:0] ttemp22;
reg [7:0] ttemp23;
reg [7:0] ttemp30;
reg [7:0] ttemp31;
reg [7:0] ttemp32;
reg [7:0] ttemp33;*/

/*reg [7:0] access_sbox0,access_sbox1,access_sbox2,access_sbox3;
wire [7:0] from_sbox0,from_sbox1,from_sbox2,from_sbox3;

//reg [7:0] access_mixcoll00,access_mixcoll01,access_mixcoll02,access_mixcoll03;

reg [7:0] mm00,mm10,mm20,mm30;
//reg [7:0] access_mixcoll10,access_mixcoll11,access_mixcoll12,access_mixcoll13;
//reg [7:0] mm10,mm11,mm12,mm13;
//reg [7:0] access_mixcoll20,access_mixcoll21,access_mixcoll22,access_mixcoll23;
//reg [7:0] mm20,mm21,mm22,mm23;
//reg [7:0] access_mixcoll30,access_mixcoll31,access_mixcoll32,access_mixcoll33;
//reg [7:0] mm30,mm31,mm32,mm33;
wire [7:0] from_mixcoll00,from_mixcoll01,from_mixcoll02,from_mixcoll03;
wire [7:0] from_mixcoll10,from_mixcoll11,from_mixcoll12,from_mixcoll13;
wire [7:0] from_mixcoll20,from_mixcoll21,from_mixcoll22,from_mixcoll23;
wire [7:0] from_mixcoll30,from_mixcoll31,from_mixcoll32,from_mixcoll33;

//reg [7:0] c0,c1,c2,c3;
//reg [1:0] rowno;
//reg [31:0] from_shifter;

reg [7:0] ip_1_to_xor0,ip_2_to_xor0;//,ip_3_to_xor0,ip_4_to_xor0;
reg [7:0] ip_1_to_xor1,ip_2_to_xor1;//,ip_3_to_xor1,ip_4_to_xor1;
reg [7:0] ip_1_to_xor2,ip_2_to_xor2;//,ip_3_to_xor2,ip_4_to_xor2;
reg [7:0] ip_1_to_xor3,ip_2_to_xor3;//,ip_3_to_xor3,ip_4_to_xor3;
reg [7:0] ip_a,ip_b,ip_c;
wire [7:0] op_xor0,op_xor1,op_xor2,op_xor3,op_3_xor;*/

reg [4:0] state;

/*assign outr0=ct00;
assign outr1=ct01;
assign outr2=ct02;
assign outr3=ct03;
assign outr4=ct10;
assign outr5=ct11;
assign outr6=ct12;
assign outr7=ct13;
assign outr8=ct20;
assign outr9=ct21;
assign outr10=ct22;
assign outr11=ct23;
assign outr12=ct30;
assign outr13=ct31;
assign outr14=ct32;
assign outr15=ct33;*/

//assign outrr0=temp00;
//assign outrr1=temp01;
//assign outrr2=temp02;
//assign outrr3=temp03;

/*assign out0=pt_trans00;
assign out1=pt_trans01;
assign out2=pt_trans02;
assign out3=pt_trans03;
assign out4=pt_trans10;
assign out5=pt_trans11;
assign out6=pt_trans12;
assign out7=pt_trans13;
assign out8=pt_trans20;
assign out9=pt_trans21;
assign out10=pt_trans22;
assign out11=pt_trans23;
assign out12=pt_trans30;
assign out13=pt_trans31;
assign out14=pt_trans32;
assign out15=pt_trans33;*/

always @ (posedge clk)
begin
	if(nreset==1'b0)
	begin
	
	entries[0][0]=8'h63;
	entries[1][0]=8'hca;
	entries[2][0]=8'hb7;
	entries[3][0]=8'h04;
	entries[4][0]=8'h09;
	entries[5][0]=8'h53;
	entries[6][0]=8'hd0;
	entries[7][0]=8'h51;
	entries[8][0]=8'hcd;
	entries[9][0]=8'h60;
	entries[10][0]=8'he0;
	entries[11][0]=8'he7;
	entries[12][0]=8'hba;
	entries[13][0]=8'h70;
	entries[14][0]=8'he1;
	entries[15][0]=8'h8c;
		
	entries[0][1]=8'h7c;
	entries[1][1]=8'h82;
	entries[2][1]=8'hfd;
	entries[3][1]=8'hc7;
	entries[4][1]=8'h83;
	entries[5][1]=8'hd1;
	entries[6][1]=8'hef;
	entries[7][1]=8'ha3;
	entries[8][1]=8'h0c;
	entries[9][1]=8'h81;
	entries[10][1]=8'h32;
	entries[11][1]=8'hc8;
	entries[12][1]=8'h78;
	entries[13][1]=8'h3e;
	entries[14][1]=8'hf8;
	entries[15][1]=8'ha1;

	entries[0][2]=8'h77;
	entries[1][2]=8'hc9;
	entries[2][2]=8'h93;
	entries[3][2]=8'h23;
	entries[4][2]=8'h2c;
	entries[5][2]=8'h00;
	entries[6][2]=8'haa;
	entries[7][2]=8'h40;
	entries[8][2]=8'h13;
	entries[9][2]=8'h4f;
	entries[10][2]=8'h3a;
	entries[11][2]=8'h37;
	entries[12][2]=8'h25;
	entries[13][2]=8'hb5;
	entries[14][2]=8'h98;
	entries[15][2]=8'h89;
		
	entries[0][3]=8'h7b;
	entries[1][3]=8'h7d;
	entries[2][3]=8'h26;
	entries[3][3]=8'hc3;
	entries[4][3]=8'h1a;
	entries[5][3]=8'hed;
	entries[6][3]=8'hfb;
	entries[7][3]=8'h8f;
	entries[8][3]=8'hec;
	entries[9][3]=8'hdc;
	entries[10][3]=8'h0a;
	entries[11][3]=8'h6d;
	entries[12][3]=8'h2e;
	entries[13][3]=8'h66;
	entries[14][3]=8'h11;
	entries[15][3]=8'h0d;
	
	entries[0][4]=8'hf2;
	entries[1][4]=8'hfa;
	entries[2][4]=8'h36;
	entries[3][4]=8'h18;
	entries[4][4]=8'h1b;
	entries[5][4]=8'h20;
	entries[6][4]=8'h43;
	entries[7][4]=8'h92;
	entries[8][4]=8'h5f;
	entries[9][4]=8'h22;
	entries[10][4]=8'h49;
	entries[11][4]=8'h8d;
	entries[12][4]=8'h1c;
	entries[13][4]=8'h48;
	entries[14][4]=8'h69;
	entries[15][4]=8'hbf;
	
	entries[0][5]=8'h6b;
	entries[1][5]=8'h59;
	entries[2][5]=8'h3f;
	entries[3][5]=8'h96;
	entries[4][5]=8'h6e;
	entries[5][5]=8'hfc;
	entries[6][5]=8'h4d;
	entries[7][5]=8'h9d;
	entries[8][5]=8'h97;
	entries[9][5]=8'h2a;
	entries[10][5]=8'h06;
	entries[11][5]=8'hd5;
	entries[12][5]=8'ha6;
	entries[13][5]=8'h03;
	entries[14][5]=8'hd9;
	entries[15][5]=8'he6;

	entries[0][6]=8'h6f;
	entries[1][6]=8'h47;
	entries[2][6]=8'hf7;
	entries[3][6]=8'h05;
	entries[4][6]=8'h5a;
	entries[5][6]=8'hb1;
	entries[6][6]=8'h33;
	entries[7][6]=8'h38;
	entries[8][6]=8'h44;
	entries[9][6]=8'h90;
	entries[10][6]=8'h24;
	entries[11][6]=8'h4e;
	entries[12][6]=8'hb4;
	entries[13][6]=8'hf6;
	entries[14][6]=8'h8e;
	entries[15][6]=8'h42;

	entries[0][7]=8'hc5;
	entries[1][7]=8'hf0;
	entries[2][7]=8'hcc;
	entries[3][7]=8'h9a;
	entries[4][7]=8'ha0;
	entries[5][7]=8'h5b;
	entries[6][7]=8'h85;
	entries[7][7]=8'hf5;
	entries[8][7]=8'h17;
	entries[9][7]=8'h88;
	entries[10][7]=8'h5c;
	entries[11][7]=8'ha9;
	entries[12][7]=8'hc6;
	entries[13][7]=8'h0e;
	entries[14][7]=8'h94;
	entries[15][7]=8'h68;

	entries[0][8]=8'h30;
	entries[1][8]=8'had;
	entries[2][8]=8'h34;
	entries[3][8]=8'h07;
	entries[4][8]=8'h52;
	entries[5][8]=8'h6a;
	entries[6][8]=8'h45;
	entries[7][8]=8'hbc;
	entries[8][8]=8'hc4;
	entries[9][8]=8'h46;
	entries[10][8]=8'hc2;
	entries[11][8]=8'h6c;
	entries[12][8]=8'he8;
	entries[13][8]=8'h61;
	entries[14][8]=8'h9b;
	entries[15][8]=8'h41;

	entries[0][9]=8'h01;
	entries[1][9]=8'hd4;
	entries[2][9]=8'ha5;
	entries[3][9]=8'h12;
	entries[4][9]=8'h3b;
	entries[5][9]=8'hcb;
	entries[6][9]=8'hf9;
	entries[7][9]=8'hb6;
	entries[8][9]=8'ha7;
	entries[9][9]=8'hee;
	entries[10][9]=8'hd3;
	entries[11][9]=8'h56;
	entries[12][9]=8'hdd;
	entries[13][9]=8'h35;
	entries[14][9]=8'h1e;
	entries[15][9]=8'h99;

	entries[0][10]=8'h67;
	entries[1][10]=8'ha2;
	entries[2][10]=8'he5;
	entries[3][10]=8'h80;
	entries[4][10]=8'hd6;
	entries[5][10]=8'hbe;
	entries[6][10]=8'h02;
	entries[7][10]=8'hda;
	entries[8][10]=8'h7e;
	entries[9][10]=8'hb8;
	entries[10][10]=8'hac;
	entries[11][10]=8'hf4;
	entries[12][10]=8'h74;
	entries[13][10]=8'h57;
	entries[14][10]=8'h87;
	entries[15][10]=8'h2d;

	entries[0][11]=8'h2b;
	entries[1][11]=8'haf;
	entries[2][11]=8'hf1;
	entries[3][11]=8'he2;
	entries[4][11]=8'hb3;
	entries[5][11]=8'h39;
	entries[6][11]=8'h7f;
	entries[7][11]=8'h21;
	entries[8][11]=8'h3d;
	entries[9][11]=8'h14;
	entries[10][11]=8'h62;
	entries[11][11]=8'hea;
	entries[12][11]=8'h1f;
	entries[13][11]=8'hb9;
	entries[14][11]=8'he9;
	entries[15][11]=8'h0f;

	entries[0][12]=8'hfe;
	entries[1][12]=8'h9c;
	entries[2][12]=8'h71;
	entries[3][12]=8'heb;
	entries[4][12]=8'h29;
	entries[5][12]=8'h4a;
	entries[6][12]=8'h50;
	entries[7][12]=8'h10;
	entries[8][12]=8'h64;
	entries[9][12]=8'hde;
	entries[10][12]=8'h91;
	entries[11][12]=8'h65;
	entries[12][12]=8'h4b;
	entries[13][12]=8'h86;
	entries[14][12]=8'hce;
	entries[15][12]=8'hb0;

	entries[0][13]=8'hd7;
	entries[1][13]=8'ha4;
	entries[2][13]=8'hd8;
	entries[3][13]=8'h27;
	entries[4][13]=8'he3;
	entries[5][13]=8'h4c;
	entries[6][13]=8'h3c;
	entries[7][13]=8'hff;
	entries[8][13]=8'h5d;
	entries[9][13]=8'h5e;
	entries[10][13]=8'h95;
	entries[11][13]=8'h7a;
	entries[12][13]=8'hbd;
	entries[13][13]=8'hc1;
	entries[14][13]=8'h55;
	entries[15][13]=8'h54;

	entries[0][14]=8'hab;
	entries[1][14]=8'h72;
	entries[2][14]=8'h31;
	entries[3][14]=8'hb2;
	entries[4][14]=8'h2f;
	entries[5][14]=8'h58;
	entries[6][14]=8'h9f;
	entries[7][14]=8'hf3;
	entries[8][14]=8'h19;
	entries[9][14]=8'h0b;
	entries[10][14]=8'he4;
	entries[11][14]=8'hae;
	entries[12][14]=8'h8b;
	entries[13][14]=8'h1d;
	entries[14][14]=8'h28;
	entries[15][14]=8'hbb;

	entries[0][15]=8'h76;
	entries[1][15]=8'hc0;
	entries[2][15]=8'h15;
	entries[3][15]=8'h75;
	entries[4][15]=8'h84;
	entries[5][15]=8'hcf;
	entries[6][15]=8'ha8;
	entries[7][15]=8'hd2;
	entries[8][15]=8'h73;
	entries[9][15]=8'hdb;
	entries[10][15]=8'h79;
	entries[11][15]=8'h08;
	entries[12][15]=8'h8a;
	entries[13][15]=8'h9e;
	entries[14][15]=8'hdf;
	entries[15][15]=8'h16;

	check=2'b00;

	tt0=8'h00;
	tt1=8'h00;
	tt2=8'h00;
	tt3=8'h00;
	//tt=8'h00;
	
	rcon[0]=8'h01;
	rcon[1]=8'h02;
	rcon[2]=8'h04;  
	rcon[3]=8'h08;
	rcon[4]=8'h10;
	rcon[5]=8'h20;
	rcon[6]=8'h40;
	rcon[7]=8'h80;  
	rcon[8]=8'h1b;
	rcon[9]=8'h36;
	port_A_addr=16'h0000;
	port_A_data_in=16'h0000;
	port_A_we=1'b0;
	f=1'b0;
	done=1'b0;
	cnt_rk=8'h00;
		
	status=2'b00;
	
	state=0;	
	end
	else 
	begin
	//step1, get outputs from resources.
	//step2, update the variables.
	//step3, set control variables to the next values
	case(state)
	0:begin		//judge the stage 
		cnt_rk = 4'h0;
		ldcnt = frame_size[7:0]>>2;
		//cnt <= 5'b10000;
		//	kcnt <= 3'b100;
		///port_A_addr_r[15:0]=16'h0000;
		//port_A_data_in=16'h0000;
		//plain_addr[15:0]=16'h0000;
		done=0;
		port_A_we=1'b0;
		if (start_encrypt)
		        begin
				f=~f;
		          state = 1;
		          done = 0;
		        end
		      else begin
			status=2'b10;
		        state = 0;
			end
		end
	1:	begin		// initialize the state from dps and the key 
		port_A_we = 0;
		case(ldcnt)
		8'b100:	begin	
			port_A_addr[15:0] = plain_addr[15:0];	
			state = 2;
		end
		8'b11:  begin
			{{pt_trans30},{pt_trans20},{pt_trans10},{pt_trans00}}= port_A_data_out[31:0];
			temp00=pt_trans00;
			temp10=pt_trans10;
			temp20=pt_trans20;
			temp30=pt_trans30;
			port_A_addr[15:0] = (f==1'b1)?16'h0004:16'h0014;//port_A_addr[15:0] + 4;
			//pt_trans00=text_in_r[7:0];
			//pt_trans10=text_in_r[15:8];
			//pt_trans20=text_in_r[23:16];
			//pt_trans30=text_in_r[31:24];
			state = 2;
			end							
		8'b10:	begin
			{{pt_trans31},{pt_trans21},{pt_trans11},{pt_trans01}} = port_A_data_out[31:0];
			temp01=pt_trans01;
			temp11=pt_trans11;
			temp21=pt_trans21;
			temp31=pt_trans31;
			port_A_addr[15:0] = (f==1'b1)?16'h0008:16'h0018;
			
			//pt_trans01=text_in_r[7:0];
			//pt_trans11=text_in_r[15:8];
			//pt_trans21=text_in_r[23:16];
			//pt_trans31=text_in_r[31:24];
			state=2;
			end				
		8'b01:	begin
			{{pt_trans32},{pt_trans22},{pt_trans12},{pt_trans02}} = port_A_data_out[31:0];
			temp02=pt_trans02;
			temp12=pt_trans12;
			temp22=pt_trans22;
			temp32=pt_trans32;
			port_A_addr[15:0] = (f==1'b1)?16'h000c:16'h001c;

			//pt_trans02=text_in_r[7:0];
			//pt_trans12=text_in_r[15:8];
			//pt_trans22=text_in_r[23:16];
			//pt_trans32=text_in_r[31:24];
			state = 2;
			end	
		8'b0:	begin
			{{pt_trans33},{pt_trans23},{pt_trans13},{pt_trans03}} = port_A_data_out[31:0];
			temp03=pt_trans03;
			temp13=pt_trans13;
			temp23=pt_trans23;
			temp33=pt_trans33;
			state = 4;
			//rdcnt = rdcnt + 1;
			w0 = key_0[31:0];
			w1 = key_1[31:0]; 
			w2 = key_2[31:0]; 
			w3 = key_3[31:0]; 
			ct00=w0[7:0];
			ct10=w0[15:8];
			ct20=w0[23:16];
			ct30=w0[31:24];
			ct01=w1[7:0];
			ct11=w1[15:8];
			ct21=w1[23:16];
			ct31=w1[31:24];											
			ct02=w2[7:0];
			ct12=w2[15:8];
			ct22=w2[23:16];
			ct32=w2[31:24];
			ct03=w3[7:0];
			ct13=w3[15:8];
			ct23=w3[23:16];
			ct33=w3[31:24];
			cnt_rk=0;
			//state =(pt_trans00==8'hxx)?6:4;
			/*if(pt_trans33==8'h34)
				port_A_we_r=1;*/
		end
		endcase
		ldcnt = ldcnt - 1;
		end
	2: begin		
		state = 1;
	end					 
	4:begin	
		if(cnt_rk!=0)
		begin
			tt0=entries[ct13[7:4]][ct13[3:0]];
			tt1=entries[ct23[7:4]][ct23[3:0]];
			tt2=entries[ct33[7:4]][ct33[3:0]];
			tt3=entries[ct03[7:4]][ct03[3:0]];
			
			temp00=entries[pt_trans00[7:4]][pt_trans00[3:0]];
			temp01=entries[pt_trans01[7:4]][pt_trans01[3:0]];
			temp02=entries[pt_trans02[7:4]][pt_trans02[3:0]];
			temp03=entries[pt_trans03[7:4]][pt_trans03[3:0]];			
			temp10=entries[pt_trans11[7:4]][pt_trans11[3:0]];
			temp11=entries[pt_trans12[7:4]][pt_trans12[3:0]];
			temp12=entries[pt_trans13[7:4]][pt_trans13[3:0]];
			temp13=entries[pt_trans10[7:4]][pt_trans10[3:0]];
			temp20=entries[pt_trans22[7:4]][pt_trans22[3:0]];
			temp21=entries[pt_trans23[7:4]][pt_trans23[3:0]];
			temp22=entries[pt_trans20[7:4]][pt_trans20[3:0]];
			temp23=entries[pt_trans21[7:4]][pt_trans21[3:0]];
			temp30=entries[pt_trans33[7:4]][pt_trans33[3:0]];
			temp31=entries[pt_trans30[7:4]][pt_trans30[3:0]];
			temp32=entries[pt_trans31[7:4]][pt_trans31[3:0]];
			temp33=entries[pt_trans32[7:4]][pt_trans32[3:0]];
					
			ct00=ct00^tt0^rcon[cnt_rk-1];
			ct10=ct10^tt1;
			ct20=ct20^tt2;
			ct30=ct30^tt3;	

			ct01=ct01^ct00;	
			ct11=ct11^ct10;	
			ct21=ct21^ct20;	
			ct31=ct31^ct30;	

			ct02=ct02^ct01;	
			ct12=ct12^ct11;	
			ct22=ct22^ct21;	
			ct32=ct32^ct31;	

			ct03=ct03^ct02;	
			ct13=ct13^ct12;	
			ct23=ct23^ct22;	
			ct33=ct33^ct32;	

		end
		state=5;	
	end
	5:begin 
		if(p==1'b0)
		begin
			pt_trans00=((mixcoll(temp00,8'h02))^(mixcoll(temp10,8'h03))^(mixcoll(temp20,8'h01))^(mixcoll(temp30,8'h01)))^ct00;
			pt_trans01=((mixcoll(temp01,8'h02))^(mixcoll(temp11,8'h03))^(mixcoll(temp21,8'h01))^(mixcoll(temp31,8'h01)))^ct01;
			pt_trans02=((mixcoll(temp02,8'h02))^(mixcoll(temp12,8'h03))^(mixcoll(temp22,8'h01))^(mixcoll(temp32,8'h01)))^ct02;
			pt_trans03=((mixcoll(temp03,8'h02))^(mixcoll(temp13,8'h03))^(mixcoll(temp23,8'h01))^(mixcoll(temp33,8'h01)))^ct03;

			pt_trans10=((mixcoll(temp00,8'h01))^(mixcoll(temp10,8'h02))^(mixcoll(temp20,8'h03))^(mixcoll(temp30,8'h01)))^ct10;
			pt_trans11=((mixcoll(temp01,8'h01))^(mixcoll(temp11,8'h02))^(mixcoll(temp21,8'h03))^(mixcoll(temp31,8'h01)))^ct11;
			pt_trans12=((mixcoll(temp02,8'h01))^(mixcoll(temp12,8'h02))^(mixcoll(temp22,8'h03))^(mixcoll(temp32,8'h01)))^ct12;
			pt_trans13=((mixcoll(temp03,8'h01))^(mixcoll(temp13,8'h02))^(mixcoll(temp23,8'h03))^(mixcoll(temp33,8'h01)))^ct13;

			pt_trans20=((mixcoll(temp00,8'h01))^(mixcoll(temp10,8'h01))^(mixcoll(temp20,8'h02))^(mixcoll(temp30,8'h03)))^ct20;
			pt_trans21=((mixcoll(temp01,8'h01))^(mixcoll(temp11,8'h01))^(mixcoll(temp21,8'h02))^(mixcoll(temp31,8'h03)))^ct21;
			pt_trans22=((mixcoll(temp02,8'h01))^(mixcoll(temp12,8'h01))^(mixcoll(temp22,8'h02))^(mixcoll(temp32,8'h03)))^ct22;
			pt_trans23=((mixcoll(temp03,8'h01))^(mixcoll(temp13,8'h01))^(mixcoll(temp23,8'h02))^(mixcoll(temp33,8'h03)))^ct23;

			pt_trans30=((mixcoll(temp00,8'h03))^(mixcoll(temp10,8'h01))^(mixcoll(temp20,8'h01))^(mixcoll(temp30,8'h02)))^ct30;
			pt_trans31=((mixcoll(temp01,8'h03))^(mixcoll(temp11,8'h01))^(mixcoll(temp21,8'h01))^(mixcoll(temp31,8'h02)))^ct31;
			pt_trans32=((mixcoll(temp02,8'h03))^(mixcoll(temp12,8'h01))^(mixcoll(temp22,8'h01))^(mixcoll(temp32,8'h02)))^ct32;
			pt_trans33=((mixcoll(temp03,8'h03))^(mixcoll(temp13,8'h01))^(mixcoll(temp23,8'h01))^(mixcoll(temp33,8'h02)))^ct33;
		end
		else
		begin
			pt_trans00=temp00^ct00;//1&2
			pt_trans01=temp01^ct01;
			pt_trans02=temp02^ct02;
			pt_trans03=temp03^ct03;		
			pt_trans10=temp10^ct10;
			pt_trans11=temp11^ct11;
			pt_trans12=temp12^ct12;
			pt_trans13=temp13^ct13;	
			pt_trans20=temp20^ct20;
			pt_trans21=temp21^ct21;
			pt_trans22=temp22^ct22;
			pt_trans23=temp23^ct23;	
			pt_trans30=temp30^ct30;
			pt_trans31=temp31^ct31;
			pt_trans32=temp32^ct32;
			pt_trans33=temp33^ct33;
			//if(pt_trans00==8'h39)
			//	port_A_we_r = 1;
			
		end
		cnt_rk=cnt_rk+1;
		state=(cnt_rk==11)?6:4;
		check=2'b00;
		/*if(cnt_rk==11)
		begin
			port_A_addr=plain_addr[15:0]+cipher_addr_off;

			port_A_we=1'b1;
			port_A_data_in={pt_trans30,pt_trans20,pt_trans10,pt_trans00};
		end*/
		//port_A_data_in={pt_trans30,pt_trans20,pt_trans10,pt_trans00};
		//done_r=1;
	end
	6: begin
		port_A_we = 1;					
		case(check)
		0:	begin	
		port_A_addr[15:0] = cipher_addr_off[15:0] + plain_addr[15:0];
		port_A_data_in={{pt_trans30},{pt_trans20},{pt_trans10},{pt_trans00}};	
		state = 6;
		end							
		1:	begin 
		port_A_addr[15:0] = (f==1'b1)?16'h00cc:16'h0100;
		port_A_data_in[31:0] = {{pt_trans31},{pt_trans21},{pt_trans11},{pt_trans01}};		
		state = 6;
		end				
		2:	begin
		port_A_addr[15:0] = (f==1'b1)?16'h00d0:16'h0104;
		port_A_data_in[31:0] = {{pt_trans32},{pt_trans22},{pt_trans12},{pt_trans02}};		
		state = 6;
		end	
		3:	begin
		
		port_A_addr[15:0] = (f==1'b1)?16'h00d4:16'h0108;
		port_A_data_in[31:0] = {{pt_trans33},{pt_trans23},{pt_trans13},{pt_trans03}};		
		done = 1;
		state = 0;
		//f=~f;
		end	
		endcase
		check=check+1;
	end
	7: state=7;
	default: state=7;
	endcase
	end
end

function [7:0] mixcoll;
    input [7:0] ip_to_be_mixed;
    input [7:0] mul_matrix_entry;
    //input [7:0] acc_reg;
    reg [7:0] r_temp,r_temp2,r_temp3;
    //wire [7:0] temp,temp2,temp3;
    begin
	r_temp=8'h00;
	r_temp2=8'h00;
	r_temp3=8'h00;
	if(mul_matrix_entry==8'h01) begin
		r_temp=ip_to_be_mixed;
	end
	else begin
		r_temp2=(ip_to_be_mixed & 8'h80);
		if(r_temp2==8'h80)
		begin
			r_temp3=(ip_to_be_mixed<<1)^8'h1b;
		end
		else
		begin
			r_temp3=ip_to_be_mixed<<1;
		end
		if(mul_matrix_entry==8'h02)
		begin		
			r_temp=r_temp3;
		end
		else
		begin
			r_temp=r_temp3^ip_to_be_mixed;
		end	
	end
	mixcoll=r_temp;
	end
endfunction

endmodule
	









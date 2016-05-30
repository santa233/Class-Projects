
module fft_8pt(
    clk,
    reset_n,
    valid_in,
    valid_out,
    xi0_r,
    xi1_r,
    xi2_r,
    xi3_r,
    xi4_r,
    xi5_r,
    xi6_r,
    xi7_r,
    xo0_r,
    xo1_r,
    xo2_r,
    xo3_r,
    xo4_r,
    xo5_r,
    xo6_r,
    xo7_r,
    xi0_i,
    xi1_i,
    xi2_i,
    xi3_i,
    xi4_i,
    xi5_i,
    xi6_i,
    xi7_i,
    xo0_i,
    xo1_i,
    xo2_i,
    xo3_i,
    xo4_i,
    xo5_i,
    xo6_i,
    xo7_i,
    W0_8_r, W1_8_r, W2_8_r, W3_8_r, W0_8_i, W1_8_i, W2_8_i, W3_8_i
);

//parameter szBit = 17;

input  clk;
input  reset_n;
input  valid_in;
output valid_out;

reg valid_in_d1r, valid_in_d2r, valid_in_d3r;
reg signed [63:0] out_tmp_d1r, out_tmp_d2r, out_tmp_d3r;

input  signed [63:0]  W0_8_r;
input  signed [63:0]  W1_8_r;
input  signed [63:0]  W2_8_r;
input  signed [63:0]  W3_8_r;
input  signed [63:0]  W0_8_i;
input  signed [63:0]  W1_8_i;
input  signed [63:0]  W2_8_i;
input  signed [63:0]  W3_8_i;

output signed [63:0]  xo0_r;
output signed [63:0]  xo1_r;
output signed [63:0]  xo2_r;
output signed [63:0]  xo3_r;
output signed [63:0]  xo4_r;
output signed [63:0]  xo5_r;
output signed [63:0]  xo6_r;
output signed [63:0]  xo7_r;
output signed [63:0]  xo0_i;
output signed [63:0]  xo1_i;
output signed [63:0]  xo2_i;
output signed [63:0]  xo3_i;
output signed [63:0]  xo4_i;
output signed [63:0]  xo5_i;
output signed [63:0]  xo6_i;
output signed [63:0]  xo7_i;

input  signed [63:0]  xi0_r;
input  signed [63:0]  xi1_r;
input  signed [63:0]  xi2_r;
input  signed [63:0]  xi3_r;
input  signed [63:0]  xi4_r;
input  signed [63:0]  xi5_r;
input  signed [63:0]  xi6_r;
input  signed [63:0]  xi7_r;
input  signed [63:0]  xi0_i;
input  signed [63:0]  xi1_i;
input  signed [63:0]  xi2_i;
input  signed [63:0]  xi3_i;
input  signed [63:0]  xi4_i;
input  signed [63:0]  xi5_i;
input  signed [63:0]  xi6_i;
input  signed [63:0]  xi7_i;


reg   signed [17-1:0]  xo0_r_w_d1r, xo0_r_w_d2r,xo0_r_w_d3r;
reg   signed [17-1:0]  xo1_r_w_d1r, xo1_r_w_d2r,xo1_r_w_d3r;
reg   signed [17-1:0]  xo2_r_w_d1r, xo2_r_w_d2r,xo2_r_w_d3r;
reg   signed [17-1:0]  xo3_r_w_d1r, xo3_r_w_d2r,xo3_r_w_d3r;
reg   signed [17-1:0]  xo4_r_w_d1r, xo4_r_w_d2r,xo4_r_w_d3r;
reg   signed [17-1:0]  xo5_r_w_d1r, xo5_r_w_d2r,xo5_r_w_d3r;
reg   signed [17-1:0]  xo6_r_w_d1r, xo6_r_w_d2r,xo6_r_w_d3r;
reg   signed [17-1:0]  xo7_r_w_d1r, xo7_r_w_d2r,xo7_r_w_d3r;
reg   signed [17-1:0]  xo0_i_w_d1r, xo0_i_w_d2r,xo0_i_w_d3r;
reg   signed [17-1:0]  xo1_i_w_d1r, xo1_i_w_d2r,xo1_i_w_d3r;
reg   signed [17-1:0]  xo2_i_w_d1r, xo2_i_w_d2r,xo2_i_w_d3r;
reg   signed [17-1:0]  xo3_i_w_d1r, xo3_i_w_d2r,xo3_i_w_d3r;
reg   signed [17-1:0]  xo4_i_w_d1r, xo4_i_w_d2r,xo4_i_w_d3r;
reg   signed [17-1:0]  xo5_i_w_d1r, xo5_i_w_d2r,xo5_i_w_d3r;
reg   signed [17-1:0]  xo6_i_w_d1r, xo6_i_w_d2r,xo6_i_w_d3r;
reg   signed [17-1:0]  xo7_i_w_d1r, xo7_i_w_d2r,xo7_i_w_d3r;

wire  signed [17-1:0]  W0_8_r_w = {W0_8_r[63:63-17+1]};
wire  signed [17-1:0]  W1_8_r_w = {W1_8_r[63:63-17+1]};
wire  signed [17-1:0]  W2_8_r_w = {W2_8_r[63:63-17+1]};
wire  signed [17-1:0]  W3_8_r_w = {W3_8_r[63:63-17+1]};
wire  signed [17-1:0]  W0_8_i_w = {W0_8_i[63:63-17+1]};
wire  signed [17-1:0]  W1_8_i_w = {W1_8_i[63:63-17+1]};
wire  signed [17-1:0]  W2_8_i_w = {W2_8_i[63:63-17+1]};
wire  signed [17-1:0]  W3_8_i_w = {W3_8_i[63:63-17+1]};

wire   signed [17-1:0]  xi0_r_w = {xi0_r[63:63-17+1]};
wire   signed [17-1:0]  xi1_r_w = {xi1_r[63:63-17+1]};
wire   signed [17-1:0]  xi2_r_w = {xi2_r[63:63-17+1]};
wire   signed [17-1:0]  xi3_r_w = {xi3_r[63:63-17+1]};
wire   signed [17-1:0]  xi4_r_w = {xi4_r[63:63-17+1]};
wire   signed [17-1:0]  xi5_r_w = {xi5_r[63:63-17+1]};
wire   signed [17-1:0]  xi6_r_w = {xi6_r[63:63-17+1]};
wire   signed [17-1:0]  xi7_r_w = {xi7_r[63:63-17+1]};
wire   signed [17-1:0]  xi0_i_w = {xi0_i[63:63-17+1]};
wire   signed [17-1:0]  xi1_i_w = {xi1_i[63:63-17+1]};
wire   signed [17-1:0]  xi2_i_w = {xi2_i[63:63-17+1]};
wire   signed [17-1:0]  xi3_i_w = {xi3_i[63:63-17+1]};
wire   signed [17-1:0]  xi4_i_w = {xi4_i[63:63-17+1]};
wire   signed [17-1:0]  xi5_i_w = {xi5_i[63:63-17+1]};
wire   signed [17-1:0]  xi6_i_w = {xi6_i[63:63-17+1]};
wire   signed [17-1:0]  xi7_i_w = {xi7_i[63:63-17+1]};

wire   signed [17-1:0]  xo0_r_w;
wire   signed [17-1:0]  xo1_r_w;
wire   signed [17-1:0]  xo2_r_w;
wire   signed [17-1:0]  xo3_r_w;
wire   signed [17-1:0]  xo4_r_w;
wire   signed [17-1:0]  xo5_r_w;
wire   signed [17-1:0]  xo6_r_w;
wire   signed [17-1:0]  xo7_r_w;
wire   signed [17-1:0]  xo0_i_w;
wire   signed [17-1:0]  xo1_i_w;
wire   signed [17-1:0]  xo2_i_w;
wire   signed [17-1:0]  xo3_i_w;
wire   signed [17-1:0]  xo4_i_w;
wire   signed [17-1:0]  xo5_i_w;
wire   signed [17-1:0]  xo6_i_w;
wire   signed [17-1:0]  xo7_i_w;

assign xo0_r={xo0_r_w_d2r[16:0], {(64-17){1'b0}}};
assign xo1_r={xo1_r_w_d2r[16:0], {(64-17){1'b0}}};
assign xo2_r={xo2_r_w_d2r[16:0], {(64-17){1'b0}}};
assign xo3_r={xo3_r_w_d2r[16:0], {(64-17){1'b0}}};
assign xo4_r={xo4_r_w_d2r[16:0], {(64-17){1'b0}}};
assign xo5_r={xo5_r_w_d2r[16:0], {(64-17){1'b0}}};
assign xo6_r={xo6_r_w_d2r[16:0], {(64-17){1'b0}}};
assign xo7_r={xo7_r_w_d2r[16:0], {(64-17){1'b0}}};
assign xo0_i={xo0_i_w_d2r[16:0], {(64-17){1'b0}}};
assign xo1_i={xo1_i_w_d2r[16:0], {(64-17){1'b0}}};
assign xo2_i={xo2_i_w_d2r[16:0], {(64-17){1'b0}}};
assign xo3_i={xo3_i_w_d2r[16:0], {(64-17){1'b0}}};
assign xo4_i={xo4_i_w_d2r[16:0], {(64-17){1'b0}}};
assign xo5_i={xo5_i_w_d2r[16:0], {(64-17){1'b0}}};
assign xo6_i={xo6_i_w_d2r[16:0], {(64-17){1'b0}}};
assign xo7_i={xo7_i_w_d2r[16:0], {(64-17){1'b0}}};

wire    signed [17-1:0]  s1_0_r;
wire    signed [17-1:0]  s1_1_r;
wire    signed [17-1:0]  s1_2_r;
wire    signed [17-1:0]  s1_3_r;
wire    signed [17-1:0]  s1_4_r;
wire    signed [17-1:0]  s1_5_r;
wire    signed [17-1:0]  s1_6_r;
wire    signed [17-1:0]  s1_7_r;

wire    signed [17-1:0]  s1_0_i;
wire    signed [17-1:0]  s1_1_i;
wire    signed [17-1:0]  s1_2_i;
wire    signed [17-1:0]  s1_3_i;
wire    signed [17-1:0]  s1_4_i;
wire    signed [17-1:0]  s1_5_i;
wire    signed [17-1:0]  s1_6_i;
wire    signed [17-1:0]  s1_7_i;

wire    signed [17-1:0]  s2_0_r;
wire    signed [17-1:0]  s2_1_r;
wire    signed [17-1:0]  s2_2_r;
wire    signed [17-1:0]  s2_3_r;
wire    signed [17-1:0]  s2_4_r;
wire    signed [17-1:0]  s2_5_r;
wire    signed [17-1:0]  s2_6_r;
wire    signed [17-1:0]  s2_7_r;

wire    signed [17-1:0]  s2_0_i;
wire    signed [17-1:0]  s2_1_i;
wire    signed [17-1:0]  s2_2_i;
wire    signed [17-1:0]  s2_3_i;
wire    signed [17-1:0]  s2_4_i;
wire    signed [17-1:0]  s2_5_i;
wire    signed [17-1:0]  s2_6_i;
wire    signed [17-1:0]  s2_7_i;

wire    signed [17-1:0]  s3_0_r;
wire    signed [17-1:0]  s3_1_r;
wire    signed [17-1:0]  s3_2_r;
wire    signed [17-1:0]  s3_3_r;
wire    signed [17-1:0]  s3_4_r;
wire    signed [17-1:0]  s3_5_r;
wire    signed [17-1:0]  s3_6_r;
wire    signed [17-1:0]  s3_7_r;

wire    signed [17-1:0]  s3_0_i;
wire    signed [17-1:0]  s3_1_i;
wire    signed [17-1:0]  s3_2_i;
wire    signed [17-1:0]  s3_3_i;
wire    signed [17-1:0]  s3_4_i;
wire    signed [17-1:0]  s3_5_i;
wire    signed [17-1:0]  s3_6_i;
wire    signed [17-1:0]  s3_7_i;

wire    signed [17-1:0]  s1_4_tmp_r;
wire    signed [17-1:0]  s1_6_tmp_r;
wire    signed [17-1:0]  s1_5_tmp_r;
wire    signed [17-1:0]  s1_7_tmp_r;
wire    signed [17-1:0]  s1_4_tmp_i;
wire    signed [17-1:0]  s1_6_tmp_i;
wire    signed [17-1:0]  s1_5_tmp_i;
wire    signed [17-1:0]  s1_7_tmp_i;

wire    signed [17-1:0]   s2_2_tmp_r;
wire    signed [17-1:0]   s2_3_tmp_r;
wire    signed [17-1:0]   s2_6_tmp_r;
wire    signed [17-1:0]   s2_7_tmp_r;
wire    signed [17-1:0]   s2_2_tmp_i;
wire    signed [17-1:0]   s2_3_tmp_i;
wire    signed [17-1:0]   s2_6_tmp_i;
wire    signed [17-1:0]   s2_7_tmp_i;

wire    signed [17-1:0]   s3_1_tmp_r;
wire    signed [17-1:0]   s3_3_tmp_r;
wire    signed [17-1:0]   s3_5_tmp_r;
wire    signed [17-1:0]   s3_7_tmp_r;
wire    signed [17-1:0]   s3_1_tmp_i;
wire    signed [17-1:0]   s3_3_tmp_i;
wire    signed [17-1:0]   s3_5_tmp_i;
wire    signed [17-1:0]   s3_7_tmp_i;

//------------- Stage 1 ----------------
wire   signed [17-1:0]  xi0_r_tmp = (xi0_r_w>>>0)<<<0;
wire   signed [17-1:0]  xi1_r_tmp = (xi1_r_w>>>0)<<<0;
wire   signed [17-1:0]  xi2_r_tmp = (xi2_r_w>>>0)<<<0;
wire   signed [17-1:0]  xi3_r_tmp = (xi3_r_w>>>0)<<<0;
wire   signed [17-1:0]  xi4_r_tmp = (xi4_r_w>>>0)<<<0;
wire   signed [17-1:0]  xi5_r_tmp = (xi5_r_w>>>0)<<<0;
wire   signed [17-1:0]  xi6_r_tmp = (xi6_r_w>>>0)<<<0;
wire   signed [17-1:0]  xi7_r_tmp = (xi7_r_w>>>0)<<<0;
wire   signed [17-1:0]  xi0_i_tmp = (xi0_i_w>>>0)<<<0;
wire   signed [17-1:0]  xi1_i_tmp = (xi1_i_w>>>0)<<<0;
wire   signed [17-1:0]  xi2_i_tmp = (xi2_i_w>>>0)<<<0;
wire   signed [17-1:0]  xi3_i_tmp = (xi3_i_w>>>0)<<<0;
wire   signed [17-1:0]  xi4_i_tmp = (xi4_i_w>>>0)<<<0;
wire   signed [17-1:0]  xi5_i_tmp = (xi5_i_w>>>0)<<<0;
wire   signed [17-1:0]  xi6_i_tmp = (xi6_i_w>>>0)<<<0;
wire   signed [17-1:0]  xi7_i_tmp = (xi7_i_w>>>0)<<<0;

wire    signed [17-1:0]  W0_8_r_tmp = (W0_8_r_w>>>0);
wire    signed [17-1:0]  W1_8_r_tmp = (W1_8_r_w>>>0);
wire    signed [17-1:0]  W2_8_r_tmp = (W2_8_r_w>>>0);
wire    signed [17-1:0]  W3_8_r_tmp = (W3_8_r_w>>>0);
wire    signed [17-1:0]  W0_8_i_tmp = (W0_8_i_w>>>0);
wire    signed [17-1:0]  W1_8_i_tmp = (W1_8_i_w>>>0);
wire    signed [17-1:0]  W2_8_i_tmp = (W2_8_i_w>>>0);
wire    signed [17-1:0]  W3_8_i_tmp = (W3_8_i_w>>>0);

assign valid_out = valid_in_d2r;


always @(negedge reset_n or posedge clk) begin
    if(!reset_n) begin
        valid_in_d1r <= 0;
        valid_in_d2r <= 0;
        valid_in_d3r <= 0;
        xo0_r_w_d1r<=0; xo0_i_w_d1r<=0;
        xo1_r_w_d1r<=0; xo1_i_w_d1r<=0;
        xo2_r_w_d1r<=0; xo2_i_w_d1r<=0;
        xo3_r_w_d1r<=0; xo3_i_w_d1r<=0;
        xo4_r_w_d1r<=0; xo4_i_w_d1r<=0;
        xo5_r_w_d1r<=0; xo5_i_w_d1r<=0;
        xo6_r_w_d1r<=0; xo6_i_w_d1r<=0;
        xo7_r_w_d1r<=0; xo7_i_w_d1r<=0;
        xo0_r_w_d2r<=0; xo0_i_w_d2r<=0;
        xo1_r_w_d2r<=0; xo1_i_w_d2r<=0;
        xo2_r_w_d2r<=0; xo2_i_w_d2r<=0;
        xo3_r_w_d2r<=0; xo3_i_w_d2r<=0;
        xo4_r_w_d2r<=0; xo4_i_w_d2r<=0;
        xo5_r_w_d2r<=0; xo5_i_w_d2r<=0;
        xo6_r_w_d2r<=0; xo6_i_w_d2r<=0;
        xo7_r_w_d2r<=0; xo7_i_w_d2r<=0;

    end else begin
        valid_in_d1r <= valid_in;
        valid_in_d2r <= valid_in_d1r;
        valid_in_d3r <= valid_in_d2r;
        xo0_r_w_d1r<=s2_0_r; xo0_i_w_d1r<=s2_0_i;
        xo1_r_w_d1r<=s2_1_r; xo1_i_w_d1r<=s2_1_i;
        xo2_r_w_d1r<=s2_2_r; xo2_i_w_d1r<=s2_2_i;
        xo3_r_w_d1r<=s2_3_r; xo3_i_w_d1r<=s2_3_i;
        xo4_r_w_d1r<=s2_4_r; xo4_i_w_d1r<=s2_4_i;
        xo5_r_w_d1r<=s2_5_r; xo5_i_w_d1r<=s2_5_i;
        xo6_r_w_d1r<=s2_6_r; xo6_i_w_d1r<=s2_6_i;
        xo7_r_w_d1r<=s2_7_r; xo7_i_w_d1r<=s2_7_i;
        xo0_r_w_d2r<=xo0_r_w; xo0_i_w_d2r<=xo0_i_w;
        xo1_r_w_d2r<=xo1_r_w; xo1_i_w_d2r<=xo1_i_w;
        xo2_r_w_d2r<=xo2_r_w; xo2_i_w_d2r<=xo2_i_w;
        xo3_r_w_d2r<=xo3_r_w; xo3_i_w_d2r<=xo3_i_w;
        xo4_r_w_d2r<=xo4_r_w; xo4_i_w_d2r<=xo4_i_w;
        xo5_r_w_d2r<=xo5_r_w; xo5_i_w_d2r<=xo5_i_w;
        xo6_r_w_d2r<=xo6_r_w; xo6_i_w_d2r<=xo6_i_w;
        xo7_r_w_d2r<=xo7_r_w; xo7_i_w_d2r<=xo7_i_w;
    end
end

assign s1_0_r = (xi0_r_tmp>>>0)+(xi4_r_tmp>>>0);
assign s1_1_r = (xi1_r_tmp>>>0)+(xi5_r_tmp>>>0);
assign s1_2_r = (xi2_r_tmp>>>0)+(xi6_r_tmp>>>0);
assign s1_3_r = (xi3_r_tmp>>>0)+(xi7_r_tmp>>>0);
assign s1_4_r = (xi0_r_tmp>>>0)-(xi4_r_tmp>>>0);
assign s1_5_r = (xi1_r_tmp>>>0)-(xi5_r_tmp>>>0);
assign s1_6_r = (xi2_r_tmp>>>0)-(xi6_r_tmp>>>0);
assign s1_7_r = (xi3_r_tmp>>>0)-(xi7_r_tmp>>>0);

assign s1_0_i = (xi0_i_tmp>>>0)+(xi4_i_tmp>>>0);
assign s1_1_i = (xi1_i_tmp>>>0)+(xi5_i_tmp>>>0);
assign s1_2_i = (xi2_i_tmp>>>0)+(xi6_i_tmp>>>0);
assign s1_3_i = (xi3_i_tmp>>>0)+(xi7_i_tmp>>>0);
assign s1_4_i = (xi0_i_tmp>>>0)-(xi4_i_tmp>>>0);
assign s1_5_i = (xi1_i_tmp>>>0)-(xi5_i_tmp>>>0);
assign s1_6_i = (xi2_i_tmp>>>0)-(xi6_i_tmp>>>0);
assign s1_7_i = (xi3_i_tmp>>>0)-(xi7_i_tmp>>>0);

//------------- Stage 2 ----------------


assign s2_0_r = (s1_0_r>>>0)+(s1_2_r>>>0);
assign s2_1_r = (s1_1_r>>>0)+(s1_3_r>>>0);
assign s2_2_r = (s1_0_r>>>0)-(s1_2_r>>>0);
assign s2_3_r = (s1_1_r>>>0)-(s1_3_r>>>0);
assign s2_4_r = (s1_4_tmp_r>>>0)+(s1_6_tmp_r>>>0);
assign s2_5_r = (s1_5_tmp_r>>>0)+(s1_7_tmp_r>>>0);
assign s2_6_r = (s1_4_tmp_r>>>0)-(s1_6_tmp_r>>>0);
assign s2_7_r = (s1_5_tmp_r>>>0)-(s1_7_tmp_r>>>0);

assign s2_0_i = (s1_0_i>>>0)+(s1_2_i>>>0);
assign s2_1_i = (s1_1_i>>>0)+(s1_3_i>>>0);
assign s2_2_i = (s1_0_i>>>0)-(s1_2_i>>>0);
assign s2_3_i = (s1_1_i>>>0)-(s1_3_i>>>0);
assign s2_4_i = (s1_4_tmp_i>>>0)+(s1_6_tmp_i>>>0);
assign s2_5_i = (s1_5_tmp_i>>>0)+(s1_7_tmp_i>>>0);
assign s2_6_i = (s1_4_tmp_i>>>0)-(s1_6_tmp_i>>>0);
assign s2_7_i = (s1_5_tmp_i>>>0)-(s1_7_tmp_i>>>0);

//------------- Stage 3 ----------------

assign s3_0_r = (xo0_r_w_d1r>>>0)+(xo1_r_w_d1r>>>0);
assign s3_1_r = (xo0_r_w_d1r>>>0)-(xo1_r_w_d1r>>>0);
assign s3_2_r = (s2_2_tmp_r>>>0)+(s2_3_tmp_r>>>0);
assign s3_3_r = (s2_2_tmp_r>>>0)-(s2_3_tmp_r>>>0);
assign s3_4_r = (xo4_r_w_d1r>>>0)+(xo5_r_w_d1r>>>0);
assign s3_5_r = (xo4_r_w_d1r>>>0)-(xo5_r_w_d1r>>>0);
assign s3_6_r = (s2_6_tmp_r>>>0)+(s2_7_tmp_r>>>0);
assign s3_7_r = (s2_6_tmp_r>>>0)-(s2_7_tmp_r>>>0);

assign s3_0_i = (xo0_i_w_d1r>>>0)+(xo1_i_w_d1r>>>0);
assign s3_1_i = (xo0_i_w_d1r>>>0)-(xo1_i_w_d1r>>>0);
assign s3_2_i = (s2_2_tmp_i>>>0)+(s2_3_tmp_i>>>0);
assign s3_3_i = (s2_2_tmp_i>>>0)-(s2_3_tmp_i>>>0);
assign s3_4_i = (xo4_i_w_d1r>>>0)+(xo5_i_w_d1r>>>0);
assign s3_5_i = (xo4_i_w_d1r>>>0)-(xo5_i_w_d1r>>>0);
assign s3_6_i = (s2_6_tmp_i>>>0)+(s2_7_tmp_i>>>0);
assign s3_7_i = (s2_6_tmp_i>>>0)-(s2_7_tmp_i>>>0);

//------------- Output Stage ----------------

assign xo0_r_w = s3_0_r;
assign xo1_r_w = s3_1_tmp_r;
assign xo2_r_w = s3_2_r;
assign xo3_r_w = s3_3_tmp_r;
assign xo4_r_w = s3_4_r;
assign xo5_r_w = s3_5_tmp_r;
assign xo6_r_w = s3_6_r;
assign xo7_r_w = s3_7_tmp_r;

assign xo0_i_w = s3_0_i;
assign xo1_i_w = s3_1_tmp_i;
assign xo2_i_w = s3_2_i;
assign xo3_i_w = s3_3_tmp_i;
assign xo4_i_w = s3_4_i;
assign xo5_i_w = s3_5_tmp_i;
assign xo6_i_w = s3_6_i;
assign xo7_i_w = s3_7_tmp_i;

assign s1_4_tmp_r = real_part(s1_4_r, s1_4_i, (W0_8_r_tmp>>>0), (W0_8_i_tmp>>>0) );
assign s1_5_tmp_r = real_part(s1_5_r, s1_5_i, (W1_8_r_tmp>>>0), (W1_8_i_tmp>>>0) );
assign s1_6_tmp_r = real_part(s1_6_r, s1_6_i, (W2_8_r_tmp>>>0), (W2_8_i_tmp>>>0) );
assign s1_7_tmp_r = real_part(s1_7_r, s1_7_i, (W3_8_r_tmp>>>0), (W3_8_i_tmp>>>0) );
assign s1_4_tmp_i = imag_part(s1_4_r, s1_4_i, (W0_8_r_tmp>>>0), (W0_8_i_tmp>>>0) );
assign s1_5_tmp_i = imag_part(s1_5_r, s1_5_i, (W1_8_r_tmp>>>0), (W1_8_i_tmp>>>0) );
assign s1_6_tmp_i = imag_part(s1_6_r, s1_6_i, (W2_8_r_tmp>>>0), (W2_8_i_tmp>>>0) );
assign s1_7_tmp_i = imag_part(s1_7_r, s1_7_i, (W3_8_r_tmp>>>0), (W3_8_i_tmp>>>0) );

//assign s2_2_tmp_r = real_part(xo2_r_w_d1r, xo2_i_w_d1r, (W0_8_r_tmp>>>0), (W0_8_i_tmp>>>0) );
//assign s2_3_tmp_r = real_part(xo3_r_w_d1r, xo3_i_w_d1r, (W2_8_r_tmp>>>0), (W2_8_i_tmp>>>0) );
//assign s2_6_tmp_r = real_part(xo6_r_w_d1r, xo6_i_w_d1r, (W0_8_r_tmp>>>0), (W0_8_i_tmp>>>0) );
//assign s2_7_tmp_r = real_part(xo7_r_w_d1r, xo7_i_w_d1r, (W2_8_r_tmp>>>0), (W2_8_i_tmp>>>0) );
//assign s2_2_tmp_i = imag_part(xo2_r_w_d1r, xo2_i_w_d1r, (W0_8_r_tmp>>>0), (W0_8_i_tmp>>>0) );
//assign s2_3_tmp_i = imag_part(xo3_r_w_d1r, xo3_i_w_d1r, (W2_8_r_tmp>>>0), (W2_8_i_tmp>>>0) );
//assign s2_6_tmp_i = imag_part(xo6_r_w_d1r, xo6_i_w_d1r, (W0_8_r_tmp>>>0), (W0_8_i_tmp>>>0) );
//assign s2_7_tmp_i = imag_part(xo7_r_w_d1r, xo7_i_w_d1r, (W2_8_r_tmp>>>0), (W2_8_i_tmp>>>0) );

//assign s2_2_tmp_r = real_part(xo2_r_w_d1r[17-1:1], xo2_i_w_d1r[17-1:1], (W0_1_r_tmp[17-1:1]), (W0_1_i_tmp[17-1:1]) );
assign s2_2_tmp_r = xo2_r_w_d1r;
//assign s2_3_tmp_r = real_part(s2_3_r[17-1:1], s2_3_r[17-1:1], (W2_1_r_tmp[17-1:1]), (W2_1_i_tmp[17-1:1]) );
assign s2_3_tmp_r = xo3_i_w_d1r;
//assign s2_6_tmp_r = real_part(xo6_r_w_d1r[17-1:1], xo6_i_w_d1r[17-1:1], (W0_1_r_tmp[17-1:1]), (W0_1_i_tmp[17-1:1]) );
assign s2_6_tmp_r = xo6_r_w_d1r;
//assign s2_7_tmp_r = real_part(s2_7_r[17-1:1], s2_7_r[17-1:1], (W2_1_r_tmp[17-1:1]), (W2_1_i_tmp[17-1:1]) );
assign s2_7_tmp_r = xo7_i_w_d1r;
//assign s2_2_tmp_i = imag_part(xo2_r_w_d1r[17-1:1], xo2_i_w_d1r[17-1:1], (W0_1_r_tmp[17-1:1]), (W0_1_i_tmp[17-1:1]) );
assign s2_2_tmp_i = xo2_i_w_d1r;
//assign s2_3_tmp_i = imag_part(s2_3_i[17-1:1], s2_3_i[17-1:1], (W2_1_r_tmp[17-1:1]), (W2_1_i_tmp[17-1:1]) );
assign s2_3_tmp_i=  17'b0-xo3_r_w_d1r;
//assign s2_6_tmp_i = imag_part(xo6_r_w_d1r[17-1:1], xo6_i_w_d1r[17-1:1], (W0_1_r_tmp[17-1:1]), (W0_1_i_tmp[17-1:1]) );
assign s2_6_tmp_i = xo6_i_w_d1r;
//assign s2_7_tmp_i = imag_part(s2_7_i[17-1:1], s2_7_i[17-1:1], (W2_1_r_tmp[17-1:1]), (W2_1_i_tmp[17-1:1]) );
assign s2_7_tmp_i=  17'b0-xo7_r_w_d1r;

assign s3_1_tmp_r = s3_1_r;
assign s3_3_tmp_r = s3_3_r;
assign s3_5_tmp_r = s3_5_r;
assign s3_7_tmp_r = s3_7_r;

assign s3_1_tmp_i = s3_1_i;
assign s3_3_tmp_i = s3_3_i;
assign s3_5_tmp_i = s3_5_i;
assign s3_7_tmp_i = s3_7_i;


//assign s3_1_tmp_r = real_part(s3_1_r, s3_1_i, (W0_8_r_tmp>>>0), (W0_8_i_tmp>>>0) );
//assign s3_3_tmp_r = real_part(s3_3_r, s3_3_i, (W0_8_r_tmp>>>0), (W0_8_i_tmp>>>0) );
//assign s3_5_tmp_r = real_part(s3_5_r, s3_5_i, (W0_8_r_tmp>>>0), (W0_8_i_tmp>>>0) );
//assign s3_7_tmp_r = real_part(s3_7_r, s3_7_i, (W0_8_r_tmp>>>0), (W0_8_i_tmp>>>0) );
//assign s3_1_tmp_i = imag_part(s3_1_r, s3_1_i, (W0_8_r_tmp>>>0), (W0_8_i_tmp>>>0) );
//assign s3_3_tmp_i = imag_part(s3_3_r, s3_3_i, (W0_8_r_tmp>>>0), (W0_8_i_tmp>>>0) );
//assign s3_5_tmp_i = imag_part(s3_5_r, s3_5_i, (W0_8_r_tmp>>>0), (W0_8_i_tmp>>>0) );
//assign s3_7_tmp_i = imag_part(s3_7_r, s3_7_i, (W0_8_r_tmp>>>0), (W0_8_i_tmp>>>0) );


//-------------------------------------------------
// Input format:
// real_part(a,b,c,d);
// imag_part(a,b,c,d);
//-------------------------------------------------
// real_part = (ac-bd)
// imag_part = (ad+bc)
//-------------------------------------------------
function signed [17-1:0] real_part;
    input   signed [17-1:0]  a;
    input   signed [17-1:0]  b;
    input   signed [17-1:0]  c;
    input   signed [17-1:0]  d;
    reg     signed [17*2-1:0] tmp1;
    reg     signed [17*2-1:0] tmp2;
    reg     signed [17*2-1:0] tmp3;
begin
	tmp1=a*c;
	tmp2=b*d;
	tmp3=tmp1-tmp2;
	real_part=tmp3[17*2-4-1:17-4];
end
endfunction

function signed [17-1:0] imag_part;
    input   signed [17-1:0]  a;
    input   signed [17-1:0]  b;
    input   signed [17-1:0]  c;
    input   signed [17-1:0]  d;
    reg     signed [17*2-1:0] tmp1;
    reg     signed [17*2-1:0] tmp2;
    reg     signed [17*2-1:0] tmp3;
   // reg     unsigned [2:0] p;
   // reg     unsigned [2:0] q;
    //reg     unsigned [2:0] a_i;
    //reg     unsigned [2:0] b_i;
    //reg     unsigned [2:0] c_i;
    //reg     unsigned [2:0] d_i;
   //reg     unsigned sign_tmp1;
    //reg     unsigned sign_tmp2;
    //reg     unsigned sign_tmp3;
    //reg     unsigned max;
    begin

	tmp1=a*d;
	tmp2=b*c;
	tmp3=tmp1+tmp2;
	imag_part=tmp3[17*2-4-1:17-4];
	
	
    end
endfunction


endmodule



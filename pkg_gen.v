 `timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:QTEC
// Engineer:
//
// Create Date:    09:28:18 19/07/2018
// Design Name:
// Module Name:    pkg_gen
// Project Name:
// Target Devices:
// Tool versions:
// Description:*
// attention:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module pkg_gen
(
    input wire         clk,
    input wire         rst,

    input wire         i_tx_start,
    input wire  [31:0] i_tx_data,
    input wire         i_tx_data_vld,

    input  wire        i_urttx_rd_en,
    output wire        o_urttx_alempty,
    output wire        o_urttx_empty,
    output wire [7:0]  o_urttx_rd_dat,

    output reg         o_tx_busy

);


reg [7:0] tx_data_tmp;
reg       tx_data_vld_tmp;

reg [3:0] tx_cnt;

always@(posedge clk)
    if(rst) tx_cnt <= 4'h0;
    else if(i_tx_data_vld) tx_cnt <= 4'h1;
    else if(tx_cnt<4'h4)tx_cnt <= tx_cnt + 1'b1;
    else tx_cnt <= tx_cnt;

always@(posedge clk)
    if(rst) begin
        tx_data_vld_tmp <= 1'b0;
        tx_data_tmp <= 8'h00;
        o_tx_busy <= 1'b0;
    end else if(tx_cnt==4'h1) begin
        tx_data_vld_tmp <= 1'b1;
        tx_data_tmp <= i_tx_data[7:0];
        o_tx_busy <= 1'b1;
    end else if(tx_cnt==4'h2) begin
        tx_data_vld_tmp <= 1'b1;
        tx_data_tmp <= i_tx_data[15:8];
        o_tx_busy <= 1'b1;
    end else if(tx_cnt==4'h3) begin
        tx_data_vld_tmp <= 1'b1;
        tx_data_tmp <= i_tx_data[23:16];
        o_tx_busy <= 1'b1;
    end else if(tx_cnt==4'h4) begin
        tx_data_vld_tmp <= 1'b1;
        tx_data_tmp <= i_tx_data[31:24];
        o_tx_busy <= 1'b1;
    end else begin
        tx_data_vld_tmp <= 1'b0;
        tx_data_tmp <= tx_data_tmp;
        o_tx_busy <= 1'b0;
    end

scfifo_4x120_8x128 ccm_sch_urt
(
  .aclr           ( rst                ),
  .clock          ( clk                ),
  .data           ( tx_data_tmp[7:0]   ),
  .rdreq          ( i_urttx_rd_en      ),
  .wrreq          ( tx_data_vld_tmp    ),
  .almost_empty   ( o_urttx_alempty    ),
  .almost_full    ( ccm_sch_urt_alfull ),
  .empty          ( o_urttx_empty      ),
  .full           ( ),
  .q              ( o_urttx_rd_dat[7:0]),
  .usedw          ()
);



endmodule
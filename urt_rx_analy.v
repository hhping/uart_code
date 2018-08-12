 `timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: QTEC
// Engineer:
//
// Create Date:    09:28:18 19/07/2018
// Design Name:
// Module Name:    urt_rx_analy
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
module urt_rx_analy
(
    input  wire        clk,
    input  wire        rst,

    output reg         o_urtrx_rd_en,
    input  wire [7:0]  i_urtrx_rd_dat,
    input  wire        i_urtrx_empty,
    input  wire        i_urtrx_rdy,

    output wire [00:0] o_rd_ch0_photon_val_req,
    output wire [00:0] o_rd_ch0_hv_val_req,
    output wire [00:0] o_rd_ch0_tmpratu_val_req,
    output wire [00:0] o_rd_ch0_hv_switch_stat_req,
    output wire [00:0] o_rd_ch0_dly_val_req,
    output wire [00:0] o_rd_ch0_10per_hv_val_req,
    output wire [00:0] o_rd_ch0_20per_hv_val_req,
    output wire [00:0] o_rd_ch0_dead_time_req,
    output wire [00:0] o_rd_ch0_tri_stat_req,
    output wire [00:0] o_rd_ch0_det_effi_conf_val_req,

    output wire [00:0] o_rd_ch1_photon_val_req,
    output wire [00:0] o_rd_ch1_hv_val_req,
    output wire [00:0] o_rd_ch1_tmpratu_val_req,
    output wire [00:0] o_rd_ch1_hv_switch_stat_req,
    output wire [00:0] o_rd_ch1_dly_val_req,
    output wire [00:0] o_rd_ch1_10per_hv_val_req,
    output wire [00:0] o_rd_ch1_20per_hv_val_req,
    output wire [00:0] o_rd_ch1_dead_time_req,
    output wire [00:0] o_rd_ch1_tri_stat_req,
    output wire [00:0] o_rd_ch1_det_effi_conf_val_req,

    output reg  [31:0] o_rx_ch0_set_sel,                  //[10:0]
    output reg  [31:0] o_rx_ch0_hv_val,                   //[15:0]
    output reg  [31:0] o_rx_ch0_tmpratu_val,              //[15:0]
    output reg  [31:0] o_rx_ch0_hv_switch_stat,           //[15:0]
    output reg  [31:0] o_rx_ch0_dly_val,                  //[32:0]
    output reg  [31:0] o_rx_ch0_10per_hv_val,             //[15:0]
    output reg  [31:0] o_rx_ch0_20per_hv_val,             //[15:0]
    output reg  [31:0] o_rx_ch0_dead_time,                //[15:0]
    output reg  [31:0] o_rx_ch0_tri_stat,                 //[15:0]
    output reg  [31:0] o_rx_ch0_det_effi_conf_val,        //[15:0]
    output reg  [31:0] o_rx_ch0_para_to_eeprom,           //[15:0]
    output reg  [31:0] o_rx_ch0_para_from_eeprom,         //[15:0]

    output reg  [31:0] o_rx_ch1_set_sel,                  //[10:0]
    output reg  [31:0] o_rx_ch1_hv_val,                   //[15:0]
    output reg  [31:0] o_rx_ch1_tmpratu_val,              //[15:0]
    output reg  [31:0] o_rx_ch1_hv_switch_stat,           //[15:0]
    output reg  [31:0] o_rx_ch1_dly_val,                  //[32:0]
    output reg  [31:0] o_rx_ch1_10per_hv_val,             //[15:0]
    output reg  [31:0] o_rx_ch1_20per_hv_val,             //[15:0]
    output reg  [31:0] o_rx_ch1_dead_time,                //[15:0]
    output reg  [31:0] o_rx_ch1_tri_stat,                 //[15:0]
    output reg  [31:0] o_rx_ch1_det_effi_conf_val,        //[15:0]
    output reg  [31:0] o_rx_ch1_para_to_eeprom,           //[15:0]
    output reg  [31:0] o_rx_ch1_para_from_eeprom          //[15:0]
);


reg [63:0] urt_rx_dat_reg;
reg urtrx_rd_dat_vld;
reg [19:0] urt_rd_req;

always@(posedge clk)
    if(rst) o_urtrx_rd_en <= 1'b0;
    else if(i_urtrx_rdy && !i_urtrx_empty)o_urtrx_rd_en <= 1'b1;
    else o_urtrx_rd_en <= 1'b0;

always@(posedge clk)
    if(rst) urtrx_rd_dat_vld <= 1'b0;
    else urtrx_rd_dat_vld <= o_urtrx_rd_en;

always@(posedge clk)
    if(rst) urt_rx_dat_reg <= 'h0;
    else if(urtrx_rd_dat_vld)  urt_rx_dat_reg <= {urt_rx_dat_reg[55:0],i_urtrx_rd_dat};
    else urt_rx_dat_reg <= urt_rx_dat_reg;

assign  o_rd_ch0_photon_val_req        = urt_rd_req[0 ];
assign  o_rd_ch0_hv_val_req            = urt_rd_req[1 ];
assign  o_rd_ch0_tmpratu_val_req       = urt_rd_req[2 ];
assign  o_rd_ch0_hv_switch_stat_req    = urt_rd_req[3 ];
assign  o_rd_ch0_dly_val_req           = urt_rd_req[4 ];
assign  o_rd_ch0_10per_hv_val_req      = urt_rd_req[5 ];
assign  o_rd_ch0_20per_hv_val_req      = urt_rd_req[6 ];
assign  o_rd_ch0_dead_time_req         = urt_rd_req[7 ];
assign  o_rd_ch0_tri_stat_req          = urt_rd_req[8 ];
assign  o_rd_ch0_det_effi_conf_val_req = urt_rd_req[9 ];

assign  o_rd_ch1_photon_val_req        = urt_rd_req[10];
assign  o_rd_ch1_hv_val_req            = urt_rd_req[11];
assign  o_rd_ch1_tmpratu_val_req       = urt_rd_req[12];
assign  o_rd_ch1_hv_switch_stat_req    = urt_rd_req[13];
assign  o_rd_ch1_dly_val_req           = urt_rd_req[14];
assign  o_rd_ch1_10per_hv_val_req      = urt_rd_req[15];
assign  o_rd_ch1_20per_hv_val_req      = urt_rd_req[16];
assign  o_rd_ch1_dead_time_req         = urt_rd_req[17];
assign  o_rd_ch1_tri_stat_req          = urt_rd_req[18];
assign  o_rd_ch1_det_effi_conf_val_req = urt_rd_req[19];

always@(posedge clk)
    if(rst)begin
        urt_rd_req <= 20'h00000;

        o_rx_ch0_set_sel           <='h0;
        o_rx_ch1_set_sel           <='h0;

        o_rx_ch0_hv_val            <='h0;
        o_rx_ch0_tmpratu_val       <='h0;
        o_rx_ch0_hv_switch_stat    <='h0;
        o_rx_ch0_dly_val           <='h0;
        o_rx_ch0_10per_hv_val      <='h0;
        o_rx_ch0_20per_hv_val      <='h0;
        o_rx_ch0_dead_time         <='h0;
        o_rx_ch0_tri_stat          <='h0;
        o_rx_ch0_det_effi_conf_val <='h0;
        o_rx_ch0_para_to_eeprom    <='h0;
        o_rx_ch0_para_from_eeprom  <='h0;

        o_rx_ch1_hv_val            <='h0;
        o_rx_ch1_tmpratu_val       <='h0;
        o_rx_ch1_hv_switch_stat    <='h0;
        o_rx_ch1_dly_val           <='h0;
        o_rx_ch1_10per_hv_val      <='h0;
        o_rx_ch1_20per_hv_val      <='h0;
        o_rx_ch1_dead_time         <='h0;
        o_rx_ch1_tri_stat          <='h0;
        o_rx_ch1_det_effi_conf_val <='h0;
        o_rx_ch1_para_to_eeprom    <='h0;
        o_rx_ch1_para_from_eeprom  <='h0;

   // end else if(urt_rx_dat_reg[63:40]==8'hA5A5A0)begin
	end else if(urt_rx_dat_reg[63:40]==8'hEB90A0)begin
        case(urt_rx_dat_reg[39:16])
            24'h00FFFF:  urt_rd_req <= 20'h0000_0000_0000_0000_0001;
            24'h01FFFF:  urt_rd_req <= 20'h0000_0000_0000_0000_0010;
            24'h02FFFF:  urt_rd_req <= 20'h0000_0000_0000_0000_0100;
            24'h03FFFF:  urt_rd_req <= 20'h0000_0000_0000_0000_1000;
            24'h04FFFF:  urt_rd_req <= 20'h0000_0000_0000_0001_0000;
            24'h05FFFF:  urt_rd_req <= 20'h0000_0000_0000_0010_0000;
            24'h06FFFF:  urt_rd_req <= 20'h0000_0000_0000_0100_0000;
            24'h07FFFF:  urt_rd_req <= 20'h0000_0000_0000_1000_0000;
            24'h08FFFF:  urt_rd_req <= 20'h0000_0000_0001_0000_0000;
            24'h09FFFF:  urt_rd_req <= 20'h0000_0000_0010_0000_0000;
            24'h10FFFF:  urt_rd_req <= 20'h0000_0000_0100_0000_0000;
            24'h11FFFF:  urt_rd_req <= 20'h0000_0000_1000_0000_0000;
            24'h12FFFF:  urt_rd_req <= 20'h0000_0001_0000_0000_0000;
            24'h13FFFF:  urt_rd_req <= 20'h0000_0010_0000_0000_0000;
            24'h14FFFF:  urt_rd_req <= 20'h0000_0100_0000_0000_0000;
            24'h15FFFF:  urt_rd_req <= 20'h0000_1000_0000_0000_0000;
            24'h16FFFF:  urt_rd_req <= 20'h0001_0000_0000_0000_0000;
            24'h17FFFF:  urt_rd_req <= 20'h0010_0000_0000_0000_0000;
            24'h18FFFF:  urt_rd_req <= 20'h0100_0000_0000_0000_0000;
            24'h19FFFF:  urt_rd_req <= 20'h1000_0000_0000_0000_0000;
            default   :  urt_rd_req <= 20'h0000_0000_0000_0000_0000;
        endcase

    //end else if(urt_rx_dat_reg[63:40]==8'hA5A5A1)begin
	 end else if(urt_rx_dat_reg[63:40]==8'hEB90A1)begin
        case(urt_rx_dat_reg[39:32])
            8'h01: begin o_rx_ch0_hv_val            <= urt_rx_dat_reg[31:0];
                         o_rx_ch0_set_sel           <= 11'b000_0000_0001;
                         o_rx_ch1_set_sel           <= 11'b000_0000_0000;
                   end
            8'h02: begin o_rx_ch0_tmpratu_val       <= urt_rx_dat_reg[31:0];
                         o_rx_ch0_set_sel           <= 11'b000_0000_0010;
                         o_rx_ch1_set_sel           <= 11'b000_0000_0000;
                   end
            8'h03: begin o_rx_ch0_hv_switch_stat    <= urt_rx_dat_reg[31:0];
                         o_rx_ch0_set_sel           <= 11'b000_0000_0100;
                         o_rx_ch1_set_sel           <= 11'b000_0000_0000;
                   end
            8'h04: begin o_rx_ch0_dly_val           <= urt_rx_dat_reg[31:0];
                         o_rx_ch0_set_sel           <= 11'b000_0000_1000;
                         o_rx_ch1_set_sel           <= 11'b000_0000_0000;
                   end
            8'h05: begin o_rx_ch0_10per_hv_val      <= urt_rx_dat_reg[31:0];
                         o_rx_ch0_set_sel           <= 11'b000_0001_0000;
                         o_rx_ch1_set_sel           <= 11'b000_0000_0000;
                   end
            8'h06: begin o_rx_ch0_20per_hv_val      <= urt_rx_dat_reg[31:0];
                         o_rx_ch0_set_sel           <= 11'b000_0010_0000;
                         o_rx_ch1_set_sel           <= 11'b000_0000_0000;
                   end
            8'h07: begin o_rx_ch0_dead_time         <= urt_rx_dat_reg[31:0];
                         o_rx_ch0_set_sel           <= 11'b000_0100_0000;
                         o_rx_ch1_set_sel           <= 11'b000_0000_0000;
                   end
            8'h08: begin o_rx_ch0_tri_stat          <= urt_rx_dat_reg[31:0];
                         o_rx_ch0_set_sel           <= 11'b000_1000_0000;
                         o_rx_ch1_set_sel           <= 11'b000_0000_0000;
                   end
            8'h09: begin o_rx_ch0_det_effi_conf_val <= urt_rx_dat_reg[31:0];
                         o_rx_ch0_set_sel           <= 11'b001_0000_0000;
                         o_rx_ch1_set_sel           <= 11'b000_0000_0000;
                   end
            8'h0A: begin o_rx_ch0_para_to_eeprom    <= urt_rx_dat_reg[31:0];
                         o_rx_ch0_set_sel           <= 11'b010_0000_0000;
                         o_rx_ch1_set_sel           <= 11'b000_0000_0000;
                   end
            8'h0B: begin o_rx_ch0_para_from_eeprom  <= urt_rx_dat_reg[31:0];
                         o_rx_ch0_set_sel           <= 11'b100_0000_0000;
                         o_rx_ch1_set_sel           <= 11'b000_0000_0000;
                   end

            8'h11: begin o_rx_ch1_hv_val            <= urt_rx_dat_reg[31:0];
                         o_rx_ch1_set_sel           <= 11'b000_0000_0001;
                         o_rx_ch0_set_sel           <= 11'b000_0000_0000;
                   end
            8'h12: begin o_rx_ch1_tmpratu_val       <= urt_rx_dat_reg[31:0];
                         o_rx_ch1_set_sel           <= 11'b000_0000_0010;
                         o_rx_ch0_set_sel           <= 11'b000_0000_0000;
                   end
            8'h13: begin o_rx_ch1_hv_switch_stat    <= urt_rx_dat_reg[31:0];
                         o_rx_ch1_set_sel           <= 11'b000_0000_0100;
                         o_rx_ch0_set_sel           <= 11'b000_0000_0000;
                   end
            8'h14: begin o_rx_ch1_dly_val           <= urt_rx_dat_reg[31:0];
                         o_rx_ch1_set_sel           <= 11'b000_0000_0100;
                         o_rx_ch0_set_sel           <= 11'b000_0000_0000;
                   end
            8'h15: begin o_rx_ch1_10per_hv_val      <= urt_rx_dat_reg[31:0];
                         o_rx_ch1_set_sel           <= 11'b000_0001_0000;
                         o_rx_ch0_set_sel           <= 11'b000_0000_0000;
                   end
            8'h16: begin o_rx_ch1_20per_hv_val      <= urt_rx_dat_reg[31:0];
                         o_rx_ch1_set_sel           <= 11'b000_0010_0000;
                         o_rx_ch0_set_sel           <= 11'b000_0000_0000;
                   end
            8'h17: begin o_rx_ch1_dead_time         <= urt_rx_dat_reg[31:0];
                         o_rx_ch1_set_sel           <= 11'b000_0100_0000;
                         o_rx_ch0_set_sel           <= 11'b000_0000_0000;
                   end
            8'h18: begin o_rx_ch1_tri_stat          <= urt_rx_dat_reg[31:0];
                         o_rx_ch1_set_sel           <= 11'b000_1000_0000;
                         o_rx_ch0_set_sel           <= 11'b000_0000_0000;
                   end
            8'h19: begin o_rx_ch1_det_effi_conf_val <= urt_rx_dat_reg[31:0];
                         o_rx_ch1_set_sel           <= 11'b001_0000_0000;
                         o_rx_ch0_set_sel           <= 11'b000_0000_0000;
                   end
            8'h1A: begin o_rx_ch1_para_to_eeprom    <= urt_rx_dat_reg[31:0];
                         o_rx_ch1_set_sel           <= 11'b010_0000_0000;
                         o_rx_ch0_set_sel           <= 11'b000_0000_0000;
                   end
            8'h1B: begin o_rx_ch1_para_from_eeprom  <= urt_rx_dat_reg[31:0];
                         o_rx_ch1_set_sel           <= 11'b100_0000_0000;
                         o_rx_ch0_set_sel           <= 11'b000_0000_0000;
                   end
            default:begin
                         o_rx_ch0_set_sel           <= 11'b000_0000_0000;
                         o_rx_ch1_set_sel           <= 11'b000_0000_0000;
                    end
        endcase

    end else begin

        urt_rd_req <= 20'h00000;
        o_rx_ch0_set_sel <= o_rx_ch0_set_sel;
        o_rx_ch1_set_sel <= o_rx_ch1_set_sel;

        o_rx_ch0_hv_val<=o_rx_ch0_hv_val;
        o_rx_ch0_tmpratu_val<=o_rx_ch0_tmpratu_val;
        o_rx_ch0_hv_switch_stat<=o_rx_ch0_hv_switch_stat;
        o_rx_ch0_dly_val<=o_rx_ch0_dly_val;
        o_rx_ch0_10per_hv_val<=o_rx_ch0_10per_hv_val;
        o_rx_ch0_20per_hv_val<=o_rx_ch0_20per_hv_val;
        o_rx_ch0_dead_time<=o_rx_ch0_dead_time;
        o_rx_ch0_tri_stat<=o_rx_ch0_tri_stat;
        o_rx_ch0_det_effi_conf_val<=o_rx_ch0_det_effi_conf_val;
        o_rx_ch0_para_to_eeprom<=o_rx_ch0_para_to_eeprom;
        o_rx_ch0_para_from_eeprom<=o_rx_ch0_para_from_eeprom;

        o_rx_ch1_hv_val<=o_rx_ch1_hv_val;
        o_rx_ch1_tmpratu_val<=o_rx_ch1_tmpratu_val;
        o_rx_ch1_hv_switch_stat<=o_rx_ch1_hv_switch_stat;
        o_rx_ch1_dly_val<=o_rx_ch1_dly_val;
        o_rx_ch1_10per_hv_val<=o_rx_ch1_10per_hv_val;
        o_rx_ch1_20per_hv_val<=o_rx_ch1_20per_hv_val;
        o_rx_ch1_dead_time<=o_rx_ch1_dead_time;
        o_rx_ch1_tri_stat<=o_rx_ch1_tri_stat;
        o_rx_ch1_det_effi_conf_val<=o_rx_ch1_det_effi_conf_val;
        o_rx_ch1_para_to_eeprom<=o_rx_ch1_para_to_eeprom;
        o_rx_ch1_para_from_eeprom<=o_rx_ch1_para_from_eeprom;
    end
endmodule

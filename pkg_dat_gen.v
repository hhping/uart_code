 `timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:QTEC
// Engineer:
//
// Create Date:    09:28:18 19/07/2018
// Design Name:
// Module Name:    pkg_dat_gen
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
module pkg_dat_gen
(
    input wire        clk                  ,
    input wire        rst                  ,

    input wire [19:0] i_data_gen_label      ,
    input wire [00:0] i_tx_busy             ,

    output reg [00:0] o_tx_start            ,
    output reg [32:0] o_tx_data             ,
    output reg [00:0] o_tx_data_vld         ,

    input wire [31:0] i_tx_ch0_photon_val       ,    //[31:0]
    input wire [31:0] i_tx_ch0_hv_val           ,    //[15:0]
    input wire [31:0] i_tx_ch0_tmpratu_val      ,    //[11:0]
    input wire [31:0] i_tx_ch0_hv_switch_stat   ,    //[00:0]
    input wire [31:0] i_tx_ch0_dly_val          ,    //[24:0]
    input wire [31:0] i_tx_ch0_10per_hv_val     ,    //[15:0]
    input wire [31:0] i_tx_ch0_20per_hv_val     ,    //[15:0]
    input wire [31:0] i_tx_ch0_dead_time        ,    //[15:0]
    input wire [31:0] i_tx_ch0_tri_stat         ,    //[15:0]
    input wire [31:0] i_tx_ch0_det_effi_conf_val,    //[00:0]

    input wire [31:0] i_tx_ch1_photon_val       ,    //[31:0]
    input wire [31:0] i_tx_ch1_hv_val           ,    //[15:0]
    input wire [31:0] i_tx_ch1_tmpratu_val      ,    //[11:0]
    input wire [31:0] i_tx_ch1_hv_switch_stat   ,    //[00:0]
    input wire [31:0] i_tx_ch1_dly_val          ,    //[24:0]
    input wire [31:0] i_tx_ch1_10per_hv_val     ,    //[15:0]
    input wire [31:0] i_tx_ch1_20per_hv_val     ,    //[15:0]
    input wire [31:0] i_tx_ch1_dead_time        ,    //[15:0]
    input wire [31:0] i_tx_ch1_tri_stat         ,    //[15:0]
    input wire [31:0] i_tx_ch1_det_effi_conf_val     //[00:0]
);



always@(posedge clk)
    if(rst) begin
        o_tx_start <= 1'b0;
        o_tx_data <= 32'h0;
        o_tx_data_vld <= 1'b0;
    end else if(!i_tx_busy)begin
        case(i_data_gen_label)
            20'b1000_0000_0000_0000_0000:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch0_photon_val;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0100_0000_0000_0000_0000:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch0_hv_val;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0010_0000_0000_0000_0000:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch0_tmpratu_val;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0001_0000_0000_0000_0000:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch0_hv_switch_stat;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0000_1000_0000_0000_0000:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch0_dly_val;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0000_0100_0000_0000_0000:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch0_10per_hv_val;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0000_0010_0000_0000_0000:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch0_20per_hv_val;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0000_0001_0000_0000_0000:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch0_dead_time;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0000_0000_1000_0000_0000:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch0_tri_stat;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0000_0000_0100_0000_0000:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch0_det_effi_conf_val;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0000_0000_0010_0000_0000:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch1_photon_val;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0000_0000_0001_0000_0000:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch1_hv_val;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0000_0000_0000_1000_0000:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch1_tmpratu_val;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0000_0000_0000_0100_0000:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch1_hv_switch_stat;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0000_0000_0000_0010_0000:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch1_dly_val;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0000_0000_0000_0001_0000:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch1_10per_hv_val;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0000_0000_0000_0000_1000:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch1_20per_hv_val;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0000_0000_0000_0000_0100:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch1_dead_time;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0000_0000_0000_0000_0010:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch1_tri_stat;
                    o_tx_data_vld <= 1'b1;
                end

            20'b0000_0000_0000_0000_0001:
                begin
                    o_tx_start <= 1'b1;
                    o_tx_data <= i_tx_ch1_det_effi_conf_val;
                    o_tx_data_vld <= 1'b1;
                end

             default:
                begin
                    o_tx_start <= 1'b0;
                    o_tx_data <= 32'h0;
                    o_tx_data_vld <= 1'b0;
                end
        endcase
    end else begin
        o_tx_start <= 1'b0;
        o_tx_data <= 32'h0;
        o_tx_data_vld <= 1'b0;
    end


endmodule
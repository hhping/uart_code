 `timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:QTEC
// Engineer:
//
// Create Date:    09:28:18 19/07/2018
// Design Name:
// Module Name:    urt_tx_pkg_gen
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
module urt_tx_pkg_gen
#(
    parameter SYN_CODE = 16'hACAC,
    parameter COMMAND  =  8'hA0

)
(
    input wire        clk                        ,
    input wire        rst                        ,

    input  wire       i_urttx_rd_en              ,
    output wire       o_urttx_alempty            ,
    output wire       o_urttx_empty              ,
    output wire [7:0] o_urttx_rd_dat             ,

    input wire        i_rd_ch0_photon_val_req        ,
    input wire        i_rd_ch0_hv_val_req            ,
    input wire        i_rd_ch0_tmpratu_val_req       ,
    input wire        i_rd_ch0_hv_switch_stat_req    ,
    input wire        i_rd_ch0_dly_val_req           ,
    input wire        i_rd_ch0_10per_hv_val_req      ,
    input wire        i_rd_ch0_20per_hv_val_req      ,
    input wire        i_rd_ch0_dead_time_req         ,
    input wire        i_rd_ch0_tri_stat_req          ,
    input wire        i_rd_ch0_det_effi_conf_val_req ,

    input wire        i_rd_ch1_photon_val_req        ,
    input wire        i_rd_ch1_hv_val_req            ,
    input wire        i_rd_ch1_tmpratu_val_req       ,
    input wire        i_rd_ch1_hv_switch_stat_req    ,
    input wire        i_rd_ch1_dly_val_req           ,
    input wire        i_rd_ch1_10per_hv_val_req      ,
    input wire        i_rd_ch1_20per_hv_val_req      ,
    input wire        i_rd_ch1_dead_time_req         ,
    input wire        i_rd_ch1_tri_stat_req          ,
    input wire        i_rd_ch1_det_effi_conf_val_req ,

    input wire [31:0] i_tx_ch0_photon_val           ,  //[31:0]
    input wire [31:0] i_tx_ch0_hv_val               ,  //[15:0]
    input wire [31:0] i_tx_ch0_tmpratu_val          ,  //[11:0]
    input wire [31:0] i_tx_ch0_hv_switch_stat       ,  //[00:0]
    input wire [31:0] i_tx_ch0_dly_val              ,  //[24:0]
    input wire [31:0] i_tx_ch0_10per_hv_val         ,  //[15:0]
    input wire [31:0] i_tx_ch0_20per_hv_val         ,  //[15:0]
    input wire [31:0] i_tx_ch0_dead_time            ,  //[15:0]
    input wire [31:0] i_tx_ch0_tri_stat             ,  //[15:0]
    input wire [31:0] i_tx_ch0_det_effi_conf_val    ,  //[00:0]

    input wire [31:0] i_tx_ch1_photon_val           ,  //[31:0]
    input wire [31:0] i_tx_ch1_hv_val               ,  //[15:0]
    input wire [31:0] i_tx_ch1_tmpratu_val          ,  //[11:0]
    input wire [31:0] i_tx_ch1_hv_switch_stat       ,  //[00:0]
    input wire [31:0] i_tx_ch1_dly_val              ,  //[24:0]
    input wire [31:0] i_tx_ch1_10per_hv_val         ,  //[15:0]
    input wire [31:0] i_tx_ch1_20per_hv_val         ,  //[15:0]
    input wire [31:0] i_tx_ch1_dead_time            ,  //[15:0]
    input wire [31:0] i_tx_ch1_tri_stat             ,  //[15:0]
    input wire [31:0] i_tx_ch1_det_effi_conf_val       //[00:0]
);

wire rd_ch0_photon_val       ;
wire rd_ch0_hv_val           ;
wire rd_ch0_tmpratu_val      ;
wire rd_ch0_hv_switch_stat   ;
wire rd_ch0_dly_val          ;
wire rd_ch0_10per_hv_val     ;
wire rd_ch0_20per_hv_val     ;
wire rd_ch0_dead_time        ;
wire rd_ch0_tri_stat         ;
wire rd_ch0_det_effi_conf_val;
wire rd_ch1_photon_val     ;
wire rd_ch1_hv_val           ;
wire rd_ch1_tmpratu_val      ;
wire rd_ch1_hv_switch_stat   ;
wire rd_ch1_dly_val          ;
wire rd_ch1_10per_hv_val     ;
wire rd_ch1_20per_hv_val     ;
wire rd_ch1_dead_time        ;
wire rd_ch1_tri_stat         ;
wire rd_ch1_det_effi_conf_val;

wire tx_start,tx_data_vld;
wire [31:0]tx_data;
wire tx_busy;
wire [19:0] tx_start_tmp;

assign tx_start_tmp = {rd_ch0_photon_val,rd_ch0_hv_val,rd_ch0_tmpratu_val,rd_ch0_hv_switch_stat,
                       rd_ch0_dly_val,rd_ch0_10per_hv_val,rd_ch0_20per_hv_val,rd_ch0_dead_time,
                       rd_ch0_tri_stat,rd_ch0_det_effi_conf_val,rd_ch1_photon_val,rd_ch1_hv_val,
                       rd_ch1_tmpratu_val,rd_ch1_hv_switch_stat,rd_ch1_dly_val,rd_ch1_10per_hv_val,
                       rd_ch1_20per_hv_val,rd_ch1_dead_time,rd_ch1_tri_stat,rd_ch1_det_effi_conf_val};

pkg_dat_gen pkg_dat_gen_inst
(
    .clk                             (clk                        ),
    .rst                             (rst                        ),

    .i_data_gen_label                (tx_start_tmp               ),
    .i_tx_busy                       (tx_busy                    ),
    .o_tx_start                      (tx_start                   ),
    .o_tx_data                       (tx_start                   ),
    .o_tx_data_vld                   (tx_data_vld                ),

    .i_tx_ch0_photon_val             (i_tx_ch0_photon_val        ),
    .i_tx_ch0_hv_val                 (i_tx_ch0_hv_val            ),
    .i_tx_ch0_tmpratu_val            (i_tx_ch0_tmpratu_val       ),
    .i_tx_ch0_hv_switch_stat         (i_tx_ch0_hv_switch_stat    ),
    .i_tx_ch0_dly_val                (i_tx_ch0_dly_val           ),
    .i_tx_ch0_10per_hv_val           (i_tx_ch0_10per_hv_val      ),
    .i_tx_ch0_20per_hv_val           (i_tx_ch0_20per_hv_val      ),
    .i_tx_ch0_dead_time              (i_tx_ch0_dead_time         ),
    .i_tx_ch0_tri_stat               (i_tx_ch0_tri_stat          ),
    .i_tx_ch0_det_effi_conf_val      (i_tx_ch0_det_effi_conf_val ),

    .i_tx_ch1_photon_val             (i_tx_ch1_photon_val        ),
    .i_tx_ch1_hv_val                 (i_tx_ch1_hv_val            ),
    .i_tx_ch1_tmpratu_val            (i_tx_ch1_tmpratu_val       ),
    .i_tx_ch1_hv_switch_stat         (i_tx_ch1_hv_switch_stat    ),
    .i_tx_ch1_dly_val                (i_tx_ch1_dly_val           ),
    .i_tx_ch1_10per_hv_val           (i_tx_ch1_10per_hv_val      ),
    .i_tx_ch1_20per_hv_val           (i_tx_ch1_20per_hv_val      ),
    .i_tx_ch1_dead_time              (i_tx_ch1_dead_time         ),
    .i_tx_ch1_tri_stat               (i_tx_ch1_tri_stat          ),
    .i_tx_ch1_det_effi_conf_val      (i_tx_ch1_det_effi_conf_val )

);

pkg_gen pkg_gen_inst
(
    .clk                             (clk ),
    .rst                             (rst ),

    .i_tx_start                      (tx_start),
    .i_tx_data                       (tx_data),
    .i_tx_data_vld                   (tx_data_vld),
    .o_tx_busy                       (tx_busy),

    .o_urttx_alempty                 (urttx_alempty ),
    .o_urttx_empty                   (urttx_empty   ),
    .o_urttx_rd_dat                  (urttx_rd_dat  ),
);

edge_detct i00( .rst(rst), .clk(clk), .i(i_rd_ch0_photon_val_req       ), .rise(rd_ch0_photon_val       ) );
edge_detct i01( .rst(rst), .clk(clk), .i(i_rd_ch0_hv_val_req           ), .rise(rd_ch0_hv_val           ) );
edge_detct i02( .rst(rst), .clk(clk), .i(i_rd_ch0_tmpratu_val_req      ), .rise(rd_ch0_tmpratu_val      ) );
edge_detct i03( .rst(rst), .clk(clk), .i(i_rd_ch0_hv_switch_stat_req   ), .rise(rd_ch0_hv_switch_stat   ) );
edge_detct i04( .rst(rst), .clk(clk), .i(i_rd_ch0_dly_val_req          ), .rise(rd_ch0_dly_val          ) );
edge_detct i05( .rst(rst), .clk(clk), .i(i_rd_ch0_10per_hv_val_req     ), .rise(rd_ch0_10per_hv_val     ) );
edge_detct i06( .rst(rst), .clk(clk), .i(i_rd_ch0_20per_hv_val_req     ), .rise(rd_ch0_20per_hv_val     ) );
edge_detct i07( .rst(rst), .clk(clk), .i(i_rd_ch0_dead_time_req        ), .rise(rd_ch0_dead_time        ) );
edge_detct i08( .rst(rst), .clk(clk), .i(i_rd_ch0_tri_stat_req         ), .rise(rd_ch0_tri_stat         ) );
edge_detct i09( .rst(rst), .clk(clk), .i(i_rd_ch0_det_effi_conf_val_req), .rise(rd_ch0_det_effi_conf_val) );
edge_detct i10( .rst(rst), .clk(clk), .i(i_rd_ch1_photon_val_req       ), .rise(rd_ch1_photon_val       ) );
edge_detct i11( .rst(rst), .clk(clk), .i(i_rd_ch1_hv_val_req           ), .rise(rd_ch1_hv_val           ) );
edge_detct i12( .rst(rst), .clk(clk), .i(i_rd_ch1_tmpratu_val_req      ), .rise(rd_ch1_tmpratu_val      ) );
edge_detct i13( .rst(rst), .clk(clk), .i(i_rd_ch1_hv_switch_stat_req   ), .rise(rd_ch1_hv_switch_stat   ) );
edge_detct i14( .rst(rst), .clk(clk), .i(i_rd_ch1_dly_val_req          ), .rise(rd_ch1_dly_val          ) );
edge_detct i15( .rst(rst), .clk(clk), .i(i_rd_ch1_10per_hv_val_req     ), .rise(rd_ch1_10per_hv_val     ) );
edge_detct i16( .rst(rst), .clk(clk), .i(i_rd_ch1_20per_hv_val_req     ), .rise(rd_ch1_20per_hv_val     ) );
edge_detct i17( .rst(rst), .clk(clk), .i(i_rd_ch1_dead_time_req        ), .rise(rd_ch1_dead_time        ) );
edge_detct i18( .rst(rst), .clk(clk), .i(i_rd_ch1_tri_stat_req         ), .rise(rd_ch1_tri_stat         ) );
edge_detct i19( .rst(rst), .clk(clk), .i(i_rd_ch1_det_effi_conf_val_req), .rise(rd_ch1_det_effi_conf_val) );


endmodule
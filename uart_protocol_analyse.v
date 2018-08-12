 `timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:QTEC
// Engineer:
//
// Create Date:    09:28:18 19/07/2018
// Design Name:
// Module Name:    uart_protocol_analyse
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

module uart_protocol_analyse
(
    input  wire        clk_100m                   ,
    input  wire        rst_100m                   ,

    input  wire        urt_rxd_in                 ,
    output wire        urt_txd_out                ,

    input  wire        down_stream_rdy            ,

    output wire [10:0] o_rx_ch0_set_sel           ,
    output wire [15:0] o_rx_ch0_hv_val            ,//o_rx_ch0_set_sel[0]
    output wire [15:0] o_rx_ch0_tmpratu_val       ,
    output wire [15:0] o_rx_ch0_hv_switch_stat    ,
    output wire [32:0] o_rx_ch0_dly_val           ,
    output wire [15:0] o_rx_ch0_10per_hv_val      ,
    output wire [15:0] o_rx_ch0_20per_hv_val      ,
    output wire [15:0] o_rx_ch0_dead_time         ,
    output wire [15:0] o_rx_ch0_tri_stat          ,
    output wire [15:0] o_rx_ch0_det_effi_conf_val ,
    output wire [15:0] o_rx_ch0_para_to_eeprom    ,
    output wire [15:0] o_rx_ch0_para_from_eeprom  ,

    output wire [10:0] o_rx_ch1_set_sel           ,
    output wire [15:0] o_rx_ch1_hv_val            ,
    output wire [15:0] o_rx_ch1_tmpratu_val       ,
    output wire [15:0] o_rx_ch1_hv_switch_stat    ,
    output wire [32:0] o_rx_ch1_dly_val           ,
    output wire [15:0] o_rx_ch1_10per_hv_val      ,
    output wire [15:0] o_rx_ch1_20per_hv_val      ,
    output wire [15:0] o_rx_ch1_dead_time         ,
    output wire [15:0] o_rx_ch1_tri_stat          ,
    output wire [15:0] o_rx_ch1_det_effi_conf_val ,
    output wire [15:0] o_rx_ch1_para_to_eeprom    ,
    output wire [15:0] o_rx_ch1_para_from_eeprom  ,

    input  wire [32:0] i_tx_ch0_photon_val        ,
    input  wire [15:0] i_tx_ch0_hv_val            ,
    input  wire [11:0] i_tx_ch0_tmpratu_val       ,
    input  wire [00:0] i_tx_ch0_hv_switch_stat    ,
    input  wire [24:0] i_tx_ch0_dly_val           ,
    input  wire [15:0] i_tx_ch0_10per_hv_val      ,
    input  wire [15:0] i_tx_ch0_20per_hv_val      ,
    input  wire [15:0] i_tx_ch0_dead_time         ,
    input  wire [15:0] i_tx_ch0_tri_stat          ,
    input  wire [00:0] i_tx_ch0_det_effi_conf_val ,
                         
    input  wire [31:0] i_tx_ch1_photon_val        ,
    input  wire [15:0] i_tx_ch1_hv_val            ,
    input  wire [11:0] i_tx_ch1_tmpratu_val       ,
    input  wire [00:0] i_tx_ch1_hv_switch_stat    ,
    input  wire [24:0] i_tx_ch1_dly_val           ,
    input  wire [15:0] i_tx_ch1_10per_hv_val      ,
    input  wire [15:0] i_tx_ch1_20per_hv_val      ,
    input  wire [15:0] i_tx_ch1_dead_time         ,
    input  wire [15:0] i_tx_ch1_tri_stat          ,
    input  wire [00:0] i_tx_ch1_det_effi_conf_val

);

/*
 *urt recv signal define,
 */
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

wire rd_ch1_photon_val       ;
wire rd_ch1_hv_val           ;
wire rd_ch1_tmpratu_val      ;
wire rd_ch1_hv_switch_stat   ;
wire rd_ch1_dly_val          ;
wire rd_ch1_10per_hv_val     ;
wire rd_ch1_20per_hv_val     ;
wire rd_ch1_dead_time        ;
wire rd_ch1_tri_stat         ;
wire rd_ch1_det_effi_conf_val;


/*
 * uart phy port
 */
wire urttx_rd_en,urttx_alempty,urttx_empty;
wire urtrx_rd_en,urtrx_alempty,urtrx_empty;
wire [7:0] urttx_rd_dat,urtrx_rd_dat;

wire urtrx_rdy;

urt_top fpga_ccm_urt_top
(
    .clk_100m                   ( clk_100m       ),
    .rst_100m                   ( rst_100m       ),

    .urt_rxd_in                 ( urt_rxd_in     ),//input
    .urt_txd_out                ( urt_txd_out    ),

    .urttx_rd_en                ( urttx_rd_en    ),//output
    .urttx_alempty              ( urttx_alempty  ),//input from fpga_ccm_sch_urt
    .urttx_empty                ( urttx_empty    ),//input
    .urttx_rd_dat               ( urttx_rd_dat   ),//input

    .urtrx_rd_en                ( urtrx_rd_en    ),//input
    .urtrx_rd_dat               ( urtrx_rd_dat   ),//output [7:0] to fpga_urt_sch_ccm
    .urtrx_empty                ( urtrx_empty    ),//output
    .urtrx_alempty              ( urtrx_alempty  ),//output

    .urt_rxtx_dbg0              ( urt_rxtx_dbg0  )
);

/*
 *cp shorten for command package;
 *below item 'rd' means fpga recv uart read command.and fpga need send a package back to uart
 *below item 'wr' means fpga recv uart write command & corresponding parameter,then fpga should set device
 *according the parameter
 */
urt_rx_analy  urt_rx_analy_inst
(
    .clk                             (clk_100m                  ),
    .rst                             (rst_100m                  ),

    .o_urtrx_rd_en                   (urtrx_rd_en               ),
    .i_urtrx_rd_dat                  (urtrx_rd_dat              ),
    .i_urtrx_empty                   (urtrx_empty               ),
    .i_urtrx_rdy                     (urtrx_rdy                 ),

    .o_rd_ch0_photon_val_req         (rd_ch0_photon_val         ),
    .o_rd_ch0_hv_val_req             (rd_ch0_hv_val             ),
    .o_rd_ch0_tmpratu_val_req        (rd_ch0_tmpratu_val        ),
    .o_rd_ch0_hv_switch_stat_req     (rd_ch0_hv_switch_stat     ),
    .o_rd_ch0_dly_val_req            (rd_ch0_dly_val            ),
    .o_rd_ch0_10per_hv_val_req       (rd_ch0_10per_hv_val       ),
    .o_rd_ch0_20per_hv_val_req       (rd_ch0_20per_hv_val       ),
    .o_rd_ch0_dead_time_req          (rd_ch0_dead_time          ),
    .o_rd_ch0_tri_stat_req           (rd_ch0_tri_stat           ),
    .o_rd_ch0_det_effi_conf_val_req  (rd_ch0_det_effi_conf_val  ),

    .o_rd_ch1_photon_val_req         (rd_ch1_photon_val         ),
    .o_rd_ch1_hv_val_req             (rd_ch1_hv_val             ),
    .o_rd_ch1_tmpratu_val_req        (rd_ch1_tmpratu_val        ),
    .o_rd_ch1_hv_switch_stat_req     (rd_ch1_hv_switch_stat     ),
    .o_rd_ch1_dly_val_req            (rd_ch1_dly_val            ),
    .o_rd_ch1_10per_hv_val_req       (rd_ch1_10per_hv_val       ),
    .o_rd_ch1_20per_hv_val_req       (rd_ch1_20per_hv_val       ),
    .o_rd_ch1_dead_time_req          (rd_ch1_dead_time          ),
    .o_rd_ch1_tri_stat_req           (rd_ch1_tri_stat           ),
    .o_rd_ch1_det_effi_conf_val_req  (rd_ch1_det_effi_conf_val  ),

   
    .o_rx_ch0_set_sel                (o_rx_ch0_set_sel          ),
    .o_rx_ch0_hv_val                 (o_rx_ch0_hv_val           ),//o_rx_ch0_set_sel[0]
    .o_rx_ch0_tmpratu_val            (o_rx_ch0_tmpratu_val      ),
    .o_rx_ch0_hv_switch_stat         (o_rx_ch0_hv_switch_stat   ),
    .o_rx_ch0_dly_val                (o_rx_ch0_dly_val          ),
    .o_rx_ch0_10per_hv_val           (o_rx_ch0_10per_hv_val     ),
    .o_rx_ch0_20per_hv_val           (o_rx_ch0_20per_hv_val     ),
    .o_rx_ch0_dead_time              (o_rx_ch0_dead_time        ),
    .o_rx_ch0_tri_stat               (o_rx_ch0_tri_stat         ),
    .o_rx_ch0_det_effi_conf_val      (o_rx_ch0_det_effi_conf_val),
    .o_rx_ch0_para_to_eeprom         (o_rx_ch0_para_to_eeprom   ),
    .o_rx_ch0_para_from_eeprom       (o_rx_ch0_para_from_eeprom ),//o_rx_ch0_set_sel[10]

    .o_rx_ch1_set_sel                (o_rx_ch1_set_sel          ),
    .o_rx_ch1_hv_val                 (o_rx_ch1_hv_val           ),
    .o_rx_ch1_tmpratu_val            (o_rx_ch1_tmpratu_val      ),
    .o_rx_ch1_hv_switch_stat         (o_rx_ch1_hv_switch_stat   ),
    .o_rx_ch1_dly_val                (o_rx_ch1_dly_val          ),
    .o_rx_ch1_10per_hv_val           (o_rx_ch1_10per_hv_val     ),
    .o_rx_ch1_20per_hv_val           (o_rx_ch1_20per_hv_val     ),
    .o_rx_ch1_dead_time              (o_rx_ch1_dead_time        ),
    .o_rx_ch1_tri_stat               (o_rx_ch1_tri_stat         ),
    .o_rx_ch1_det_effi_conf_val      (o_rx_ch1_det_effi_conf_val),
    .o_rx_ch1_para_to_eeprom         (o_rx_ch1_para_to_eeprom   ),
    .o_rx_ch1_para_from_eeprom       (o_rx_ch1_para_from_eeprom ),
);

urt_tx_pkg_gen
#(
    .SYN_CODE                       (16'hACAC                ),
    .COMMAND                        (8'hA0                   )
)
urt_tx_pkg_gen_inst
(
    .clk                             (clk_100m                ),
    .rst                             (rst_100m                ),

    .i_urttx_rd_en                   (urttx_rd_en             ),
    .o_urttx_alempty                 (urttx_alempty           ),
    .o_urttx_empty                   (urttx_empty             ),
    .o_urttx_rd_dat                  (urttx_rd_dat            ),

    .i_rd_ch0_photon_val_req         (rd_ch0_photon_val       ),
    .i_rd_ch0_hv_val_req             (rd_ch0_hv_val           ),
    .i_rd_ch0_tmpratu_val_req        (rd_ch0_tmpratu_val      ),
    .i_rd_ch0_hv_switch_stat_req     (rd_ch0_hv_switch_stat   ),
    .i_rd_ch0_dly_val_req            (rd_ch0_dly_val          ),
    .i_rd_ch0_10per_hv_val_req       (rd_ch0_10per_hv_val     ),
    .i_rd_ch0_20per_hv_val_req       (rd_ch0_20per_hv_val     ),
    .i_rd_ch0_dead_time_req          (rd_ch0_dead_time        ),
    .i_rd_ch0_tri_stat_req           (rd_ch0_tri_stat         ),
    .i_rd_ch0_det_effi_conf_val_req  (rd_ch0_det_effi_conf_val),

    .i_rd_ch1_photon_val_req         (rd_ch1_photon_val       ),
    .i_rd_ch1_hv_val_req             (rd_ch1_hv_val           ),
    .i_rd_ch1_tmpratu_val_req        (rd_ch1_tmpratu_val      ),
    .i_rd_ch1_hv_switch_stat_req     (rd_ch1_hv_switch_stat   ),
    .i_rd_ch1_dly_val_req            (rd_ch1_dly_val          ),
    .i_rd_ch1_10per_hv_val_req       (rd_ch1_10per_hv_val     ),
    .i_rd_ch1_20per_hv_val_req       (rd_ch1_20per_hv_val     ),
    .i_rd_ch1_dead_time_req          (rd_ch1_dead_time        ),
    .i_rd_ch1_tri_stat_req           (rd_ch1_tri_stat         ),
    .i_rd_ch1_det_effi_conf_val_req  (rd_ch1_det_effi_conf_val),
                                    
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

endmodule
 `timescale 1ns / 1ns                                                               
//////////////////////////////////////////////////////////////////////////////////  
// Company:                                                                         
// Engineer:                                                                        
//                                                                                  
// Create Date:    09:28:18 19/07/2018                                              
// Design Name:                                                                     
// Module Name:    urt_top                                                       
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
module urt_top
(
    clk_100m,
    rst_100m,

    urt_rxd_in,
    urtrx_rd_en,
    urttx_alempty,
    urttx_empty,
    urttx_rd_dat,

    urtrx_rd_dat,
    urtrx_empty,
    urtrx_alempty,
    urttx_rd_en,
    urt_txd_out,

    urt_rxtx_dbg0
);
/******************************************************\
    parameter
\******************************************************/
parameter       U_DLY                   = 1;
/******************************************************\
    ports
\******************************************************/
input                       clk_100m;
input                       rst_100m;

input                       urt_rxd_in;
input                       urtrx_rd_en;
input                       urttx_alempty;
input                       urttx_empty;
input   [7:0]               urttx_rd_dat;

output  [7:0]               urtrx_rd_dat;
output                      urtrx_empty;
output                      urtrx_alempty;
output                      urttx_rd_en;
output                      urt_txd_out;

output  [31:0]              urt_rxtx_dbg0;
/******************************************************\
    signal
\******************************************************/
//reg output

//reg inside

//wire
/******************************************************\
    assign
\******************************************************/

/******************************************************\
    main
\******************************************************/
urt_rx u_urt_rx
    (
    .clk_100m                   ( clk_100m                     ),       //232ϵͳʱ��
    .rst_100m                   ( rst_100m                     ),       //232ϵͳ��λ

    .urt_rxd_in                 ( urt_rxd_in                   ),       //232 rx pin
    .urtrx_rd_en                ( urtrx_rd_en                  ),

    .urtrx_rd_dat               ( urtrx_rd_dat                 ),
    .urtrx_empty                ( urtrx_empty                  ),
    .urtrx_alempty              ( urtrx_alempty                ),
    .urt_rx_dbg                 ( urt_rxtx_dbg0[31:16]         )
    );

urt_tx u_urt_tx
    (
    .clk_100m                   ( clk_100m                      ),
    .rst_100m                   ( rst_100m                      ),
    .urttx_alempty              ( urttx_alempty                 ),
    .urttx_empty                ( urttx_empty                   ),
    .urttx_rd_dat               ( urttx_rd_dat                  ),
    //out
    .urttx_rd_en                ( urttx_rd_en                   ),
    .urt_txd_out                ( urt_txd_out                   ),
    .urt_tx_dbg                 ( urt_rxtx_dbg0[15:0]           )
    );

endmodule

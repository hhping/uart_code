 `timescale 1ns / 1ns                                                               
//////////////////////////////////////////////////////////////////////////////////  
// Company:                                                                         
// Engineer:                                                                        
//                                                                                  
// Create Date:    09:28:18 19/07/2018                                              
// Design Name:                                                                     
// Module Name:    urt_tx                                                       
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
`timescale 1ns/1ps
module urt_tx
    (
    clk_100m,
    rst_100m,
    urttx_alempty,
    urttx_empty,
    urttx_rd_dat,
    //out
    urttx_rd_en,
    urt_txd_out,
    urt_tx_dbg
    );
/******************************************************\
    parameter
\******************************************************/
parameter       U_DLY                   = 1;
parameter       FSM_TX_IDE            	= 2'b00;
parameter       FSM_TX_HEAD             = 2'b01;
parameter       FSM_TX_DATA             = 2'b10;
parameter       FSM_TX_END             	= 2'b11;

parameter       CLK_FREQ            	= 100000000;        //100M
parameter       BAUD_RATE              	= 19200;            //19200
parameter       BAUD_RATE_16X           = BAUD_RATE<<4;  	//16x
parameter       BAUD_ACC_WID  	 		= 16;               //65536
parameter       BAUD_GEN_16X_INC        = ((BAUD_RATE_16X<<(BAUD_ACC_WID - 4))+(CLK_FREQ>>5))/(CLK_FREQ>>4);
/******************************************************\
    ports
\******************************************************/
input                       clk_100m;
input                       rst_100m;

input                       urttx_alempty;
input                       urttx_empty;
input   [7:0]               urttx_rd_dat;

output                      urttx_rd_en;
output                      urt_txd_out;                    // �����˿ڷ��͵Ĵ�������
output	[15:0]				urt_tx_dbg;
/******************************************************\
    signal
\******************************************************/
//reg output
reg                         urttx_rd_en;
reg                         urt_txd_out;                    // �����˿ڷ��͵Ĵ�������
//reg inside

reg     [1:0]               fsm_sta;
reg     [7:0]               txd_data_r;
reg     [2:0]               bit_cnt;
reg     [3:0]               baud16x_cnt;
reg     [BAUD_ACC_WID:0]   baud_16x_acc;
reg		[3:0]				uart_tx_cnt;
//wire
wire                        baud16xtick;       //9600*16
/******************************************************\
    assign
\******************************************************/
assign  baud16xtick    = baud_16x_acc[BAUD_ACC_WID];
assign  urt_tx_dbg	= {8'd0,uart_tx_cnt[3:0],2'd0,fsm_sta[1:0]};
/******************************************************\
    main
\******************************************************/
//����һ��16���ı�����ʱ��
always @ (posedge clk_100m or posedge rst_100m)
begin
    if(rst_100m == 1'b1)
    begin
        baud_16x_acc    <= 17'd0;
    end
    else
    begin
        baud_16x_acc    <= #U_DLY baud_16x_acc[BAUD_ACC_WID - 1:0] + BAUD_GEN_16X_INC;	//can't delete -1
    end
end

always @ (posedge clk_100m or posedge rst_100m)
begin
    if(rst_100m == 1'b1)
    begin
        urt_txd_out             <= 1'b1;
        bit_cnt                 <= 3'd0;
        urttx_rd_en       <= 1'b0;
        txd_data_r[7:0]         <= 8'd0;
        uart_tx_cnt				<= 4'd0;
        baud16x_cnt				<= 4'd0;
        fsm_sta                 <= FSM_TX_IDE;
    end
    else
    begin 
        if(baud16xtick == 1'b1)
        begin
            case(fsm_sta)
                FSM_TX_IDE:
                begin
                    urt_txd_out             <= #U_DLY 1'b1;
                    bit_cnt                 <= #U_DLY 3'd0;
                    baud16x_cnt				<= #U_DLY 4'd0;
                    urttx_rd_en             <= #U_DLY (~urttx_empty);
                    //txd_data_r[7:0]         <= #U_DLY urttx_rd_en ? urttx_rd_dat[7:0] : 8'd0;
                    fsm_sta                 <= #U_DLY (~urttx_empty) ? FSM_TX_HEAD : FSM_TX_IDE;
                end
                FSM_TX_HEAD:
                begin
                    urt_txd_out                <= #U_DLY 1'b0;
                    bit_cnt                 <= #U_DLY 3'd0;
                    if(baud16x_cnt >= 4'hd)    //��ʼλֻ����<16����ʹ��RX<TX
                    begin
                    	uart_tx_cnt				<= #U_DLY uart_tx_cnt + 4'd1;
                    	fsm_sta                 <= #U_DLY FSM_TX_DATA;
                    	baud16x_cnt				<= #U_DLY 4'd0;
                    end
                    else
                    begin
                    	baud16x_cnt				<= #U_DLY baud16x_cnt + 4'd1;
                    end
                end
                FSM_TX_DATA:
                begin
                	baud16x_cnt				<= #U_DLY baud16x_cnt + 4'd1;
                	if(baud16x_cnt == 4'd0)
                	begin
                    	urt_txd_out                <= #U_DLY txd_data_r[0];
                    	txd_data_r[7:0]         <= #U_DLY {1'b0,txd_data_r[7:1]};
                    end
                    else if(baud16x_cnt == 4'hf)
                    begin
                    	bit_cnt                 <= #U_DLY bit_cnt + 3'd1;
                    	fsm_sta                 <= #U_DLY &bit_cnt ? FSM_TX_END : FSM_TX_DATA;
                    end
                    else
                    	;
                end
                FSM_TX_END:
                begin
                	baud16x_cnt				<= #U_DLY baud16x_cnt + 4'd1;
                    bit_cnt                 <= #U_DLY 3'd0;
                	if(baud16x_cnt == 4'd0)
                	begin
                    	urt_txd_out                <= #U_DLY 1'b1;
                    end
                    else if(baud16x_cnt >= 4'hf)	
                    begin
                    	fsm_sta                 <= #U_DLY (~urttx_empty) ? FSM_TX_HEAD : FSM_TX_IDE;
                    	urttx_rd_en       <= #U_DLY (~urttx_empty);
                    end
                    else
                    	;
                end
                default:
                begin
                    urt_txd_out                <= 1'b0;
                    bit_cnt                 <= 3'd0;
                    txd_data_r[7:0]         <= 8'd0;
                    baud16x_cnt				<= 4'd0;
                    fsm_sta                 <= FSM_TX_IDE;
                end
            endcase
        end
        else
        begin
            urttx_rd_en             <= #U_DLY 1'b0;
            txd_data_r[7:0]         <= #U_DLY urttx_rd_en ? urttx_rd_dat[7:0] : txd_data_r;
        end
    end
end
endmodule

 `timescale 1ns / 1ns                                                               
//////////////////////////////////////////////////////////////////////////////////  
// Company:                                                                         
// Engineer:                                                                        
//                                                                                  
// Create Date:    09:28:18 19/07/2018                                              
// Design Name:                                                                     
// Module Name:    urt_rx                                                       
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
module urt_rx
    (
    clk_100m,       //232ϵͳʱ��
    rst_100m,       //232ϵͳ��λ
    urt_rxd_in,       //232 rx pin
    urtrx_rd_en,

    urtrx_rd_dat,
    urtrx_empty,
    urtrx_alempty,
    urt_rx_dbg
    );
/******************************************************\
    parameter
\******************************************************/
parameter       U_DLY                   = 1;
parameter       FSM_RX_IDE              = 4'b0001;
parameter       FSM_JDG_HED             = 4'b0010;
parameter       FSM_RX_DATA             = 4'b0100;
parameter       FSM_JDG_END             = 4'b1000;

parameter       CLK_FREQ                = 100000000;    //100M
parameter       BAUD_RATE               = 19200;             //19200
parameter       BAUD_RATE_16X           = BAUD_RATE<<4;   //16x
parameter       BAUD_ACC_WID            = 16;           //65536
parameter       BAUD_GEN_16X_INC        = ((BAUD_RATE_16X<<(BAUD_ACC_WID - 4))+(CLK_FREQ>>5))/(CLK_FREQ>>4);
/******************************************************\
    ports
\******************************************************/
input                       clk_100m;
input                       rst_100m;
input                       urt_rxd_in;
input                       urtrx_rd_en;

output  [7:0]               urtrx_rd_dat;
output                      urtrx_empty;
output                      urtrx_alempty;
output  [15:0]        urt_rx_dbg;
/******************************************************\
    signal
\******************************************************/
//reg output

//reg inside
reg                         urtrx_wr_en;
reg     [7:0]               urtrx_wr_dat;
reg     [3:0]               fsm_sta;
reg     [3:0]               baud16x_cnt;
reg     [3:0]               bit_cnt;
reg     [BAUD_ACC_WID:0]    baud_16x_acc;
//reg dbg
reg     [3:0]               uart_rx_cnt;
reg     [3:0]               urtrx_discard_dat_cnt;
//wire
wire                        baud16xtick;    //9600*16
wire                        urtrx_alfull;
/******************************************************\
    assign
\******************************************************/
assign    baud16xtick    = baud_16x_acc[BAUD_ACC_WID];
assign    urt_rx_dbg   = {4'd0,urtrx_discard_dat_cnt[3:0],uart_rx_cnt[3:0],fsm_sta[3:0]};
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
        baud_16x_acc    <= #U_DLY baud_16x_acc[BAUD_ACC_WID - 1:0] + BAUD_GEN_16X_INC;
    end
end
//��������
always @ (posedge clk_100m or posedge rst_100m)
begin
    if(rst_100m == 1'b1)
    begin
        bit_cnt                 <= 4'd0;
        baud16x_cnt             <= 4'd0;
        urtrx_wr_en             <= 1'b0;
        urtrx_wr_dat            <= 8'd0;
        uart_rx_cnt       <= 4'd0;
        fsm_sta                 <= FSM_RX_IDE;
    end
    else
    begin
        if(baud16xtick == 1'b1)
        begin
            case(fsm_sta)
                FSM_RX_IDE:
                begin
                    bit_cnt                 <= #U_DLY 4'd0;
                    baud16x_cnt             <= #U_DLY 4'd0;
                    urtrx_wr_en             <= #U_DLY 1'b0;
                    urtrx_wr_dat            <= #U_DLY 8'd0;
                    fsm_sta                 <= #U_DLY urt_rxd_in ? FSM_RX_IDE : FSM_JDG_HED;  //0:��ʾ��ʼ��������
                end
                FSM_JDG_HED:
                begin
                    bit_cnt                 <= #U_DLY 4'd0;
                    urtrx_wr_en             <= #U_DLY 1'b0;
                    urtrx_wr_dat            <= #U_DLY 8'd0;
                    if(urt_rxd_in == 1'b0)
                    begin
                        baud16x_cnt         <= #U_DLY (baud16x_cnt >= 4'd8) ? 4'd0 : (baud16x_cnt + 4'd1);
                        fsm_sta             <= #U_DLY (baud16x_cnt >= 4'd8) ? FSM_RX_DATA : FSM_JDG_HED;
                    end
                    else
                    begin
                        fsm_sta             <= #U_DLY FSM_RX_IDE;
                    end
                end
                FSM_RX_DATA:
                begin
                    urtrx_wr_en         <= #U_DLY 1'b0;
                    if(&baud16x_cnt == 1'b1)
                    begin
                        urtrx_wr_dat[7:0]   <= #U_DLY {urt_rxd_in,urtrx_wr_dat[7:1]};
                        bit_cnt             <= #U_DLY bit_cnt + 4'd1;
                        baud16x_cnt         <= #U_DLY baud16x_cnt + 4'd1;
                    end
                    //else if((bit_cnt >= 4'd8) && (baud16x_cnt == 4'd14))
                    else if((bit_cnt >= 4'd8) && (baud16x_cnt == 4'd10))
                    begin
                        fsm_sta             <= #U_DLY FSM_JDG_END;
                        baud16x_cnt         <= #U_DLY 4'd0;
                    end
                    else
                    begin
                      baud16x_cnt             <= #U_DLY baud16x_cnt + 4'd1;
                    end
                end
                FSM_JDG_END:
                begin
                    bit_cnt             <= #U_DLY 4'd0;
                    urtrx_wr_en         <= #U_DLY urt_rxd_in ? 1'b1 : 1'b0;
                    baud16x_cnt         <= #U_DLY 4'd0;
                    uart_rx_cnt     <= #U_DLY uart_rx_cnt + 4'd1;
                    fsm_sta             <= #U_DLY urt_rxd_in ? FSM_RX_IDE : FSM_JDG_END;    //���������ˣ����Լ�С���ĸ��ʣ����ǻ��ǲ��ܸ���
                end
                default:
                begin
                    bit_cnt                 <= 4'd0;
                    baud16x_cnt             <= 4'd0;
                    urtrx_wr_en             <= 1'b0;
                    urtrx_wr_dat            <= 8'd0;
                    fsm_sta                 <= FSM_RX_IDE;
                end
            endcase
        end
        else
        begin
          urtrx_wr_en                 <= #U_DLY 1'b0;
        end
    end
end
//dbg
always @ (posedge clk_100m or posedge rst_100m)
begin
    if(rst_100m == 1'b1)
    begin
        urtrx_discard_dat_cnt           <= 4'd0;
    end
    else
    begin
        urtrx_discard_dat_cnt           <= #U_DLY urtrx_discard_dat_cnt + {3'd0,(urtrx_wr_en&urtrx_alfull)};
    end
end
scfifo_4x120_8x128 urt_rx
    (
  .aclr           ( rst_100m                          ),
  .clock          ( clk_100m                          ),
  .data           ( urtrx_wr_dat[7:0]                 ),
  .rdreq          ( urtrx_rd_en                       ),
  .wrreq          ( (urtrx_wr_en&(~urtrx_alfull))     ),
  .almost_empty   ( urtrx_alempty                     ),
  .almost_full    ( urtrx_alfull                      ),
  .empty          ( urtrx_empty                       ),
  .full           (                                   ),
  .q              ( urtrx_rd_dat[7:0]                 ),
  .usedw          ()
  );
endmodule

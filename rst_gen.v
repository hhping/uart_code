/********************************************************
copyright   :zhangshuai
email       :science_zhangshuai@126.com
data        :2011-11-3 21:30:53
description:�ȶԸ�λ�źŽ����˲�
*********************************************************/
`timescale 1ns/1ps
module rst_gen
    (
    fpga_10m_clk,
    fpga_rst_n,
    pll_locked,
    clk_125m,
    clk_20m,
    
    rst_10m,  	//ֻ���˲�
    rst_125m,
    rst_20m
    );
/******************************************************\
    parameter
\******************************************************/
parameter       U_DLY                   = 1;
`ifdef MODELSIM_EN
parameter		RST_10MS				= 21'd10;
`else
parameter		RST_10MS				= 21'h1312D0;
`endif
/******************************************************\
    ports
\******************************************************/
input                       fpga_10m_clk;
input                       fpga_rst_n;
input						pll_locked;
input						clk_125m;
input						clk_20m;

output						rst_10m;
output						rst_125m;
output   					rst_20m;
/******************************************************\
    signal
\******************************************************/
//reg output
reg							rst_pll_frst;
reg							rst_125m;
reg							rst_20m;
//reg inside
reg		[7:0]				pll_locked_r;
reg							pll_locked_rst;
reg		[7:0]				pll_locked_cnt;
reg							fpga_rst_flt;
reg		[7:0]				fpga_rst_flt_r;
reg		[20:0]				fpga_rst_n_flt_cnt;
reg							rst_10m;
reg		[7:0]				rst_125m_r;
reg		[7:0]				rst_20m_r;
//wire

/******************************************************\
    assign
\******************************************************/

/******************************************************\
    main
\******************************************************/
always @ (posedge fpga_10m_clk)
begin
	pll_locked_r[7:0]	<= #U_DLY {pll_locked,pll_locked_r[7:1]};
	pll_locked_rst		<= #U_DLY (pll_locked_cnt[7:0] < 8'hfe);
	if(pll_locked_r[0] == 1'b0)	//û������
	begin
		pll_locked_cnt[7:0] <= #U_DLY 8'd0;
	end
	else						//����֮��ʼ������FF��Ҫ��λ�����
	begin
		pll_locked_cnt[7:0] <= #U_DLY &pll_locked_cnt[7:0] ? 8'hff : (pll_locked_cnt[7:0] + 8'd1);
	end
end
//������룬ֻҪ����λ����ʱ��ʱ�䳤��û���⡣
always @ (posedge fpga_10m_clk)
begin
	fpga_rst_flt		<= #U_DLY (fpga_rst_n_flt_cnt[20:0] >= RST_10MS);//�п���ֻ��һ��
	fpga_rst_flt_r[7:0]	<= #U_DLY {fpga_rst_flt,fpga_rst_flt_r[7:1]};	//��չ��8�ģ����ٸ�λ8��
	rst_10m				<= #U_DLY |fpga_rst_flt_r[7:0];
	if(fpga_rst_n == 1'b0)
	begin
		if(&fpga_rst_n_flt_cnt[20:0] == 1'b0)
		begin
			fpga_rst_n_flt_cnt[20:0]	<= #U_DLY fpga_rst_n_flt_cnt + 21'd1;
		end
		else
			;
	end
	else
	begin
		fpga_rst_n_flt_cnt[20:0]	<= #U_DLY 21'd0;		//��֤�϶����Ը�λ�����ֵΪ0
	end
end



always @ (posedge fpga_10m_clk)
begin
	if(pll_locked_rst == 1'b1)
	begin
    	rst_pll_frst						<= #U_DLY 1'b1;
	end
	else if(|fpga_rst_flt_r[7:0] == 1'b1) 	//û�����������˲�֮����ȻΪ0����ʾ��λ��Ч
	begin
		rst_pll_frst						<= #U_DLY 1'b1;
	end
	else
	begin
		rst_pll_frst						<= #U_DLY 1'b0;
	end
end

//***************************************************************************************
//reset
always @ (posedge clk_125m)
begin
	rst_125m_r[7:0]			<= {rst_pll_frst,rst_125m_r[7:1]};
	rst_125m				<= rst_125m_r[0];
end
always @ (posedge clk_20m)
begin
	rst_20m_r[7:0]			<= {rst_pll_frst,rst_20m_r[7:1]};
	rst_20m					<= rst_20m_r[0];
end
endmodule

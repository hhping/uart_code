 `timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company:QTEC
// Engineer:
//
// Create Date:    09:28:18 19/07/2018
// Design Name:
// Module Name:    edge_detct
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
module edge_detct
(
    input wire rst,
    input wire clk,
    input wire i,
    output reg rise,
    output reg fall
);

reg ii;

always@(posedge clk)
    if(rst) ii<=1'b0;
    else ii <= i;

always@(posedge clk)
    if(rst) rise <= 1'b0;
    else if(i==0 && ii)rise <= 1'b1;
    else rise <= 1'b0;

always@(posedge clk)
    if(rst) fall <= 1'b0;
    else if(i && ii==0)fall <= 1'b1;
    else fall <= 1'b0;

endmodule

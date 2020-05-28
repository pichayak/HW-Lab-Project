`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Romnalin Kitkasetsathaporn
// 
// Create Date: 
// Design Name: 
// Module Name: gameBorder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Dependencies: 
// 
// Revision:
//
// Additional Comments:
// 
/////////////////////////////////////////////////////////////////////////////
module gameBorder (
	x,
	y,

	red,
	green,
	blue
	);

    parameter TOP = 96;
    parameter BOTTOM = 290;
    parameter LEFT = 220;
    parameter RIGHT = 420;

    parameter THICKNESS = 10;

	input wire [9:0] x, y;
	output reg [4:0] red,green,blue; 

	wire atBottomBorder = (BOTTOM<=y)&&(BOTTOM+THICKNESS>=Y;
	wire atTopBorder = (TOP>=y)&&(y>=TOP-THICKNESS);

	wire atRightBorder = (RIGHT<=x)&&(RIGHT+THICKNESS>=x);
	wire atLeftBorder = (LEFT>=x)&&(x>=LEFT-THICKNESS);

	//check inBoundary
	wire inBoundaryY = (y>TOP)&&(y<BOTTOM);
	wire inBoundaryY = (x>LEFT)&&(x<RIGHT);

    assign red = (( x >= TOP-10 && x <= TOP) || (x >= BOTTOM && x<= BOTTOM+10)) || ((y >= LEFT-10 && y<= LEFT) || (y >= RIGHT && y <= RIGHT+10)) ? 8'd255 : 8'd0;
    assign green = (( x >= TOP-10 && x <= TOP) || (x >= BOTTOM && x<= BOTTOM+10)) || ((y >= LEFT-10 && y<= LEFT) || (y >= RIGHT && y <= RIGHT+10)) ? 8'd255 : 8'd0;
    assign blue = (( x >= TOP-10 && x <= TOP) || (x >= BOTTOM && x<= BOTTOM+10)) || ((y >= LEFT-10 && y<= LEFT) || (y >= RIGHT && y <= RIGHT+10)) ? 8'd255 : 8'd0;
 
endmodule
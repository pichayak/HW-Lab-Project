`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Romnalin Kitkasetsathaporn
// 
// Create Date: 
// Design Name: 
// Module Name: player
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// -x,y = initial x,y | color
// Dependencies: 
// 
// Revision:
//
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module gameBorder (
	x,
	y,
	
	rgb
	);

	//static val
	parameter BUS_WIDTH = 12;
    parameter TOP = 96;
    parameter BOTTOM = 290;
    parameter LEFT = 220;
    parameter RIGHT = 420;

    parameter THICKNESS = 10;

	input wire [9:0] x, y;

	wire atBottomBorder = (BOTTOM<=y)&&(BOTTOM+THICKNESS>=Y)
	wire atTopBorder = (TOP>=y)&&(y>=TOP-THICKNESS)

	wire atRightBorder = (RIGHT<=x)&&(RIGHT+THICKNESS>=x)
	wire atLeftBorder = (LEFT>=x)&&(x>=LEFT-THICKNESS)

	//check inBoundary
	wire inBoundaryY = (y>TOP)&&(y<BOTTOM) 
	wire inBoundaryY = (x>LEFT)&&(x<RIGHT)

	assign rgb = ((inBoundX && (isTop || isBottom)) || (inBoundY && (isLeft || isRight))) ? 15'd3 : 5'd0;

endmodule
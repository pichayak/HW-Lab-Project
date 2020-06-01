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
    clk,
	x,
	y,
	red,
	green,
	blue,
	border_on
	);

    parameter top = 90;
    parameter bottom = 324;
    parameter left = 220;
    parameter right = 454;
    parameter thickness = 5;
    
    input wire clk;
	input wire [9:0] x, y;
	output reg [7:0] red,green,blue; 
    output reg [1:0] border_on;
    
    always @ (posedge clk)
    begin
    if ( (x >= left && x <= right && y >= top-thickness && y <= top) 
    || ( x >= left && x <= right && y >= bottom && y<= bottom+thickness ) 
    || ( x >= left-thickness && x<= left && y >= top-thickness && y <= bottom+thickness)
    ||(x >= right && x <= right+thickness && y >= top-thickness && y <= bottom+thickness) )
        begin
            red <= 8'd255 ;
            green <= 8'd255 ;
            blue <= 8'd255 ;
            border_on <= 1;
        end
    else
        border_on <= 0;
    end    
endmodule
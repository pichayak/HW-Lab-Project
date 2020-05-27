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

module character(
	clk,
	reset,
	x,
	y,
	button,
	character_on,
	character_out
	);

	input wire clk;
	input wire reset;
	input wire [7:0] button;
	input wire [9:0] x;
	input wire [9:0] y;
    output reg [1:0] character_on;
	output reg [7:0] character_out; // wire?
	
    reg [9:0] address;
	//set up character size and position
	reg [7:0] x_corner = 320; //character start position - X-axis
	reg [7:0] y_corner = 190; //character start position - Y-axis
	localparam character_width = 34; //character width in weight
	localparam character_height = 22; //character height in weight


	//reg for storing loaded data
	(*ROM_STYLE = "block"*) reg [7:0] CHARACTER [747:0]; // size = 34*22 

	initial begin
        $readmemh("character.mem", CHARACTER); //character-data
    end

    
// todo: correct value of WASD
    always @(posedge clk) 
    begin
        if (x==639 && y==479)
        begin
    	if (button == 8'h77) // w - up
    		begin
    			y_corner <= y<=90 ? y_corner : y_corner - 10'd1; // <height
    		end
        else if (button == 8'h73) //s -down
    		begin
    			y_corner <= y>=290 ? y_corner : y_corner + 10'd1; // <height
    		end
    	else if (button == 8'h61) //a left
    		begin
    			x_corner <= x<=220 ? x_corner : x_corner - 10'd1; // <width
    		end
    	else if (button == 8'h64) //d right
    		begin
    			x_corner <= x>=420 ? x_corner : x_corner + 10'd1; // <width
    		end
    	end
    end 
    
    //check whether character x and y position is within the confines of character
    always	@(posedge clk)
    begin
    	if (x==x_corner-1 && y==y_corner)
    		begin
    			address <= 0;
    			character_on <=1;
    		end
    	if ((x>x_corner-1) && (x<x_corner+character_width) && (y>y_corner-1) && (y<y_corner+character_height))
    		begin
    			address <= (x-x_corner) + ((y-y_corner)*character_width);
    			character_on <=1;
    		end
    	else 
    		character_on <= 0;
    end

    //assign character_out
    always @(posedge clk)
    begin
		character_out <= CHARACTER[address];
	end
endmodule
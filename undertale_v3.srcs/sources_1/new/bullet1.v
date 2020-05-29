`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2020 09:31:44 PM
// Design Name: 
// Module Name: bullet1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bullet1(
    input wire [9:0] x,             // current x position
    input wire [9:0] y,             // current y position
//    input wire aactive,             // high during active pixel drawing
    output reg b1_on,               // bullet 1=on, 0=off,
    output reg [7:0] b1_out,        // 8 bit pixel value **wire cannot be assigned
    input wire clk
    );
    
    // setup character positions and sizes
    reg [9:0] b1_x = 220;            // bullet1 X start position
    reg [9:0] b1_y = 90;             // bullet1 Y start position
    reg [1:0] b1_direction = 1;      // 0 = left, 1 = right
    localparam b1_width = 34;        // bullet1 width in pixels
    localparam b1_height = 34;       // bullet1 height in pixels
    
    // instantiate b1Rom code
    reg [10:0] b1_address;            // 2^11 = 2048,  34 x 34 = 1156
    (*ROM_STYLE="block"*) reg [7:0] b1 [0:1155]; // 8 bit values for 1020 pixels of bullet (34 x 34)

    initial begin
            $readmemh("b1.mem", b1);
    end
    
    always @ (posedge clk)
    begin
        if (b1_direction == 1)
            begin
                if (x != 420 && y != 290)
                    begin
                        b1_x <= x + 1;
                        b1_y <= y + 1;
                    end
                else if (x == 420 || y == 290)
                    b1_direction <= 0;
            end
        else if (b1_direction == 0)
            begin
                if (x != 219 && y != 89)
                    begin
                        b1_x <= x - 1;
                        b1_y <= y - 1;
                    end
                else if (x == 219 || y == 89)
                    b1_direction <= 1;
            end
    end

//check whether character x and y position is within the confines of character
always	@(posedge clk)
    begin
    	if (x == b1_x-1 && y == b1_y)
    		begin
    			b1_address <= 0;
    			b1_on <=1;
    		end
        
    	if ((x > b1_x-1) && (x < b1_x + b1_width) && (y > b1_y-1) && (y < b1_y + b1_height))
    		begin
    			b1_address <= (x-b1_x) + ((y-b1_y)*b1_width);
    			b1_on <=1;
    		end
    	else 
    		b1_on <= 0;
    end
    
always @ (posedge clk)
    begin
        b1_out <= b1[b1_address];
    end
            
endmodule
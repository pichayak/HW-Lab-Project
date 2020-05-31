`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2020 09:31:44 PM
// Design Name: 
// Module Name: bullet2
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


module bullet2(
    input wire [9:0] x,             // current x position
    input wire [9:0] y,             // current y position
//    input wire aactive,             // high during active pixel drawing
    output reg b2_on,               // bullet 1=on, 0=off,
    output reg [7:0] b2_out,        // 8 bit pixel value **wire cannot be assigned
    input wire clk
    );
    
    // setup character positions and sizes
    reg [9:0] b2_x =420;             // X start position
    reg [9:0] b2_y = 90;             // Y start position
    reg [1:0] b2_direction = 1;      // 0 = left, 1 = right
    localparam b2_width = 34;        // bullet2 width in pixels
    localparam b2_height = 34;       // bullet2 height in pixels
    
    // instantiate b1Rom code
    reg [10:0] b2_address;            // 2^11 = 2048,  34 x 34 = 1156
    (*ROM_STYLE="block"*) reg [7:0] b2 [0:1155]; // 8 bit values for 1020 pixels of bullet (34 x 34)

    initial begin
            $readmemh("b2.mem", b2);
    end
    
    always @ (posedge clk)
    begin
        if (b2_direction == 1)
            begin
                if (x != 220 && y != 290)
                    begin
                        b2_x <= x - 1;
                        b2_y <= y + 1;
                    end
                else if (x == 420 || y == 290)
                    b2_direction <= 0;
            end
        else if (b2_direction == 0)
            begin
                if (x != 419 && y != 89)
                    begin
                        b2_x <= x + 1;
                        b2_y <= y - 1;
                    end
                else if (x == 419 || y == 89)
                    b2_direction <= 1;
            end
    end

//check whether character x and y position is within the confines of character
always	@(posedge clk)
    begin
    	if (x == b2_x-1 && y == b2_y)
    		begin
    			b2_address <= 0;
    			b2_on <=1;
    		end
        
    	if ((x > b2_x-1) && (x < b2_x + b2_width) && (y > b2_y-1) && (y < b2_y + b2_height))
    		begin
    			b2_address <= (x-b2_x) + ((y-b2_y)*b2_width);
    			b2_on <=1;
    		end
    	else 
    		b2_on <= 0;
    end
    
always @ (posedge clk)
    begin
        b2_out <= b2[b2_address];
    end
            
endmodule
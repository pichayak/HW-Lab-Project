`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2020 09:16:17 PM
// Design Name: 
// Module Name: monster
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


module monster(
    input wire [9:0] x1,             // current b1's x position
    input wire [9:0] y1,             // current b1's y position
    input wire [9:0] x2,             // current b2's x position
    input wire [9:0] y2,             // current b2's y position
    input wire [9:0] x3,             // current b3's x position
    input wire [9:0] y3,             // current b3's y position
//    input wire aactive,             // high during active pixel drawing
    output reg b1_on,               // bullet 1=on, 0=off
    output reg b2_on,
    output reg b3_on,
    output reg [7:0] b1_out,        // 8 bit pixel value **wire cannot be assigned
    output reg [7:0] b2_out,        
    output reg [7:0] b3_out,
    input wire clk                 // 25MHz pixel clock
    );
    
    // instantiate b1Rom code
    reg [10:0] b1_address;            // 2^11 = 2048,  34 x 34 = 1156
    (*ROM_STYLE="block"*) reg [7:0] b1 [0:1155]; // 8 bit values for 1020 pixels of bullet (34 x 34)

    initial begin
            $readmemh("b1.mem", b1);
    end 

    // instantiate b2Rom code
    reg [10:0] b2_address;            // 2^11 = 1024,  34 x 30 = 1156
    (*ROM_STYLE="block"*) reg [7:0] b2 [0:1155]; // 8 bit values for 1020 pixels of bullet (34 x 34)

    initial begin
            $readmemh("b2.mem", b2);
    end
            
    // instantiate b3Rom code
    reg [10:0] b3_address;            // 2^11 = 1156,  34 x 34 = 1156
    (*ROM_STYLE="block"*) reg [7:0] b3 [0:1155]; // 8 bit values for 1156 pixels of bullet (34 x 34)

    initial begin
            $readmemh("b3.mem", b3);
    end
            
    // setup character positions and sizes
    reg [9:0] b1_x = 220;            // bullet1 X start position
    reg [9:0] b1_y = 90;             // bullet1 Y start position
    reg [1:0] b1_direction = 1;      // 0 = left, 1 = right
    localparam b1_width = 34;        // bullet1 width in pixels
    localparam b1_height = 34;       // bullet1 height in pixels
    reg [9:0] b2_x = 420;            // bullet2 X start position
    reg [9:0] b2_y = 90;             // bullet2 Y start position
    reg [1:0] b2_direction = 1;      // 0 = left, 1 = right
    localparam b2_width = 34;        // bullet2 width in pixels
    localparam b2_height = 34;       // bullet2 height in pixels
    reg [9:0] b3_x = 320;            // bullet3 X start position
    reg [9:0] b3_y = 90;             // bullet3 Y start position
    reg [1:0] b3_direction = 1;      // 0 = up, 1 = down
    localparam b3_width = 34;        // bullet3 width in pixels
    localparam b3_height = 34;       // bullet3 height in pixels

//    reg [1:0] direction = 1;        // direction of aliens: 0=right, 1=left
//    reg [9:0] slow = 0;             // counter to slow alien movement
    
    always @ (posedge clk)
    begin
        //bullet 1
        if (b1_direction == 1)
            begin
                if (b1_x != 420 && b1_y != 290)
                    begin
                        b1_x <= b1_x + 1;
                        b1_y <= b1_y + 1;
                    end
                else if (b1_x == 420 || b1_y == 290)
                    b1_direction <= 0;
            end
        else if (b1_direction == 0)
            begin
                if (b1_x != 219 && b1_y != 89)
                    begin
                        b1_x <= b1_x - 1;
                        b1_y <= b1_y - 1;
                    end
                else if (b1_x == 219 || b1_y == 89)
                    b1_direction <= 1;
            end
//        else
//            b1_on <=0;
        
        //bullet 2
        if (b2_direction == 1)
            begin
                if (b2_x != 220 && b2_y != 290)
                    begin
                        b2_x <= b2_x - 1;
                        b2_y <= b2_y + 1;
                    end
                else if (b2_x == 420 || b2_y == 290)
                    b2_direction <= 0;
            end
        else if (b2_direction == 0)
            begin
                if (b2_x != 419 && b2_y != 89)
                    begin
                        b2_x <= b2_x + 1;
                        b2_y <= b2_y - 1;
                    end
                else if (b2_x == 419 || b2_y == 89)
                    b2_direction <= 1;
            end
//        else
//            b2_on <=0;
            
        //bullet 3
        if (b3_direction == 1)
            begin
                if (b3_y != 290)
                    begin
                        b3_y <= b3_y + 1;
                    end
                else if (b3_y == 290)
                    b3_direction <= 0;
            end
        else if (b3_direction == 0)
            begin
                if (b3_y != 89)
                    begin
                        b3_y <= b3_y - 1;
                    end
                else if (b3_y == 89)
                    b3_direction <= 1;
            end
//        else
//            b3_on <=0;
    end

//check whether character x and y position is within the confines of character
always	@(posedge clk)
    begin
    	if (x1 == b1_x && y1 == b1_y)
    		begin
    			b1_address <= 0;
    			b1_on <=1;
    		end
    	if (x2 == b2_x && y2 == b2_y)
    		begin
    			b2_address <= 0;
    			b2_on <=1;
    		end
        if (x3 == b3_x && y3 == b3_y)
    		begin
    			b3_address <= 0;
    			b3_on <=1;
    		end
        
    	if ((x2 > b2_x-1) && (x2 < b2_x + b2_width) && (y2 > b2_y-1) && (y2 < b2_y + b2_height))
    		begin
    			b2_address <= (x2-b2_x) + ((y2-b2_y)*b2_width);
    			b2_on <=1;
    		end
    	else 
    		b2_on <= 0;
    		
        if ((x3 > b3_x-1) && (x3 < b3_x + b3_width) && (y3 > b3_y-1) && (y3 < b3_y + b3_height))
    		begin
    			b3_address <= (x3-b3_x) + ((y3-b3_y)*b3_width);
    			b3_on <=1;
    		end
    	else 
    		b3_on <= 0;
    end
    
always @ (posedge clk)
    begin
        b1_out <= b1[b1_address];
        b2_out <= b2[b2_address];
        b3_out <= b3[b3_address];
    end
            
endmodule
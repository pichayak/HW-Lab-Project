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
    input wire clk,
    input wire [9:0] x,             // current x position
    input wire [9:0] y,             // current y position
    input wire aactive,             // high during active pixel drawing
    output reg [1:0] b1_on,               // bullet 1=on, 0=off,
    output wire [7:0] b1_out        // 8 bit pixel value **wire cannot be assigned
    );
       
    // instantiate b1Rom code
    reg [10:0] address; 
    BulletRom BulletRom (.i_addr(address),.i_clk2(clk),.o_data(b1_out));
    
    // setup character positions and sizes
    reg [9:0] b1_x = 220;            // bullet1 X start position
    reg [8:0] b1_y = 90;             // bullet1 Y start position
    reg [1:0] b1_direction = 1;      // 0 = left, 1 = right
    localparam b1_width = 34;        // bullet1 width in pixels
    localparam b1_height = 34;       // bullet1 height in pixels

    
    always @ (posedge clk)
    begin
        if (x==639 && y==479)
            begin
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
//            begin // check for left or right button pressed
//                if (b1_x<640-b1_width) //d right
//                    b1_x<=b1_x+9'd1;
//                if (button == 8'h61 && x_corner>1) //a left
//                    x_corner<=x_corner-9'd1; 
//                if (button == 8'h77 && y_corner<480-character_height)//w up
//                    y_corner<= y_corner-8'd1;
//                if (button == 8'h73 && y_corner>1) //s down
//                    y_corner<= y_corner+8'd1;
//            end 
            end
         //check whether character x and y position is within the confines of character
         if (aactive)
            begin // check if xx,yy are within the confines of the Bee character
                if (x==b1_x-1 && y==b1_y)
                    begin
                        address <= 0;
                        b1_on <=1;
                    end
                if ((x>b1_x-1) && (x<b1_x+b1_width) && (y>b1_y-1) && (y<b1_y+b1_height))
                    begin
                        address <= address + 1;
                        b1_on <=1;
                    end
                else
                    b1_on <=0;
            end
    end

            
endmodule
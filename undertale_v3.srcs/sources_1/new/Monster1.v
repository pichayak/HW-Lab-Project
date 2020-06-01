`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2020 10:53:40 PM
// Design Name: 
// Module Name: Monster1
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


module Monster1(
    input wire clk, // 25MHz pixel clock
    input wire [9:0] x, // current x position
    input wire [9:0] y, // current y position
    input wire aactive, // high during active pixel drawing
    output reg [1:0] b1_on, // 1=on, 0=off
    output wire [7:0] b1_out, // 8 bit pixel value from Monster1.mem
    input wire onCollision_b1,
    input wire dodging
    );

    reg [1:0] aldCollision = 0;
    
    // random bullet pattern
    reg [1:0] pattern;
    initial begin
        pattern = $urandom%1;
    end

    // instantiate MonsterRom code
    reg [10:0] address; // 2^10 or 1024, need 34 x 27 = 918
    MonsterRom MonsterRom (.i_addr(address),.i_clk2(clk),.o_data(b1_out));
    
    localparam monster_x = 220;
    localparam monster_y = 90;        
    // setup character positions and sizes
    reg [9:0] b1_x = 220; //character start position - X-axis
	reg [8:0] b1_y = 90; //character start position - Y-axis
	reg [2:0] b1_direction = 1;
	localparam b1_width = 34; //character width in weight
	localparam b1_height = 34; //character height in weight
  
    always @ (posedge clk)
    begin
        if(dodging == 1)
            begin
                b1_x <= monster_x;
                b1_y <= monster_y;
            end
        
        if (x==639 && y==479)
            begin
                if (pattern == 0)
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
                   end
                       
                else if (pattern == 1)
                    begin
                    if (b1_direction == 1)
                        begin
                            if (b1_x != 320 && b1_y != 290)
                                begin
                                    b1_x <= b1_x + 1;
                                    b1_y <= b1_y + 2;
                                end
                            else if (b1_x == 320 || b1_y == 290)
                                b1_direction <= 0;
                        end
                    else if (b1_direction == 0)
                        begin
                            if (b1_x != 420 && b1_y != 90)
                                begin
                                    b1_x <= b1_x + 1;
                                    b1_y <= b1_y - 2;
                                end
                            else if (b1_x == 420 || b1_y == 90)
                                b1_direction <= 2;
                        end
                    else if (b1_direction == 2)
                        begin
                            if (b1_x != 319 && b1_y != 289)
                                begin
                                    b1_x <= b1_x - 1;
                                    b1_y <= b1_y - 2;
                                end
                            else if (b1_x == 319 || b1_y == 289)
                                b1_direction <= 3;
                        end
                    else
                        begin
                            if (b1_x != 219 && b1_y != 89)
                                begin
                                    b1_x <= b1_x - 1;
                                    b1_y <= b1_y - 2;
                                end
                            else if (b1_x == 219 || b1_y == 89)
                                b1_direction <= 0;
                        end
                  end
            end   
        if (aactive)
                begin   //check collision 
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
                        
                    if(onCollision_b1 ==1)
                        b1_on <=0;
                end
    end
endmodule

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
    input wire clk, 
    input wire [9:0] x, 
    input wire [9:0] y, 
    input wire aactive, 
    output reg [1:0] b1_on, 
    output wire [7:0] b1_out, 
    input wire onCollision_b1,
    input wire dodging
    );

    reg [1:0] aldCollision = 0;
    
    reg [1:0] pattern;
    initial begin
        pattern = $urandom%1;
    end

    reg [10:0] address; 
    MonsterRom MonsterRom (.i_addr(address),.i_clk2(clk),.o_data(b1_out));
    
    localparam monster_x = 220;
    localparam monster_y = 90;        

    reg [9:0] b1_x = 220; 
	reg [8:0] b1_y = 90; 
	reg [2:0] b1_direction = 1;
	localparam b1_width = 34; 
	localparam b1_height = 34; 
  
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

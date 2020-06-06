`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2020 02:16:45 AM
// Design Name: 
// Module Name: Monster2
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

module Monster2(
input wire clk, 
    input wire [9:0] x,
    input wire [9:0] y,
    input wire aactive, 
    output reg [1:0] b2_on, 
    output wire [7:0] b2_out,
    input wire onCollision_b2,
    input wire dodging
    );

    reg [10:0] address; 
    MonsterRom2 MonsterRom2 (.i_addr(address),.i_clk2(clk),.o_data(b2_out));
      
    localparam monster_x = 420;
    localparam monster_y = 90;            

    reg [9:0] b2_x = 420; 
	reg [8:0] b2_y = 90; 
	reg [1:0] b2_direction = 1;
	localparam b2_width = 34; 
	localparam b2_height = 34; 
  
    always @ (posedge clk)
    begin
        if(dodging == 1)
            begin
                b2_x <= monster_x;
                b2_y <= monster_y;
            end
            
        if (x==639 && y==479)
            begin
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
            end   
        if (aactive)
            begin // check if xx,yy are within the confines of the Bee character
                if (x==b2_x-1 && y==b2_y)
                    begin
                        address <= 0;
                        b2_on <=1;
                    end
                if ((x>b2_x-1) && (x<b2_x+b2_width) && (y>b2_y-1) && (y<b2_y+b2_height))
                    begin
                        address <= address + 1;
                        b2_on <=1;
                    end
                else
                    b2_on <=0;
                //check collision    
                if(onCollision_b2 ==1)
                        b2_on <=0;
            end
    end
endmodule

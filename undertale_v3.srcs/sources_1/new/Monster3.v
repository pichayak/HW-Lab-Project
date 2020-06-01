`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2020 02:17:55 AM
// Design Name: 
// Module Name: Monster3
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


module Monster3(
input wire clk, // 25MHz pixel clock
    input wire [9:0] x, // current x position
    input wire [9:0] y, // current y position
    input wire aactive, // high during active pixel drawing
    output reg [1:0] b3_on, // 1=on, 0=off
    output wire [7:0] b3_out, // 8 bit pixel value from Bee.mem
    input wire onCollision_b3,
    input wire dodging
    );

    reg [10:0] address; 
    MonsterRom3 MonsterRom3 (.i_addr(address),.i_clk2(clk),.o_data(b3_out));
    
    localparam monster_x = 330;
    localparam monster_y = 90;          
    // setup character positions and sizes
    reg [9:0] b3_x = 330; //character start position - X-axis
	reg [8:0] b3_y = 90; //character start position - Y-axis
	reg [1:0] b3_direction = 1;
	localparam b3_width = 34; //character width in weight
	localparam b3_height = 34; //character height in weight
  
    always @ (posedge clk)
    begin
    
       if(dodging == 1)
            begin
                b3_x <= monster_x;
                b3_y <= monster_y;
            end
            
        if (x==639 && y==479)
            begin
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
            end   
        if (aactive)
            begin // check if xx,yy are within the confines of the Bee character
                if (x==b3_x-1 && y==b3_y)
                    begin
                        address <= 0;
                        b3_on <=1;
                    end
                if ((x>b3_x-1) && (x<b3_x+b3_width) && (y>b3_y-1) && (y<b3_y+b3_height))
                    begin
                        address <= address + 1;
                        b3_on <=1;
                    end
                else
                    b3_on <=0;
                
                if(onCollision_b3 ==1)
                    b3_on <=0;
            end
        
    end
endmodule

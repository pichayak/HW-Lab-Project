`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2020 10:03:50 PM
// Design Name: 
// Module Name: Player
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


module Player(
    input wire clk, // 25MHz pixel clock
    input wire [9:0] x, // current x position
    input wire [9:0] y, // current y position
    input wire aactive, // high during active pixel drawing
    input wire [7:0] button,
    output reg [1:0] character_on, // 1=on, 0=off
    output wire [7:0] character_out // 8 bit pixel value from Bee.mem
    );

    // instantiate BeeRom code
    reg [9:0] address; // 2^10 or 1024, need 34 x 27 = 918
    CharacterRom PlayerRom (.i_addr(address),.i_clk2(clk),.o_data(character_out));
            
    // setup character positions and sizes
    reg [9:0] x_corner = 220; //character start position - X-axis
	reg [8:0] y_corner = 190; //character start position - Y-axis
	localparam character_width = 34; //character width in weight
	localparam character_height = 22; //character height in weight
  
    always @ (posedge clk)
    begin
        if (x==639 && y==479)
            begin // check for left or right button pressed
                if (button == 8'h64 && x_corner<640-character_width) //d right
                    x_corner<=x_corner+9'd1;
                if (button == 8'h61 && x_corner>1) //a left
                    x_corner<=x_corner-9'd1; 
                if (button == 8'h77 && y_corner<480-character_height)//w up
                    y_corner<= y_corner-8'd1;
                if (button == 8'h73 && y_corner>1) //s down
                    y_corner<= y_corner+8'd1;
            end    
        if (aactive)
            begin // check if xx,yy are within the confines of the Bee character
                if (x==x_corner-1 && y==y_corner)
                    begin
                        address <= 0;
                        character_on <=1;
                    end
                if ((x>x_corner-1) && (x<x_corner+character_width) && (y>y_corner-1) && (y<y_corner+character_height))
                    begin
                        address <= address + 1;
                        character_on <=1;
                    end
                else
                    character_on <=0;
            end
    end
endmodule
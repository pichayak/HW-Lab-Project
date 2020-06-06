`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2020 02:20:32 AM
// Design Name: 
// Module Name: ObstacleGreen
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


module ObstacleGreen(
    input wire Clk,
    input wire [9:0] x,
    input wire [9:0] y,
    output reg [7:0] red,
    output reg [7:0] green,
    output reg [7:0] blue,
    output reg [1:0] ogOn,
    input wire onCollision_og
    );
    
    parameter Gupper = 190;
    parameter Glower = 200;
    parameter Gleft = 424;
    parameter Gright = 434;
    
    always @(posedge Clk) 
        begin
            if(Gupper <= y && y <= Glower && Gleft <= x && x <= Gright) 
                begin
                    red <= 8'd0;
                    green <= 8'd255;
                    blue <= 8'd0;
                    ogOn<= 1;
                end
             else
                ogOn <= 0;
                
             if(onCollision_og == 1)
                ogOn <= 0;
        end
        
endmodule

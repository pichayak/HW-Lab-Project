`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2020 02:03:26 AM
// Design Name: 
// Module Name: ObstacleBlue
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


module ObstacleBlue(
    input wire Clk,
    input wire [9:0] x,
    input wire [9:0] y,
    output reg [7:0] red,
    output reg [7:0] green,
    output reg [7:0] blue,
    output reg [1:0] obOn,
    input wire onCollision_ob
    );
    
    parameter Bupper = 190;
    parameter Blower = 200;
    parameter Bleft = 221;
    parameter Bright = 231;
  
    always @(posedge Clk) 
        begin
            if(Bupper <= y && y <= Blower && Bleft <= x && x <= Bright) 
                begin
                    red <= 8'd0;
                    green <= 8'd0;
                    blue <= 8'd255;
                    obOn<= 1;
                end
             else
                obOn <= 0;
                
             if(onCollision_ob == 1)
                obOn <= 0;
        end
        
    
endmodule

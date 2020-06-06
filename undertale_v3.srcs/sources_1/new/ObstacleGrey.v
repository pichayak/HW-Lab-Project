`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2020 02:03:04 AM
// Design Name: 
// Module Name: ObstacleGrey
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


module ObstacleGrey(
    input wire Clk,
    input wire [9:0] x,
    input wire [9:0] y,
    output reg [7:0] red,
    output reg [7:0] green,
    output reg [7:0] blue,
    output reg [1:0] ogreyOn
    );
    
    parameter Gupper = 260;
    parameter Glower = 270;
    parameter Gleft = 241;
    parameter Gright = 251;
    
    always @(posedge Clk) 
        begin
            if(Gupper <= y && y <= Glower && Gleft <= x && x <= Gright) 
                begin
                    red <= 8'd200;
                    green <= 8'd201;
                    blue <= 8'd202;
                    ogreyOn<= 1;
                end
             else
                ogreyOn <= 0;
        end
endmodule

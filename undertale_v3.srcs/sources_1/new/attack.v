`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2020 01:06:57 PM
// Design Name: 
// Module Name: attack
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


module attack(
    input wire i_clk,
    input wire i_rst,
    input wire [9:0] xx, 
    input wire [9:0] yy,
    input wire Click,
    output wire [11:0] rgb,
    output wire [7:0] damage
    );
    
    reg [9:0] middleX = 315; // X start position
    reg [8:0] middleY = 230; // Y start position
    localparam middleWidth = 10; // width in pixels
    localparam middleHeight = 27; // height in pixels
    
    reg [9:0] runningX = 20; // X start position
    reg [8:0] runningY = 280; // Y start position
    localparam runningWidth = 6; // width in pixels
    localparam runningHeight = 60; // height in pixels
    
    always @ (posedge i_clk)
    begin
    
    end
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2020 08:54:04 PM
// Design Name: 
// Module Name: StartSprite
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


module Teemo(
    input wire i_clk,
    input wire i_rst,
    input wire [9:0] xx, 
    input wire [9:0] yy,
    input wire aactive,
    output reg [1:0] TeemoOn, // 1=on, 0=off
    output wire [7:0] TeemoOut
    );

    // instantiate BeeRom code
    reg [13:0] address; 
    TeemoRom TeemoRom (.i_addr(address),.i_clk2(i_clk),.o_data(TeemoOut));
    
    // setup character positions and sizes
    reg [9:0] StartX = 275; 
    reg [8:0] StartY = 90; 
    localparam StartWidth = 90; 
    localparam StartHeight = 95; 
    
    // check if xx,yy are within the confines of the character
    always @ (posedge i_clk)
    begin
        if (aactive)
            begin
                if (xx==StartX-1 && yy==StartY)
                    begin
                        address <= 0;
                        TeemoOn <=1;
                    end
                if ((xx>StartX-1) && (xx<StartX+StartWidth) && (yy>StartY-1) && (yy<StartY+StartHeight))
                    begin
                        address <= (xx-StartX) + ((yy-StartY)*StartWidth);
                        TeemoOn <=1;
                    end
                else
                    TeemoOn <=0;
            end
    end
endmodule

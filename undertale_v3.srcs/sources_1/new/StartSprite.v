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


module StartSprite(
    input wire i_clk,
    input wire i_rst,
    input wire [9:0] xx, 
    input wire [9:0] yy,
    input wire aactive,
    output reg [1:0] StartSpriteOn, // 1=on, 0=off
    output wire [7:0] startout
    );

    // instantiate BeeRom code
    reg [13:0] address; // 2^10 or 1024, need 34 x 27 = 918
    StartRom StartVRom (.i_addr(address),.i_clk2(i_clk),.o_data(startout));
    
    // setup character positions and sizes
    reg [9:0] StartX = 218; // Bee X start position
    reg [8:0] StartY = 384; // Bee Y start position
    localparam StartWidth = 228; // Bee width in pixels
    localparam StartHeight = 49; // Bee height in pixels
    
    // check if xx,yy are within the confines of the Bee character
    always @ (posedge i_clk)
    begin
        if (aactive)
            begin
                if (xx==StartX-1 && yy==StartY)
                    begin
                        address <= 0;
                        StartSpriteOn <=1;
                    end
                if ((xx>StartX-1) && (xx<StartX+StartWidth) && (yy>StartY-1) && (yy<StartY+StartHeight))
                    begin
                        address <= (xx-StartX) + ((yy-StartY)*StartWidth);
                        StartSpriteOn <=1;
                    end
                else
                    StartSpriteOn <=0;
            end
    end
endmodule

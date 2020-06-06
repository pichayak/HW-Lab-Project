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
    output reg [1:0] StartSpriteOn,
    output wire [7:0] startout
    );

    reg [13:0] address;
    StartRom StartVRom (.i_addr(address),.i_clk2(i_clk),.o_data(startout));

    reg [9:0] StartX = 218;
    reg [8:0] StartY = 384; 
    localparam StartWidth = 228;
    localparam StartHeight = 49;
    
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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2020 07:15:46 PM
// Design Name: 
// Module Name: GroupnameSprite
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


module GroupnameSprite(
    input wire i_clk,
    input wire i_rst,
    input wire [9:0] xx, 
    input wire [9:0] yy,
    input wire aactive,
    output reg [1:0] GroupnameSpriteOn, // 1=on, 0=off
    output wire [7:0] dataout
    );

    // instantiate BeeRom code
    reg [14:0] address; // 2^10 or 1024, need 34 x 27 = 918
    GroupnameRom GroupnameVRom (.i_addr(address),.i_clk2(i_clk),.o_data(dataout));
    
    // setup character positions and sizes
    reg [9:0] GroupX = 105; // Bee X start position
    reg [8:0] GroupY = 81; // Bee Y start position
    localparam GroupWidth = 443; // Bee width in pixels
    localparam GroupHeight = 47; // Bee height in pixels
    
    // check if xx,yy are within the confines of the Bee character
    always @ (posedge i_clk)
    begin
        if (aactive)
            begin
                if (xx==GroupX-1 && yy==GroupY)
                    begin
                        address <= 0;
                        GroupnameSpriteOn <=1;
                    end
                if ((xx>GroupX-1) && (xx<GroupX+GroupWidth) && (yy>GroupY-1) && (yy<GroupY+GroupHeight))
                    begin
                        address <= (xx-GroupX) + ((yy-GroupY)*GroupWidth);
                        GroupnameSpriteOn <=1;
                    end
                else
                    GroupnameSpriteOn <=0;
            end
    end
endmodule

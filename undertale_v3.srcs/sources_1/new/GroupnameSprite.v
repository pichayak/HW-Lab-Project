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
    output reg [1:0] GroupnameSpriteOn, 
    output wire [7:0] dataout
    );

    reg [14:0] address; 
    GroupnameRom GroupnameVRom (.i_addr(address),.i_clk2(i_clk),.o_data(dataout));
    
    reg [9:0] GroupX = 105; 
    reg [8:0] GroupY = 81; 
    localparam GroupWidth = 443;
    localparam GroupHeight = 47; 
    
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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2020 07:39:41 PM
// Design Name: 
// Module Name: MembersSprite
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


module MembersSprite(
    input wire i_clk,
    input wire i_rst,
    input wire [9:0] xx, 
    input wire [9:0] yy,
    input wire aactive,
    output reg [1:0] MembersSpriteOn, // 1=on, 0=off
    output wire [7:0] membersout
    );

    // instantiate BeeRom code
    reg [16:0] address; // 2^10 or 1024, need 34 x 27 = 918
    MembersRom MembersVRom (.i_addr(address),.i_clk2(i_clk),.o_data(membersout));
    
    // setup character positions and sizes
    reg [9:0] MembersX = 70; // Bee X start position
    reg [8:0] MembersY = 175; // Bee Y start position
    localparam MembersWidth = 531; // Bee width in pixels
    localparam MembersHeight = 125; // Bee height in pixels
    
    // check if xx,yy are within the confines of the Bee character
    always @ (posedge i_clk)
    begin
        if (aactive)
            begin
                if (xx==MembersX-1 && yy==MembersY)
                    begin
                        address <= 0;
                        MembersSpriteOn <=1;
                    end
                if ((xx>MembersX-1) && (xx<MembersX+MembersWidth) && (yy>MembersY-1) && (yy<MembersY+MembersHeight))
                    begin
                        address <= (xx-MembersX) + ((yy-MembersY)*MembersWidth);
                        MembersSpriteOn <=1;
                    end
                else
                    MembersSpriteOn <=0;
            end
    end
endmodule

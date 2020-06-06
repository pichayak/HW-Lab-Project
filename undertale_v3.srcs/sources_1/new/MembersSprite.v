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
    output reg [1:0] MembersSpriteOn,
    output wire [7:0] membersout
    );

    reg [16:0] address; 
    MembersRom MembersVRom (.i_addr(address),.i_clk2(i_clk),.o_data(membersout));

    reg [9:0] MembersX = 70;
    reg [8:0] MembersY = 175;
    localparam MembersWidth = 531; 
    localparam MembersHeight = 125;
    
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

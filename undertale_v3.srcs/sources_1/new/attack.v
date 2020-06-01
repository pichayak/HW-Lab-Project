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
	input wire aactive,
    input wire button,
    input wire state,
    output reg [7:0] pdamage,
    output reg [1:0] target,
    output wire [7:0] runningOut,
    output reg [1:0] runningOn = 0,
    output wire [7:0] scaleOut,
    output reg [1:0] scaleOn = 0
    );
    
    reg [9:0] middleX = 315; // X start position
    reg [8:0] middleY = 230; // Y start position
    localparam middleWidth = 24; // width in pixels
    localparam middleHeight = 14; // height in pixels
    
    reg [9:0] runningX = 20; // X start position
    reg [8:0] runningY = 280; // Y start position
    localparam runningWidth = 6; // width in pixels
    localparam runningHeight = 60; // height in pixels
    
    localparam maxDamage = 70;
    
    reg [8:0] address_r;
    runningRom RunningRom (.i_addr(address_r),.i_clk2(i_clk),.o_data(runningOut));
    
    reg [8:0] address_s;
    ScaleRom ScaleRom (.i_addr(address_s),.i_clk2(i_clk),.o_data(scaleOut));
    
    always @ (posedge i_clk)
    begin   
            if (xx==639 && yy==479)
                begin
                    if (button == 1 && state != 0) //space
                        if(runningX<320)
                            begin
                                pdamage <= maxDamage-(320-runningX)/5;
                                target <= 1;
                            end
                        else
                            begin
                                pdamage <= maxDamage-(runningX-320)/5;
                                target <= 1;
                            end
                    if( runningX == 620 )
                        runningX <= 0;
                    else
                        runningX <= runningX + 9'd1;
                end 
            //running bar
            if(aactive)
            begin
            //middle scale
                if (xx==middleX-1 && yy==middleY)
                    begin
                        address_s <= 0;
                        scaleOn <=1;
                    end
                if ((xx>middleX-1) && (xx<middleX+middleWidth) && (yy>middleY-1) && (yy<middleY+middleHeight))
                    begin
                        address_s <= (xx-middleX) + ((yy-middleY)*middleWidth);
                        scaleOn <=1;
                    end
                else
                        scaleOn <=0;
            //running bar
               if (xx==runningX-1 && yy==runningY)
                    begin
                        address_r <= 0;
                        runningOn <=1;
                    end
               if ((xx>runningX-1) && (xx<runningX+runningWidth) && (yy>runningY-1) && (yy<runningY+runningHeight))
                        begin
                            address_r <= (xx-runningX) + ((yy-runningY)*runningWidth);
                            runningOn <=1;
                        end
                else
                        runningOn <=0;
            end
     end
    
endmodule

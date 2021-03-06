`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2020 06:06:38 PM
// Design Name: 
// Module Name: OnCollision
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


module OnCollision(
    input wire PixClk,
    input wire b1_on,
    input wire b2_on,
    input wire b3_on,
    input wire obOn,
    input wire obXLOn,
    input wire ogOn,
    input wire CharacterOn,
    output reg target,
    output reg onCollision_b1,
    output reg onCollision_b2,
    output reg onCollision_b3,
    output reg onCollision_ob,
    output reg onCollision_obXL,
    output reg onCollision_og,
    input wire state,
    input wire dodging
    );
    
    initial onCollision_b1 = 0;
    initial onCollision_b2 = 0;
    initial onCollision_b3 = 0;
    initial onCollision_ob = 0;
    initial onCollision_obXL = 0;
    initial onCollision_og = 0;
    
    always@(posedge PixClk)
    begin
         if(CharacterOn == 1 && b1_on ==1)
            begin
                target <= 0;
                onCollision_b1 <= 1;
            end
        else if(CharacterOn == 1 && b2_on ==1)
            begin
                target <= 0;
                onCollision_b2 <= 1;
            end
        else if(CharacterOn == 1 && b3_on ==1)
            begin
                target <= 0;
                onCollision_b3 <= 1;
            end
        else if(CharacterOn == 1 && obOn ==1) //crash obstacle
            begin
                target <= 0;
                onCollision_ob <= 1;
            end
        else if(CharacterOn == 1 && obXLOn ==1) //crash obstacle
            begin
                target <= 0;
                onCollision_obXL <= 1;
            end
        else if(CharacterOn == 1 && ogOn ==1) //crash obstacle
            begin
                target <= 0;
                onCollision_og <= 1;
            end
        else
            begin
                target <= 1;
            end
        
        if(state == 2 || dodging == 1)
            begin
                onCollision_b1 <= 0;
                onCollision_b2 <= 0;
                onCollision_b3 <= 0;
                onCollision_ob <= 0;
                onCollision_obXL <= 0;
                onCollision_og <= 0;
            end
    end
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2020 10:13:29 AM
// Design Name: 
// Module Name: Hp
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


module Hp(
input wire Clk,
input wire [9:0] x,
input wire [9:0] y,
input wire [7:0] damage,
input wire target, //0 is enemy 1 is player 
output reg [7:0] red,
output reg [7:0] green,
output reg [7:0] blue,
output reg [1:0] hpOn,
output reg [1:0] p_alive,
output reg [1:0] e_alive,
input wire [1:0] gotDamage,
input wire b1_on,
input wire b2_on,
input wire b3_on,
input wire ogOn,
input wire obOn,
input wire obXLOn,
input wire onCollision_b1,
input wire onCollision_b2,
input wire onCollision_b3,
input wire onCollision_og,
input wire onCollision_ob,
input wire onCollision_obXL,
input wire state
);

initial p_alive = 1;
initial e_alive = 1;

parameter player_y_upper = 400;
parameter player_y_lower = 420;
parameter enemy_y_upper = 440;
parameter enemy_y_lower = 460;
parameter hp_start = 90;
parameter hp_length = 200;

//hp bar
parameter pMaxHp = 200;
parameter eMaxHp = 200;

parameter enemy_damage = 70;
   
reg [7:0] cur_pHp = 200, cur_eHp = 200;
reg [7:0] stack_pdamage;
reg [7:0] stack_edamage;

always @(posedge Clk) begin
    //logic
    if(damage > 0) begin
        if(target == 0) begin
             //stack_pdamage = stack_pdamage + enemy_damage;
             end
        else if(target == 1 && gotDamage == 1) begin
             stack_edamage <= stack_edamage + damage;
             end
        end
    //logic for collision
    if(b1_on == 1 && onCollision_b1 == 1 && state == 1)
        stack_pdamage = stack_pdamage + enemy_damage;
    if(b2_on == 1 && onCollision_b2 == 1 && state == 1)
        stack_pdamage = stack_pdamage + enemy_damage;
    if(b3_on == 1 && onCollision_b3 == 1 && state == 1)
        stack_pdamage = stack_pdamage + enemy_damage;
    if(ogOn == 1 && onCollision_og == 1 && state == 1)
    begin
        if(stack_pdamage-50 <0) 
            stack_pdamage=0;
        else
            stack_pdamage = stack_pdamage - 50;
    end
    if(obOn == 1 && onCollision_ob == 1 && state == 1)
        stack_pdamage = stack_pdamage + 40;
    if(obXLOn == 1 && onCollision_obXL == 1 && state == 1)
        stack_pdamage = stack_pdamage + 80;
    //display    
    //player
    if(player_y_upper <= y && y <= player_y_lower && hp_start <= x && x <= 290-stack_edamage) 
            begin
                red <= 8'd0;
                green <= 8'd252;
                blue <= 8'd4;
                hpOn<= 1;
            end
    //enemy
    else if(enemy_y_upper <= y && y <= enemy_y_lower && hp_start <= x && x <= 290-stack_pdamage) 
         begin
                red <= 8'd255;
                green <= 8'd226;
                blue <= 8'd92;
                hpOn<= 1;
            end
    else
        hpOn<= 0;
        
    end

always @(posedge Clk) begin
    if(stack_edamage >= 200)
       p_alive =0;
    else
        p_alive =1;
    if(stack_pdamage >= 200) 
        e_alive = 0;
    else
        e_alive =1;        
end

endmodule
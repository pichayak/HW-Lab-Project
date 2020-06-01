`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2020 01:34:40 PM
// Design Name: 
// Module Name: Timer
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


module Timer(
    input wire PixClk,
    input wire Btn,
    input wire enter,
    input wire e_alive,
    input wire p_alive,
    output reg [1:0] state,
    output reg [1:0] gotDamage,
    output reg [1:0] dodging
    );

    initial state = 0;
    initial dodging=0;
    reg [26:0] counter = 0;
    
    always@(posedge PixClk)
    begin
        if(state == 0 && enter==1)//enter then running bar
        begin
            state=2;
        end
        else if(state == 2 && Btn==1)//space then dodging
        begin
            state=1;
            counter=0;
            dodging=1; //for player and monster reset to start position
        end
        else if ((e_alive == 0 || p_alive == 0) && state != 0)
            state = 0;
        else
        if(state == 1 &&counter <= 125000000)
        begin
            counter=counter+1;
            dodging=0;
        end
        else
        if(state==1 && counter>=125000000) //  5 sec pass
        begin
            state = 2;
            gotDamage = 1;
        end
        else
            gotDamage=0;
    end
endmodule

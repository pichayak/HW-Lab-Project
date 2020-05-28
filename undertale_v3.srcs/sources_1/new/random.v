`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Romnalin Kitkasetsathaporn
// 
// Create Date: 
// Design Name: 
// Module Name: random
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Dependencies: 
// 
// Revision:
//
// Additional Comments:
// 
/////////////////////////////////////////////////////////////////////////////
module random(
    clk,
    minimum,
    maximum,
    out
);
    //input and output 
    input wire clk;
    input wire [5:0] minimum,maximum;
    output reg [5:0] out;
    
    //initial value
    parameter [5:0] start = 10;
    
    //temporary variables
    reg [5:0] dist;
    reg [5:0] tmp;
    
    initial 
    begin
        out = start;
    end
    
    //random 
    always @(posedge clk)
    begin
        dist = maximum - minimum;
        tmp = $urandom%dist;
        assign 
            out = minimum+tmp;
    end
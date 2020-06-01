`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2020 06:36:49 PM
// Design Name: 
// Module Name: BulletRom
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


module BulletRom(
    input wire [10:0] i_addr, //  need 34*34
    input wire i_clk2,
    output reg [7:0] o_data // (7:0) 8 bit pixel value from Bee.mem
    );

    (*ROM_STYLE="block"*) reg [7:0] memory_array [0:1155]; 

    initial begin
            $readmemh("b1.mem", memory_array);
    end

    always @ (posedge i_clk2)
            o_data <= memory_array[i_addr];  

endmodule


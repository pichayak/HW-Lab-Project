`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2020 10:54:08 PM
// Design Name: 
// Module Name: MonsterRom
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


module MonsterRom2(
    input wire [10:0] i_addr, 
    input wire i_clk2,
    output reg [7:0] o_data
    );

    (*ROM_STYLE="block"*) reg [7:0] memory_array [0:1155]; 

    initial begin
            $readmemh("b2.mem", memory_array);
    end

    always @ (posedge i_clk2)
            o_data <= memory_array[i_addr];  

endmodule

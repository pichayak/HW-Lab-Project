`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2020 07:47:13 PM
// Design Name: 
// Module Name: MembersRom
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


module MembersRom(
    input wire [16:0] i_addr,
    input wire i_clk2,
    output reg [7:0] o_data
    );

    (*ROM_STYLE="block"*) reg [7:0] memory_array [0:66374];

    initial begin
            $readmemh("members.mem", memory_array);
    end

    always @ (posedge i_clk2)
            o_data <= memory_array[i_addr];  

endmodule

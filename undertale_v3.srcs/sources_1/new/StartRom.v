`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2020 08:56:48 PM
// Design Name: 
// Module Name: StartRom
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


module StartRom(
    input wire [13:0] i_addr,
    input wire i_clk2,
    output reg [7:0] o_data
    );

    (*ROM_STYLE="block"*) reg [7:0] memory_array [0:11171];

    initial begin
            $readmemh("start.mem", memory_array);
    end

    always @ (posedge i_clk2)
            o_data <= memory_array[i_addr];  

endmodule


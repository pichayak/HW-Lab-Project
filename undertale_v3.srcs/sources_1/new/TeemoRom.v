`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2020 04:43:36 PM
// Design Name: 
// Module Name: TeemoRom
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


module TeemoRom(
    input wire [13:0] i_addr, 
    input wire i_clk2,
    output reg [7:0] o_data 
    );

    (*ROM_STYLE="block"*) reg [7:0] memory_array [0:9549];

    initial begin
            $readmemh("teemo.mem", memory_array);
    end

    always @ (posedge i_clk2)
            o_data <= memory_array[i_addr];  

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2020 12:03:57 PM
// Design Name: 
// Module Name: runningRom
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


module runningRom(
    input wire [8:0] i_addr, // 
    input wire i_clk2,
    output reg [7:0] o_data // 
    );

    (*ROM_STYLE="block"*) reg [7:0] memory_array [0:264]; 

    initial begin
            $readmemh("running_bar.mem", memory_array);
    end

    always @ (posedge i_clk2)
            o_data <= memory_array[i_addr];  

endmodule
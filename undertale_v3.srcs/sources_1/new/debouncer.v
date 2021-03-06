`timescale 1ns / 1ps
// Keyboard Demo: https://github.com/Digilent/Basys-3-Keyboard
module debouncer(
    input clk,
    input I,
    output reg O
    );
    parameter COUNT_MAX=255, COUNT_WIDTH=8;
    reg [COUNT_WIDTH-1:0] count;
    reg s=0;
    always@(posedge clk)
        if (I == s) 
        begin
            if (count == COUNT_MAX)
                O <= I;
            else
                count <= count + 1'b1;
        end 
        else 
            begin
                count <= 'b0;
                s <= I;
            end
    
endmodule

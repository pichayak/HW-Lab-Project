//--------------------------------------------------
// vga640x480 Module : Digilent Basys 3               
// Onboard clock 100MHz
// VGA Resolution 640x480 @ 60Hz : Pixel Clock 25MHz
//--------------------------------------------------
`timescale 1ns / 1ps

// Setup vga640x480 Module
module vga640x480(
    input wire i_clk, 
    input wire i_rst, 
    output wire o_hsync, 
    output wire o_vsync, 
    output wire o_active,
    output wire [9:0] o_x,
    output wire [9:0] o_y, 
    output reg pix_clk 
    );

    localparam HSYNCSTART = 16; 
    localparam HSYNCEND = 16 + 96; 
    localparam HACTIVESTART = 16 + 96 + 48; 
    localparam HACTIVEEND = 16 + 96 + 48 + 640; 
    reg [9:0] H_SCAN; 
    
    localparam VSYNCSTART = 10;
    localparam VSYNCEND = 10 + 2;
    localparam VACTIVESTART = 10 + 2 + 33; 
    localparam VACTIVEEND = 10 + 2 + 33 + 480; 
    reg [9:0] V_SCAN; 

    assign o_hsync = ~((H_SCAN >= HSYNCSTART) & (H_SCAN < HSYNCEND));
    assign o_vsync = ~((V_SCAN >= VSYNCSTART) & (V_SCAN < VSYNCEND));
   
    assign o_x = (H_SCAN < HACTIVESTART) ? 0 : (H_SCAN - HACTIVESTART);
    assign o_y = (V_SCAN < VACTIVESTART) ? 0 : (V_SCAN - VACTIVESTART);

    assign o_active = ~((H_SCAN < HACTIVESTART) | (V_SCAN < VACTIVESTART)); 
    
    reg [15:0] counter1;
    always @(posedge i_clk)
        {pix_clk, counter1} <= counter1 + 16'h4000; 
        
    always @ (posedge i_clk)
    begin

        if (i_rst)
        begin
            H_SCAN <= 0;
            V_SCAN <= 0;
        end

        if (pix_clk)  
        begin
            if (H_SCAN == HACTIVEEND) 
            begin
                H_SCAN <= 0;
                V_SCAN <= V_SCAN + 1;
            end
            else 
                H_SCAN <= H_SCAN + 1; 

            if (V_SCAN == VACTIVEEND)  
                V_SCAN <= 0;
        end
    end
endmodule

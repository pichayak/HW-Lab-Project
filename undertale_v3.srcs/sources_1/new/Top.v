//--------------------------------------------------
// Top Module : Digilent Basys 3               
// BeeInvaders Tutorial 2 : Onboard clock 100MHz
// VGA Resolution 640x480 @ 60Hz : Pixel Clock 25MHz
//--------------------------------------------------
`timescale 1ns / 1ps

module Top(
    input wire CLK, // Onboard clock 100MHz : INPUT Pin W5
    input wire RESET, // Reset button : INPUT Pin U18
    input wire PS2Data,                    // ps2 data line
    input wire PS2Clk,                     // ps2 clock line
    output [0:6] LED_out,                  // Cathodes for 7 segment displays (timed assign)
    output [3:0] Anode_Activate,            // 7 segment digit selector (timed) 
    output wire HSYNC, // VGA horizontal sync : OUTPUT Pin P19
    output wire VSYNC, // VGA vertical sync : OUTPUT Pin R19
    output reg [3:0] RED, // 4-bit VGA Red : OUTPUT Pin G19, Pin H19, Pin J19, Pin N19
    output reg [3:0] GREEN, // 4-bit VGA Green : OUTPUT Pin J17, Pin H17, Pin G17, Pin D17
    output reg [3:0] BLUE // 4-bit VGA Blue : OUTPUT Pin N18, Pin L18, Pin K18, Pin J18/ 4-bit VGA Blue : OUTPUT Pin N18, Pin L18, Pin K18, Pin J18
    );
     
    wire rst = RESET; // Setup Reset button
    
    //state game
    reg [1:0] state = 0; //1 = attacking, 2 = fighting

    // instantiate vga640x480 code
    wire [9:0] x; // pixel x position: 10-bit value: 0-1023 : only need 800
    wire [9:0] y; // pixel y position: 10-bit value: 0-1023 : only need 525
    wire active; // high during active pixel drawing
    vga640x480 display (.i_clk(CLK),.i_rst(rst),.o_hsync(HSYNC), 
                        .o_vsync(VSYNC),.o_x(x),.o_y(y),.o_active(active));
      
    // instantiate GroupName code
    wire [1:0] GroupnameSpriteOn; // 1=on, 0=off
    wire [7:0] dout; // pixel value from Bee.mem
    GroupnameSprite GroupnameDisplay (.i_clk(CLK),.i_rst(rst),.xx(x),.yy(y),.aactive(active),
                          .GroupnameSpriteOn(GroupnameSpriteOn),.dataout(dout));
  
    // instantiate Members code
    wire [1:0] MembersSpriteOn; // 1=on, 0=off
    wire [7:0] mout; // pixel value from Members.mem
    MembersSprite MembersDisplay (.i_clk(CLK),.i_rst(rst),.xx(x),.yy(y),.aactive(active),
                          .MembersSpriteOn(MembersSpriteOn),.membersout(mout));
                          
    // instantiate Start code
    wire [1:0] StartSpriteOn; // 1=on, 0=off
    wire [7:0] sout; // pixel value from Members.mem
    StartSprite StartDisplay (.i_clk(CLK),.i_rst(rst),.xx(x),.yy(y),.aactive(active),
                          .StartSpriteOn(StartSpriteOn),.startout(sout));
                          
    // load colour palette
    reg [7:0] palette [0:191]; // 8 bit values from the 192 hex entries in the colour palette
    reg [7:0] COL = 0; // background colour palette value
    initial begin
        $readmemh("pal24bit.mem", palette); // load 192 hex values into "palette"
    end
    
    //keyboard setup
    wire [7:0] ascii_code;
    
    keyboard keyboard (.clk(CLK),.reset(rst), .PS2Data(PS2Data), .PS2Clk(PS2Clk),
        .ascii_code(ascii_code), .LED_out(LED_out), .Anode_Activate(Anode_Activate));
    // signal declaration

//	wire scan_code_ready;
//	wire letter_case;
    // instantiate keyboard scan code circuit
//	keyboard kb_unit (.clk(CLK), .reset(RESET), .PS2Data(PS2Data), .PS2Clk(PS2Clk),
//			 .scan_code(scan_code), .scan_code_ready(scan_code_ready), .letter_case_out(letter_case));
	// instantiate key-to-ascii code conversion circuit
//	key2ascii k2a_unit (.letter_case(letter_case), .scan_code(scan_code), .ascii_code(ascii_code));

    always @ (*)
    begin
        if (ascii_code[7:0] == 8'h20) // type space to change state to 2
            state = 2'b10;
        else
//        if (ascii_code[7:0] == 8'h2A)
//            state = 1;
//        else
        if (ascii_code[7:0] == 8'h61) //type a to change state to 1
            state = 2'b01;
        else
            state = 0;
    end
    
    // draw on the active area of the screen
    always @ (posedge CLK)
    begin
        if (active && state == 0)
            begin
                if (GroupnameSpriteOn==1)
                    begin
                        RED <= (palette[(dout*3)])>>4; // RED bits(7:4) from colour palette
                        GREEN <= (palette[(dout*3)+1])>>4; // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(dout*3)+2])>>4; // BLUE bits(7:4) from colour palette
                    end
                else
                if (MembersSpriteOn == 1)
                    begin
                        RED <= (palette[(mout*3)])>>4; // RED bits(7:4) from colour palette
                        GREEN <= (palette[(mout*3)+1])>>4; // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(mout*3)+2])>>4; // BLUE bits(7:4) from colour palette
                    end
                else
                if (StartSpriteOn == 1)
                    begin
                        RED <= (palette[(sout*3)])>>4; // RED bits(7:4) from colour palette
                        GREEN <= (palette[(sout*3)+1])>>4; // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(sout*3)+2])>>4; // BLUE bits(7:4) from colour palette
                    end
                else
                    begin
                        RED <= (palette[(COL*3)])>>4; // RED bits(7:4) from colour palette
                        GREEN <= (palette[(COL*3)+1])>>4; // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(COL*3)+2])>>4; // BLUE bits(7:4) from colour palette
                    end
            end
        else
        if (state == 2'b01)
            begin
                RED <= (palette[(dout*3)])>>4; // RED bits(7:4) from colour palette
                GREEN <= (palette[(dout*3)+1])>>4; // GREEN bits(7:4) from colour palette
                BLUE <= (palette[(dout*3)+2])>>4; // BLUE bits(7:4) from colour palette
            end
        else
        if (state == 2'b10)
            begin
                RED <= (palette[(sout*3)])>>4; // RED bits(7:4) from colour palette
                GREEN <= (palette[(sout*3)+1])>>4; // GREEN bits(7:4) from colour palette
                BLUE <= (palette[(sout*3)+2])>>4; // BLUE bits(7:4) from colour palette
            end
        else
        if (state == 2'b11)
            begin
                RED <= (palette[(mout*3)])>>4; // RED bits(7:4) from colour palette
                GREEN <= (palette[(mout*3)+1])>>4; // GREEN bits(7:4) from colour palette
                BLUE <= (palette[(mout*3)+2])>>4; // BLUE bits(7:4) from colour palette
            end
        else
            begin
                RED <= 0; // set RED, GREEN & BLUE
                GREEN <= 0; // to "0" when x,y outside of
                BLUE <= 0; // the active display area
            end
    end
endmodule

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
    reg [2:0] state = 0; //1 = attacking, 2 = dodging

    // instantiate vga640x480 code
    wire [9:0] x; // pixel x position: 10-bit value: 0-1023 : only need 800
    wire [9:0] y; // pixel y position: 10-bit value: 0-1023 : only need 525
    wire active; // high during active pixel drawing
    wire PixCLK; // 25MHz pixel clock
    vga640x480 display (.i_clk(CLK),.i_rst(rst),.o_hsync(HSYNC), 
                        .o_vsync(VSYNC),.o_x(x),.o_y(y),.o_active(active),
                        .pix_clk(PixCLK));
//keyboard setup
    wire [7:0] ascii_code;
    
    keyboard keyboard (.clk(PixCLK),.reset(rst), .PS2Data(PS2Data), .PS2Clk(PS2Clk),
        .ascii_code(ascii_code), .LED_out(LED_out), .Anode_Activate(Anode_Activate));
    
//members page      
    // instantiate GroupName code
    wire [1:0] GroupnameSpriteOn; // 1=on, 0=off
    wire [7:0] dout; // pixel value from Bee.mem
    GroupnameSprite GroupnameDisplay (.i_clk(PixCLK),.i_rst(rst),.xx(x),.yy(y),.aactive(active),
                          .GroupnameSpriteOn(GroupnameSpriteOn),.dataout(dout));
    // instantiate Members code
    wire [1:0] MembersSpriteOn; // 1=on, 0=off
    wire [7:0] mout; // pixel value from Members.mem
    MembersSprite MembersDisplay (.i_clk(PixCLK),.i_rst(rst),.xx(x),.yy(y),.aactive(active),
                          .MembersSpriteOn(MembersSpriteOn),.membersout(mout));                     
    // instantiate Start code
    wire [1:0] StartSpriteOn; // 1=on, 0=off
    wire [7:0] sout; // pixel value from Members.mem
    StartSprite StartDisplay (.i_clk(PixCLK),.i_rst(rst),.xx(x),.yy(y),.aactive(active),
                          .StartSpriteOn(StartSpriteOn),.startout(sout));

// instantiate attacking code    
    wire [1:0] runningOn;
    wire [7:0] runningOut; 
    wire [1:0] scaleOn;
    wire [7:0] scaleOut;
    wire [7:0] damage; 
    attack Attacking (.i_clk(PixCLK),.i_rst(rst),.xx(x),.yy(y), .aactive(active), 
        .button(ascii_code), .damage(damage), 
        .runningOut(runningOut),.runningOn(runningOn)
        ,.scaleOut(scaleOut), .scaleOn(scaleOn) );

// instatiate dodging code
    wire [1:0] CharacterOn;
    wire [7:0] CharacterOut;
    Player player (.clk(PixCLK), .x(x), .y(y), .aactive(active),
        .button(ascii_code), .character_on(CharacterOn), .character_out(CharacterOut));
    
    //instanitiate border
//    wire [4:0] red, green, blue;
//    gameBorder GameBorder (.x(x), .y(y), .red(red), .green(green), .blue(blue));  
            
    //instanitiate monster
    wire [1:0] b1_on, b2_on, b3_on;
    wire [7:0] b1Out, b2Out, b3Out;
    Monster1 mosnter1 (.clk(PixCLK), .x(x), .y(y), .aactive(active),
         .b1_on(b1_on), .b1_out(b1Out));
    Monster2 mosnter2 (.clk(PixCLK), .x(x), .y(y), .aactive(active),
         .b2_on(b2_on), .b2_out(b2Out));
    Monster3 mosnter3 (.clk(PixCLK), .x(x), .y(y), .aactive(active),
         .b3_on(b3_on), .b3_out(b3Out));
    
    // load colour palette
    reg [7:0] palette [0:191]; // 8 bit values from the 192 hex entries in the colour palette
    reg [7:0] COL = 0; // background colour palette value
    initial begin
        $readmemh("pal24bit.mem", palette); // load 192 hex values into "palette"
    end
    
    always @ (*)
    begin //state 0 = first page
        if (ascii_code[7:0] == 8'h20) // type space to change state to 2
            state = 2;
        else  if (ascii_code[7:0] == 8'h0D) //type enter to change state to 1
            state = 1;
        else
            begin
            
            end
    end
     
    // draw on the active area of the screen
    always @ (posedge PixCLK)
    begin
//0   group 
        if (active && state == 0) //display group name
            begin
                if (GroupnameSpriteOn==1)
                    begin
                        RED <= (palette[(dout*3)])>>4; // RED bits(7:4) from colour palette
                        GREEN <= (palette[(dout*3)+1])>>4; // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(dout*3)+2])>>4; // BLUE bits(7:4) from colour palette
                    end
                else if (MembersSpriteOn == 1)
                    begin
                        RED <= (palette[(mout*3)])>>4; // RED bits(7:4) from colour palette
                        GREEN <= (palette[(mout*3)+1])>>4; // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(mout*3)+2])>>4; // BLUE bits(7:4) from colour palette
                    end
                else if (StartSpriteOn == 1)
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
//1 enemy   "enter"         
        else if (state == 1) //state 1 test display enemy
            begin
                if (CharacterOn == 1) 
                    begin
                        RED <= (palette[(CharacterOut*3)])>>4; 
                        GREEN <= (palette[(CharacterOut*3)+1])>>4; 
                        BLUE <= (palette[(CharacterOut*3)+2])>>4; 
                    end
                else if (b1_on == 1)
                    begin
                        RED <= (palette[(b1Out*3)])>>4; 
                        GREEN <= (palette[(b1Out*3)+1])>>4; 
                        BLUE <= (palette[(b1Out*3)+2])>>4; 
                    end
                else if (b2_on == 1)
                    begin
                        RED <= (palette[(b2Out*3)])>>4; 
                        GREEN <= (palette[(b2Out*3)+1])>>4; 
                        BLUE <= (palette[(b2Out*3)+2])>>4; 
                    end
                else if (b3_on == 1)
                    begin
                        RED <= (palette[(b3Out*3)])>>4; 
                        GREEN <= (palette[(b3Out*3)+1])>>4; 
                        BLUE <= (palette[(b3Out*3)+2])>>4; 
                    end
                else
                    begin
                        RED <= (palette[(COL*3)])>>4; // RED bits(7:4) from colour palette
                        GREEN <= (palette[(COL*3)+1])>>4; // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(COL*3)+2])>>4; // BLUE bits(7:4) from colour palette
                    end
            end
//2 dodging             
        else if (state == 2) //state 2 character create ( dodging )
            begin
                if(scaleOn == 1)
                    begin
                        RED <= (palette[(scaleOut*3)])>>4; // RED bits(7:4) from colour palette
                        GREEN <= (palette[(scaleOut*3)+1])>>4; // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(scaleOut*3)+2])>>4; // BLUE bits(7:4) from colour palette
                    end
                else if(runningOn == 1)
                    begin
                        RED <= (palette[(runningOut*3)])>>4; // RED bits(7:4) from colour palette
                        GREEN <= (palette[(runningOut*3)+1])>>4; // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(runningOut*3)+2])>>4; // BLUE bits(7:4) from colour palette
                    end
                else
                    begin
                        RED <= (palette[(COL*3)])>>4; // RED bits(7:4) from colour palette
                        GREEN <= (palette[(COL*3)+1])>>4; // GREEN bits(7:4) from colour palette
                        BLUE <= (palette[(COL*3)+2])>>4; // BLUE bits(7:4) from colour palette
                    end
            end
 //3 border           
//        else if ( state == 3) //test border type "z"
//            begin
//                RED <= red;
//                GREEN <= green;
//                BLUE <= blue;
//                RED <= (palette[(mout*3)])>>4; // RED bits(7:4) from colour palette
//                GREEN <= (palette[(mout*3)+1])>>4; // GREEN bits(7:4) from colour palette
//                BLUE <= (palette[(mout*3)+2])>>4; // BLUE bits(7:4) from colour palette
//            end
        else
            begin
                RED <= 0; // set RED, GREEN & BLUE
                GREEN <= 0; // to "0" when x,y outside of
                BLUE <= 0; // the active display area
            end
    end
endmodule

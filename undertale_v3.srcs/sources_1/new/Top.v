//--------------------------------------------------
// Top Module : Digilent Basys 3               
// BeeInvaders Tutorial 2 : Onboard clock 100MHz
// VGA Resolution 640x480 @ 60Hz : Pixel Clock 25MHz
// 
// Online resources
// Inspired by
// BeeInvader Project: https://github.com/AdrianFPGA/basys3
// Keyboard Demo: https://github.com/Digilent/Basys-3-Keyboard
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
    wire [1:0] state; //0= start, 1 = attacking, 2 = dodging
    //Collision
    wire [1:0] onCollision_b1;
    wire [1:0] onCollision_b2;
    wire [1:0] onCollision_b3;
    wire [1:0] dodging;
    
    // instantiate vga640x480 code
    wire [9:0] x; // pixel x position: 10-bit value: 0-1023 : only need 800
    wire [9:0] y; // pixel y position: 10-bit value: 0-1023 : only need 525
    wire active; // high during active pixel drawing
    wire PixCLK; // 25MHz pixel clock
    vga640x480 display (.i_clk(CLK),.i_rst(rst),.o_hsync(HSYNC), 
                        .o_vsync(VSYNC),.o_x(x),.o_y(y),.o_active(active),
                        .pix_clk(PixCLK));
                        
//keyboard setup
    wire w, a, s, d, space, enter;
    wire [15:0] code;
    keyboard2 keyboard (.clk(PixCLK),.PS2Data(PS2Data),.PS2Clk(PS2Clk),
        .w(w),.s(s),.a(a),.d(d),.space(space),.enter(enter), .keycodev(code));
    
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
    wire [7:0] pdamage; 
    wire [1:0] target;
    attack Attacking (.i_clk(PixCLK),.i_rst(rst),.xx(x),.yy(y), .aactive(active),.button(space)
        ,.pdamage(pdamage), .target(target), .runningOut(runningOut),.runningOn(runningOn), 
        .state(state), .scaleOut(scaleOut), .scaleOn(scaleOn) );
    
    //display damage on 7Seg for debug
    Seven_segment_LED_Display_Controller SevenSeg (.clk(PixCLK), .reset(RESET),
        .ascii_code(onCollision_b3), .Anode_Activate(Anode_Activate),.LED_out(LED_out));
    
    //teemo
    wire [1:0] TeemoOn; // 1=on, 0=off
    wire [7:0] TeemoOut; 
    Teemo Teemo (.i_clk(PixCLK),.i_rst(rst),.xx(x),.yy(y),.aactive(active),
                          .TeemoOn(TeemoOn),.TeemoOut(TeemoOut));
    //Timer
    wire [1:0] gotDamage;
    wire [1:0] p_alive, e_alive;       
    Timer Timer(.PixClk(PixCLK),.Btn(space), .enter(enter), .state(state),
        .p_alive(p_alive), .e_alive(e_alive), 
        .gotDamage(gotDamage), .dodging(dodging));   
        
// instatiate dodging code
    wire [1:0] CharacterOn;
    wire [7:0] CharacterOut;
    Player player (.clk(PixCLK), .x(x), .y(y), .aactive(active),
        .w(w),.s(s),.a(a),.d(d), .dodging(dodging),
        .character_on(CharacterOn), .character_out(CharacterOut));
    
    //instanitiate border
    wire [7:0] red, green, blue;
    wire [1:0] border_on;
    gameBorder GameBorder (.clk(PixCLK), .x(x), .y(y), .red(red), .green(green), .blue(blue), .border_on(border_on));  
            
    //instanitiate monster
    wire [1:0] b1_on, b2_on, b3_on;
    wire [7:0] b1Out, b2Out, b3Out;
    Monster1 mosnter1 (.clk(PixCLK), .x(x), .y(y), .aactive(active),.dodging(dodging),
         .b1_on(b1_on), .b1_out(b1Out), .onCollision_b1(onCollision_b1));
    Monster2 mosnter2 (.clk(PixCLK), .x(x), .y(y), .aactive(active),.dodging(dodging),
         .b2_on(b2_on), .b2_out(b2Out), .onCollision_b2(onCollision_b2));
    Monster3 mosnter3 (.clk(PixCLK), .x(x), .y(y), .aactive(active),.dodging(dodging),
         .b3_on(b3_on), .b3_out(b3Out), .onCollision_b3(onCollision_b3));
    
    wire [7:0] og_red, og_green, og_blue;
    wire [1:0] ogOn,onCollision_og;
    ObstacleGreen OG (.Clk(PixCLK), .x(x), .y(y), .red(og_red), .green(og_green)
        , .blue(og_blue), .ogOn(ogOn), .onCollision_og(onCollision_og));
        
    wire [7:0] ob_red, ob_green, ob_blue;
    wire [1:0] obOn,onCollision_ob;
    ObstacleBlue OB (.Clk(PixCLK), .x(x), .y(y), .red(ob_red), .green(ob_green)
        , .blue(ob_blue), .obOn(obOn), .onCollision_ob(onCollision_ob));
        
    wire [7:0] obXL_red, obXL_green, obXL_blue;
    wire [1:0] obXLOn,onCollision_obXL;
    ObstacleBlueXL OBXL (.Clk(PixCLK), .x(x), .y(y), .red(obXL_red), .green(obXL_green)
        , .blue(obXL_blue), .obXLOn(obXLOn), .onCollision_obXL(onCollision_obXL));
        
    wire [7:0] ogr_red, ogr_green, ogr_blue;
    wire [1:0] ogreyOn;
    ObstacleGrey OGrey (.Clk(PixCLK), .x(x), .y(y), .red(ogr_red), .green(ogr_green)
        , .blue(ogr_blue), .ogreyOn(ogreyOn));
        
    // load global colour palette
    reg [7:0] palette [0:191]; 
    reg [7:0] COL = 0; 
    initial begin
        $readmemh("pal24bit.mem", palette);
    end
    
    //OnCollision
    OnCollision Collision (.PixClk(PixCLK), .b1_on(b1_on), .b2_on(b2_on), .b3_on(b3_on),
        .obOn(obOn), .ogOn(ogOn),.obXLOn(obXLOn),
        .CharacterOn(CharacterOn), .target(target),
        .onCollision_b1(onCollision_b1), .onCollision_b2(onCollision_b2),
        .onCollision_b3(onCollision_b3), .onCollision_ob(onCollision_ob),
        .onCollision_og(onCollision_og), .onCollision_obXL(onCollision_obXL),
        .state(state), .dodging(dodging));
 //hp bar
    wire [7:0] red_hp, green_hp, blue_hp;
    wire [1:0] hpOn;         
    Hp Hp (.Clk(PixCLK),.x(x),.y(y),.damage(pdamage),
        .b1_on(b1_on), .b2_on(b2_on),.b3_on(b3_on),.ogOn(ogOn), .obOn(obOn), .obXLOn(obXLOn),
        .onCollision_b1(onCollision_b1), .onCollision_b2(onCollision_b2),
        .onCollision_b3(onCollision_b3), .onCollision_ob(onCollision_ob),
        .onCollision_og(onCollision_og), .onCollision_obXL(onCollision_obXL),
        .target(target),.red(red_hp),.green(green_hp),
        .blue(blue_hp), .p_alive(p_alive), .e_alive(e_alive),
        .hpOn(hpOn), .gotDamage(gotDamage), .state(state)); 
         
    // draw on the active area of the screen
    always @ (posedge PixCLK)
    begin
//0   group 
        if (active && state == 0) //display group name
            begin
                if (GroupnameSpriteOn==1)
                    begin
                        RED <= (palette[(dout*3)])>>4; 
                        GREEN <= (palette[(dout*3)+1])>>4; 
                        BLUE <= (palette[(dout*3)+2])>>4; 
                    end
                else if (MembersSpriteOn == 1)
                    begin
                        RED <= (palette[(mout*3)])>>4; 
                        GREEN <= (palette[(mout*3)+1])>>4;
                        BLUE <= (palette[(mout*3)+2])>>4; 
                    end
                else if (StartSpriteOn == 1)
                    begin
                        RED <= (palette[(sout*3)])>>4; 
                        GREEN <= (palette[(sout*3)+1])>>4; 
                        BLUE <= (palette[(sout*3)+2])>>4; 
                    end
                else
                    begin
                        RED <= (palette[(COL*3)])>>4; 
                        GREEN <= (palette[(COL*3)+1])>>4; 
                        BLUE <= (palette[(COL*3)+2])>>4; 
                    end
            end
//1 dodging      
        else if (active && state == 1) //character create ( dodging )
            begin
                if(border_on == 1)
                    begin
                        RED <= red;
                        GREEN <= green;
                        BLUE <= blue;
                    end
                else if (CharacterOn == 1) 
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
                else if (ogOn == 1)
                    begin
                        RED <= og_red; 
                        GREEN <= og_green; 
                        BLUE <= og_blue; 
                    end
                else if (obOn == 1)
                    begin
                        RED <= ob_red; 
                        GREEN <= ob_green; 
                        BLUE <= ob_blue; 
                    end
                else if (obXLOn == 1)
                    begin
                        RED <= obXL_red; 
                        GREEN <= obXL_green; 
                        BLUE <= obXL_blue; 
                    end
                else if (ogreyOn == 1)
                    begin
                        RED <= ogr_red; 
                        GREEN <= ogr_green; 
                        BLUE <= ogr_blue; 
                    end
                else if (hpOn == 1)
                    begin
                        RED <= red_hp; 
                        GREEN <= green_hp; 
                        BLUE <=  blue_hp; 
                    end
                else
                    begin
                        RED <= (palette[(COL*3)])>>4;
                        GREEN <= (palette[(COL*3)+1])>>4; 
                        BLUE <= (palette[(COL*3)+2])>>4;
                    end
            end
//2 running bar   "space"          
        else if (active && state == 2) //state 2 running
            begin
                if (scaleOn == 1)
                    begin
                        RED <= (palette[(scaleOut*3)])>>4; 
                        GREEN <= (palette[(scaleOut*3)+1])>>4;
                        BLUE <= (palette[(scaleOut*3)+2])>>4; 
                    end
                else if (runningOn == 1)
                    begin
                        RED <= (palette[(runningOut*3)])>>4; 
                        GREEN <= (palette[(runningOut*3)+1])>>4;
                        BLUE <= (palette[(runningOut*3)+2])>>4; 
                    end
                else if (hpOn == 1)
                    begin
                        RED <= red_hp; 
                        GREEN <= green_hp; 
                        BLUE <=  blue_hp; 
                    end
                else if (TeemoOn == 1)
                    begin 
                        RED <= (palette[(TeemoOut*3)])>>4; 
                        GREEN <= (palette[(TeemoOut*3)+1])>>4;
                        BLUE <= (palette[(TeemoOut*3)+2])>>4; 
                    end
                else
                    begin
                        RED <= (palette[(COL*3)])>>4; 
                        GREEN <= (palette[(COL*3)+1])>>4; 
                        BLUE <= (palette[(COL*3)+2])>>4; 
                    end
            end
        else
            begin
                RED <= 0; 
                GREEN <= 0; 
                BLUE <= 0; 
            end
    end
endmodule

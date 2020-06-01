`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2020 02:37:00 AM
// Design Name: 
// Module Name: keyboard
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


module keyboard  // credit for formatting to embeddedthgouhts.com (Reference 5)
    (
//	      input wire clk, reset,
//        input wire PS2Data, PS2Clk,          // ps2 data and clock lines
//        output wire [7:0] scan_code,         // scan_code received from keyboard to process
//        output wire [7:0] led,               // For Degub Purposes (test scan codes are working)
//        output wire scan_code_ready,         // signal to outer controlsystem to sample scan_code
//        output wire letter_case_out          // output determines if scan code is converted to 
//                                             // lower or upper ascii code for a key

	    input wire clk, reset,                 // Bsys 3 System clock & reset (assignable)
        input wire PS2Data,                    // ps2 data line
        input wire PS2Clk,
        output wire [7:0] ascii_code,                     // ps2 clock line
        output [0:6] LED_out,                  // Cathodes for 7 segment displays (timed assign)
        output [3:0] Anode_Activate            // 7 segment digit selector (timed)                    
    );
/////////////////////////////////////////////////////////////////////////////////////////////////

//#############################################################################################//
///////////////////////   Begin Port, Signal, & Constant  Declarations   ////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
// Explanation: use reg to hold previous value until new value is sent to it
// Examples: ou1, ou2, [1:0]sw, [1:0]led;
// constant declarations
    localparam  // these parameters to not belong to any other data type such as net or reg
            BREAK    = 8'hf0,       // break code
            SHIFT1   = 8'h12,       // first shift scan
            SHIFT2   = 8'h59,       // second shift scan
            CAPS     = 8'h58;       // caps lock

    // FSM symbolic states
    localparam [2:0] 
            lowercase          = 3'b000, // idle, process lower case letters
            ignore_break       = 3'b001, // ignore repeated scancode after break code -F0- rcvd
            shift              = 3'b010, // process uppercase letters for shift key held
            ignore_shift_break = 3'b011, // chk scancode after F0, either idle or go back to uCase
            capslock           = 3'b100, // process uppercase letter after capslock button pressed
            ignore_caps_break  = 3'b101; // chk scancode after F0, either ignore repeat, 
                                         // or decrement caps_num


    // internal signal declarations
    reg [2:0] state_reg, state_next;           // FSM state register and next state logic
    wire [7:0] scan_out;                       // scan code received from keyboard
    reg got_code_tick;                         // asserted to write curr scancode rcvd to FIFO
    wire scan_done_tick;                       // asserted to signal that ps2_rx has rcvd a scancode
    reg letter_case;                           // 0=lwrCase, 1=upCase, o/p 2 convert scancode 2 ascii
    reg [7:0] shift_type_reg, shift_type_next; // register holds scancodes of shiftkeys or capslock
    reg [1:0] caps_num_reg, caps_num_next;     // tracks num capslockscancodes rcvd in capslock state
                                               //      (3 before going back to lowecase state)
    wire [7:0] scan_code;                      // scan_code received from keyboard to process
    wire scan_code_ready;                      // signal to outer controlsystem to sample scan_code
    wire letter_case_out;                      // output determines if scan code is converted to   
//    wire [7:0] ascii_code;                     // output of instant'd module fed into 7seg disp.

    
//#############################################################################################//
///////////////////////       Begin External Module Instantiations       ////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
    ps2_rx ps2_rx_unit (// instantiate ps2 receiver (project dependency)
        .clk(clk), 
        .reset(reset), 
        .rx_en(1'b1), 
        .PS2Data(PS2Data), 
        .PS2Clk(PS2Clk),
        .rx_done_tick(scan_done_tick),
        .rx_data(scan_out)
        );
                                      
    key2ascii key2ascii (// instantiate key2ascii (project dependency)
        .letter_case(letter_case), 
        .scan_code(scan_code), 
        .ascii_code(ascii_code)
        );
    
    Seven_segment_LED_Display_Controller Seven_segment_LED_Display_Controller (// 7segDisContr
        .clk(clk), 
        .reset(reset),  
        .Anode_Activate(Anode_Activate), 
        .LED_out(LED_out),
        .ascii_code(ascii_code)
        );

/////////////////////////////////////////////////////////////////////////////////////////////////                                   

//#############################################################################################//
////////////////////////////////   Begin System Description   ///////////////////////////////////
////////////////////////////////      Dataflow Modeling       ///////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
//FSM next state logic
always @* // any change in the input signals will trigger the state machine case statement
    begin

    // defaults
    got_code_tick   = 1'b0;
    letter_case     = 1'b0;
    caps_num_next   = caps_num_reg;
    shift_type_next = shift_type_reg;
    state_next      = state_reg;

    case(state_reg)
    /////////////////////////////////////////////////////////////////////////////////////////////
    // State 1: Processes lwrcase key strokes, go to uppercase state to process shift/capslock //
    /////////////////////////////////////////////////////////////////////////////////////////////
       lowercase:
       begin
        if(scan_done_tick)                        // if scan code received
            begin
            if(scan_out == SHIFT1 || scan_out == SHIFT2) // if code is shift
                begin
                shift_type_next = scan_out;       // record which shift key was pressed
                state_next = shift;               // go to shift state
                end
            else if(scan_out == CAPS)             // if code is capslock
                begin                             // set caps_num to 3, num of capslock scancodes
                caps_num_next = 2'b11;            // to receive before going back to lwrCase               
                state_next = capslock;            // go to capslock state
                end
            else if (scan_out == BREAK)           // else if code is break code
                state_next = ignore_break;        // go to ignore_break state
            else                                  // else if code is none of the above
                got_code_tick = 1'b1;             // assert got_code_tick 2 write scan_out 2 FIFO
            end
        end

    /////////////////////////////////////////////////////////////////////////////////////////////
    // State 2: Ignores repeated scan code after break code FO received in lowercase state   // 
    /////////////////////////////////////////////////////////////////////////////////////////////
       ignore_break:
       begin
        if(scan_done_tick) state_next = lowercase;// if scancode received, goback 2 lwrCase state 
       end

    /////////////////////////////////////////////////////////////////////////////////////////////
    // State 3: Processes scan codes after shift received in lowercase state                   //
    /////////////////////////////////////////////////////////////////////////////////////////////
       shift:
       begin
           letter_case = 1'b1;                      // routed out to convert scan code to
                                                    // upper value for a key
           if(scan_done_tick)                       // if scan code received,
           begin
            if(scan_out == BREAK)                   // if code is break code                      
                state_next = ignore_shift_break;    // go to ignore_shift_break state to
                                                    // ignore repeated scan code after F0
            // else if code is not shift/capslock
            else if(scan_out != SHIFT1 && scan_out != SHIFT2 && scan_out != CAPS)
                got_code_tick = 1'b1;               // assert got_code_tick 2 write scan_out 2 FIFO
           end
       end
    
     /////////////////////////////////////////////////////////////////////////////////////////////
     // State 4: Ignores repeated scan code after break code F0 received in shift state         //
     /////////////////////////////////////////////////////////////////////////////////////////////
        ignore_shift_break:
         begin
         if(scan_done_tick)                      // if scan code received
             begin
             if(scan_out == shift_type_reg)      // if scan code is shift key initially pressed
                 state_next = lowercase;         // shft/capslock key unpressed, goback 2 lwrCase state
             else                                // else repeated scan code received,
             state_next = shift;                 // go back to uppercase state
             end
         end

     /////////////////////////////////////////////////////////////////////////////////////////////
     // State 5: Processes scan codes after capslock code received in lowecase state            //
     /////////////////////////////////////////////////////////////////////////////////////////////
        capslock:
         begin
         letter_case = 1'b1;                                    // routed out to convert scan code
                                                                // to upper value for a key
         if(caps_num_reg == 0)                                  // if capslock code received 3 times,
             state_next = lowercase;                            // go back to lowecase state
         if(scan_done_tick)                                     // if scan code received
             begin
             if(scan_out == CAPS)                               // if code is capslock,
                caps_num_next = caps_num_reg - 1;               // decrement caps_num
             else if(scan_out == BREAK)                         // else if code is break,
                state_next = ignore_caps_break;                 // go to ignore_caps_break state
             else if(scan_out != SHIFT1 && scan_out != SHIFT2)  // else if code isn't a shift key
                got_code_tick = 1'b1;                           // assert got_code_tick to
             end                                                // write scan_out to FIFO
         end
     /////////////////////////////////////////////////////////////////////////////////////////////
     // State 6: Ignores repeated scan code after break code F0 received in capslock state      //
     /////////////////////////////////////////////////////////////////////////////////////////////
        ignore_caps_break:
        begin
            if(scan_done_tick)                                  // if scan code received
                begin
                if(scan_out == CAPS)                            // if code is capslock
                    caps_num_next = caps_num_reg - 1;           // decrement caps_num
                    state_next = capslock;                      // return to capslock state
                end
            end
        endcase  
     end                                                        // end @always
//////////////////////////////////////////////////////////////////////////////////////////////////

// output, route letter_case to output to use during scan to ascii code conversion
assign letter_case_out = letter_case;

// output, route got_code_tick to out control circuit to signal when to sample scan_out
assign scan_code_ready = got_code_tick;

// route scan code data out
assign scan_code = scan_out;

endmodule




module gameover_display(
        input wire [9:0] x,
        input wire [9:0] y,
        output wire [11: 0] gameover_on
    );
    
    //parameter BUS_WIDTH = 12;  
    reg [0:0] ROM [31999:0]; // 400*80
     
    initial begin
        $readmemh("gameover.mem", ROM);
    end
    
    assign gameover_on = (x >= 120 && x < 520 && y >= 200 && y < 280) ? (ROM[(y-200)*240+x-120] ? 3 : 1) : 0;
    
endmodule

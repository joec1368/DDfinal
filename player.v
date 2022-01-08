module player(clock,button_left,button_right,row_count,dot_col, cur_state);
    input clock;
    input button_left,button_right;
	 input [2:0] row_count;
    output reg [7:0]dot_col=0;
	 output [1:0] cur_state;
    /*reg*/wire [1:0]player_state;
   // reg left=0,right=0;
    
   // wire clock_div;
   
    //clk_div_p c10000(.clk(clock),.div_clk(clock_div));
   
    parameter S0=2'b00;//雙手向下
    parameter S1=2'b01;//左下右上
    parameter S2=2'b10;//左上右下
    parameter S3=2'b11;//雙手向上

    //state
    /*always@(button_left or button_right or clock)begin
        left <= button_left;
        right <= button_right;
        player_state <= {left,right};
    end*/
	 assign player_state = {button_left, button_right};
	 assign cur_state = player_state;
	 
    //player's posture
    always@(player_state or row_count)begin
        if(player_state==S0)begin
				case(row_count)
            3'd0: dot_col <= 8'b00000000;
            3'd1: dot_col <= 8'b00011000;
            3'd2: dot_col <= 8'b00011000;
            3'd3: dot_col <= 8'b11111111;
            3'd4: dot_col <= 8'b10011001;
            3'd5: dot_col <= 8'b10111101;
            3'd6: dot_col <= 8'b00100100;
            3'd7: dot_col <= 8'b00100100;
            endcase
				end
        if(player_state==S1)begin
				case(row_count)
            3'd0: dot_col <= 8'b00000000;
            3'd1: dot_col <= 8'b00011001;
            3'd2: dot_col <= 8'b00011001;
            3'd3: dot_col <= 8'b11111111;
            3'd4: dot_col <= 8'b10011000;
            3'd5: dot_col <= 8'b10111100;
            3'd6: dot_col <= 8'b00100100;
            3'd7: dot_col <= 8'b00100100;
            endcase
				end
        if(player_state==S2)begin
				case(row_count)
            3'd0: dot_col <= 8'b00000000;
            3'd1: dot_col <= 8'b10011000;
            3'd2: dot_col <= 8'b10011000;
            3'd3: dot_col <= 8'b11111111;
            3'd4: dot_col <= 8'b00011001;
            3'd5: dot_col <= 8'b00111101;
            3'd6: dot_col <= 8'b00100100;
            3'd7: dot_col <= 8'b00100100;
				endcase
            end
        if(player_state==S3)begin
				case(row_count)
            3'd0: dot_col <= 8'b00000000;
            3'd1: dot_col <= 8'b10011001;
            3'd2: dot_col <= 8'b10011001;
            3'd3: dot_col <= 8'b11111111;
            3'd4: dot_col <= 8'b00011000;
            3'd5: dot_col <= 8'b00111100;
            3'd6: dot_col <= 8'b00100100;
            3'd7: dot_col <= 8'b00100100;
				endcase
            end
    end
endmodule





//10000HZ
`define TimeExpire 32'd2500

module clk_div_p(clk,div_clk);
input clk;
output reg div_clk=0;

reg [31:0] count=0;
always@(posedge clk)begin
        if (count == `TimeExpire)
        begin
            count <= 32'd0;
            div_clk <= ~div_clk;
        end
        else
        begin
            count <= count + 32'd1;
        end
end

endmodule
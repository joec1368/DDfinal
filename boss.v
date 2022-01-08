module boss(clk,right,row_count,dot_col, cur_state, reset, boss_clk/*,scoreout, score10out*/);
    input clk;
    input right; //when player do same action as boss
	 input [2:0] row_count;
    output reg[7:0] dot_col=0;
	 output reg boss_clk;
	 input reset;
	//output [6:0] scoreout, score10out;


	reg clk_div;
	wire start, finish;

	//wire [3:0]  score_p, score10_p;
	
	
	
	 
	 parameter [1:0] UP = 2'b11;  //雙手舉起
    parameter [1:0] DOWN = 2'b00; //雙手放下
    parameter [1:0] LEFTUP = 2'b10; //左手舉起
    parameter [1:0] RIGHTUP = 2'b01;   //右手舉起
	 
    reg [31:0] clk_count=0;
	 output reg[1:0] cur_state=RIGHTUP;
    reg [1:0] next_state=RIGHTUP;
    
    reg[31:0] rightcount=0;
    
/*
   score u_Score(.reset(reset), .score(score_p), .score10(score10_p), .right(right), .clock(clk));
	//seven_p u_Seven(.count(count), .out(out));
	//seven_p u_Seven2(.count(count10), .out(out10));
	seven_p u_Seven3(.count(score_p), .out(scoreout));
	seven_p u_Seven4(.count(score10_p), .out(score10out));
*/
	 
	
	
// frequncy done yet    
    always@(posedge clk ) 
        begin

        if (clk_count == 100000)
            begin 
                clk_count<=32'd0;
                clk_div <= ~clk_div;
					 boss_clk <= clk_div;
					 cur_state <= next_state;
            end
        else
        begin 
            clk_count <= clk_count + 32'd1;
        end
    end
	
	
//state machine done yet, have to check how to use random		
	always@(posedge right)
	begin
		rightcount <= rightcount + 32'd1;

        case (cur_state)
            UP : begin
                if ( rightcount%4 < 3 )
                    next_state = RIGHTUP;
					 else
                    next_state = DOWN;
            end
				
            DOWN : begin
                if ( rightcount%4 < 2)
                    next_state = LEFTUP;
					 else 
						  next_state = RIGHTUP;
				end
            
				RIGHTUP : begin
                if ( rightcount%4 == 0)
					     next_state = UP;
					 else
						  next_state = LEFTUP;
			   end
				
				LEFTUP : begin
                if ( rightcount%4 <= 2  )
					     next_state = DOWN;
					 else begin
                    next_state = UP;
            end
		  end
        endcase
		  
		  
		  
	end
	
	
// behavior done
	 always@ (row_count) begin
			if ( cur_state == UP) begin
            case (row_count)
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
         else if (cur_state == DOWN) begin
            case (row_count)
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
         else if (cur_state == LEFTUP) begin
            case (row_count)
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
         else if (cur_state == RIGHTUP) begin
            case (row_count)
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
	end
endmodule


module seven_p (count, out);
	input[3:0] count;
	output reg [6:0] out;

	always@(*)
	begin
	case(count)
		0: out = 7'b1000000;
		1: out = 7'b1111001;
		2: out = 7'b0100100;
		3: out = 7'b0110000;
		4: out = 7'b0011001;
		5: out = 7'b0010010;
		6: out = 7'b0000010;
		7: out = 7'b1111000;
		8: out = 7'b0000000;
		9: out = 7'b0010000;
		default: out = 7'b000000;
	endcase
end

endmodule
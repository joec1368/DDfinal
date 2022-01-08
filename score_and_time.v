module score_and_time(clock, reset, out, out10, scoreOut, score10Out, correct, start, finish);
	input clock, reset;


	output wire [6:0] out, out10, scoreOut, score10Out;

	output start, finish;
	wire clk_div;
	wire [3:0] count, count10, score, score10;
	
	clk_div u_FreqDiv(.clk(clock), .rst(reset), .div_clk(clk_div));
	counter u_Counter(.clk(clk_div), .reset(reset), .count(count), .count10(count10), .start(start), .finish(finish));

	input correct;
	score u_Score(.reset(reset), .score(score), .score10(score10), .right(correct), .clock(clock));
	seven u_Seven(.count(count), .out(out));
	seven u_Seven2(.count(count10), .out(out10));
	seven u_Seven3(.count(score), .out(scoreOut));
	seven u_Seven4(.count(score10), .out(score10Out));

endmodule

`define TimeExpire_s 32'd25000000
module clk_div(clk, rst, div_clk);
	input clk, rst;
	output reg div_clk;

	reg [31:0] count;

	always@(posedge clk)
	begin
		if(!rst)
		begin
			count <= 32'd0;
			div_clk <= 1'b0;
		end
		else
		begin
			if (count == `TimeExpire_s)
			begin
				count <= 32'd0;
				div_clk <= ~div_clk;
			end
			else
				count <= count + 32'd1;
		end	
	end

endmodule


module seven (count, out);
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
		//default: out = 7'b000000;
		default: out = 7'b1111111;
	endcase
end

endmodule

module counter(clk, reset, count, count10, start, finish);
	input clk, reset;
	output reg [3:0] count, count10;
	output reg start, finish;

	always@(posedge clk or negedge reset)
	begin
		if(!reset)
		begin
			count <= 4'd3;
			count10 <= 4'd0;
		start <= 1'b0;
		finish <= 1'b0;
	end
	else if(finish == 1'b0)
	begin
		if(count == 4'd0)
			begin
			if(start == 1'b1)
				begin
				if(count10 == 4'd0)
					finish <= 1'b1;
				else
					begin
					count <= 4'd9;
					count10 <= count10 - 4'b001;
					end
				end
			else
				begin
					count <= 4'd0;
					count10 <= 4'd3;
					start = 1'b1;
				end
			end
		else
			count <= count - 4'b001;
	end
end

endmodule
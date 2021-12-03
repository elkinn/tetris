module input_delay(input logic clk, reset,
						 input logic [7:0] in,
						 output logic [7:0] out
);
	
	enum logic [3:0] {keycode, h0, h1, h2, h3, h4} curr_state, next_state;
	
	always_ff @ (posedge clk or posedge reset)
	begin
		if (reset) 
			curr_state <= keycode;
		else 
			curr_state <= next_state;
	end
	
	always_comb
	begin
		next_state = curr_state;
		
		unique case(curr_state)
			keycode:
				next_state = h0;
			h0:
				next_state = h1;
			h1:
				next_state = h2;
			h2:
				next_state = h3;
			h3:
				next_state = h4;
			h4:
				next_state = keycode;
		endcase
					
		case(curr_state)
			keycode:
				out = in;
			h0, h1, h2, h3, h4:
				out = 8'h00;
		endcase
	end
endmodule 
module game_logic(input logic        clk, reset, vs, stopFalling, c0, c1, c2, c3, c4, c5, c6, c7, c8, c9,
						input  logic [4:0] x0, x1, x2, x3,
						input  logic [5:0] y0, y1, y2, y3,
						input  logic [7:0] keycode_i,
						output logic       isFalling, isStopped, isLocking, spawnSignal, clearing,
						output logic [9:0] lineFill
);

	int counter, shape;
	enum logic [3:0] {idle, spawn, falling, stopped, locked, lc, clear0, clear1, clear2, clear3, clear4} 
						   curr_state, next_state;
	logic [3:0] lsfr0, lsfr1, lsfr2;
	logic [7:0] keycode;
	
	input_delay i0 (.clk(vs), .reset(reset), .in(keycode_i), .out(keycode));
							
	always_ff @ (posedge clk or posedge reset)
	begin
		if(reset) curr_state <= idle;
		else
		begin
			curr_state <= next_state;
			if(curr_state == stopped || curr_state == clear0 || curr_state == clear1 || curr_state == clear2 || curr_state == clear3 || curr_state == clear4)
				counter <= counter + 1;
			else counter <= 0;
		end
	end

	always_comb
	begin
		next_state = curr_state;
		unique case (curr_state)
			idle:
			begin
				if(keycode == 8'b00101000) next_state = spawn;
				else next_state = idle;
			end
			spawn: next_state = falling;
			falling:
			begin
				if(stopFalling) next_state = stopped;
				else next_state = falling;
			end
			stopped:
			begin
				if(counter == 100000000) next_state = locked;
				else next_state = stopped;
			end
			locked:
			begin
				next_state = lc;
			end
			lc:
			begin
				if(c0 || c1 || c2 || c3 || c4 || c5 || c6 || c7 || c8 || c9) next_state = clear0;
				else next_state = spawn;
			end
			clear0:
			begin
				if(counter == 30000000) next_state = clear1;
				else next_state = clear0;
			end
			clear1:
			begin
				if(counter == 60000000) next_state = clear2;
				else next_state = clear1;
			end
			clear2:
			begin
				if(counter == 90000000) next_state = clear3;
				else next_state = clear2;
			end
			clear3:
			begin
				if(counter == 120000000) next_state = clear4;
				else next_state = clear3;
			end
			clear4:
			begin
				if(counter == 150000000) next_state = spawn;
				else next_state = clear4;
			end
		endcase
		
		//Default Value
		isFalling = 0;
		isStopped = 0;
		isLocking  = 0;
		spawnSignal = 0;
		shape = 0;
		clearing = 0;
		
		case (curr_state)
			spawn: spawnSignal = 1;
			falling: isFalling = 1;
			stopped, lc: isStopped = 1;
			locked:
			begin
				isStopped = 1;
				isLocking = 1;
			end
			clear0, clear1, clear2, clear3, clear4: 
			begin
				clearing = 1;
				isStopped = 1;
			end
			default:;
		endcase
	end
endmodule

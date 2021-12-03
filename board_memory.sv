module board_memory(input logic clk, reset, vs,
						  input logic [4:0] x0, x1, x2, x3,
						  input logic [5:0] y0, y1, y2, y3,
						  output logic lock, stop,
						  output logic [9:0] board [20]
);

	enum logic [2:0] {idle, lock1, lock2, clear0, clear1, clear2, clear3, clear4} curr_state, next_state;
	logic c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, cr0, cr1, cr2, cr3, cr4, cr5, cr6, cr7, cr8, cr9;
	logic [9:0] lineFill;
	int counter, clearDelay;
	
	always_ff @ (posedge clk)
	begin
		if(c0) cr0 <= c0;
		if(c1) cr1 <= c1;
		if(c2) cr2 <= c2;
		if(c3) cr3 <= c3;
		if(c4) cr4 <= c4;
		if(c5) cr5 <= c5;
		if(c6) cr6 <= c6;
		if(c7) cr7 <= c7;
		if(c8) cr8 <= c8;
		if(c9) cr9 <= c9;
		if(curr_state == idle)
		begin
			cr0 <= 0;
			cr1 <= 0;
			cr2 <= 0;
			cr3 <= 0;
			cr4 <= 0;
			cr5 <= 0;
			cr6 <= 0;
			cr7 <= 0;
			cr8 <= 0;
			cr9 <= 0;
		end
	end
	
	always_ff @ (posedge vs or posedge reset)
	begin
		if(reset)
		begin
			curr_state <= idle;
			counter = 0;
			for(int i = 0; i < 20; i++)
			begin
				board[i] <= 10'b0000000000;
			end
		end
		else
		begin
			if(lock)
			begin
				board[y0][x0] <= 1'b1;
				board[y1][x1] <= 1'b1;
				board[y2][x2] <= 1'b1;
				board[y3][x3] <= 1'b1;
			end
			if(counter == 30)
			begin
				if(cr0) board[0] <= lineFill;
				if(cr1) board[1] <= lineFill;
				if(cr2) board[2] <= lineFill;
				if(cr3) board[3] <= lineFill;
				if(cr4) board[4] <= lineFill;
				if(cr5) board[5] <= lineFill;
				if(cr6) board[6] <= lineFill;
				if(cr7) board[7] <= lineFill;
				if(cr8) board[8] <= lineFill;
				if(cr9) board[9] <= lineFill;
				counter <= 0;
				curr_state <= next_state;
			end
			else counter = counter + 1;
		end
	end
	
	always_comb
	begin
		next_state = curr_state;
		lock = 0;
		c0 = 0;
		c1 = 0;
		c2 = 0;
		c3 = 0;
		c4 = 0;
		c5 = 0;
		c6 = 0;
		c7 = 0;
		c8 = 0;
		c9 = 0;
		lineFill = 10'b0000000000;
		
		if(board[0] == 10'b1111111111) c0 = 1'b1;
		if(board[1] == 10'b1111111111) c1 = 1'b1;
		if(board[2] == 10'b1111111111) c2 = 1'b1;
		if(board[3] == 10'b1111111111) c3 = 1'b1;
		if(board[4] == 10'b1111111111) c4 = 1'b1;
		if(board[5] == 10'b1111111111) c5 = 1'b1;
		if(board[6] == 10'b1111111111) c6 = 1'b1;
		if(board[7] == 10'b1111111111) c7 = 1'b1;
		if(board[8] == 10'b1111111111) c8 = 1'b1;
		if(board[9] == 10'b1111111111) c9 = 1'b1;
	
		
		unique case (curr_state)
			idle:
			begin
				if(board[y0 - 1][x0] || board[y1 - 1][x1] || board[y2 - 1][x2] || board[y3 - 1][x3] || (y0 == 6'b000000 || y1 == 6'b000000 || y2 == 6'b000000 || y3 == 6'b000000))
					next_state = lock1;
				else if(c0 || c1 || c2 || c3 || c4 || c5 || c6 || c7 || c8 || c9) next_state = clear0;
				else next_state = idle;
			end
			lock1: 
			begin
				if(board[y0 - 1][x0] || board[y1 - 1][x1] || board[y2 - 1][x2] || board[y3 - 1][x3] || (y0 == 6'b000000 || y1 == 6'b000000 || y2 == 6'b000000 || y3 == 6'b000000))
					next_state = lock2;
				else next_state = idle;
			end
			lock2: next_state = idle;
			clear0: next_state = clear1;
			clear1: next_state = clear2;
			clear2: next_state = clear3;
			clear3: next_state = clear4;
			clear4: next_state = idle;
		endcase
		
		case (curr_state)
			lock1, lock2, clear0, clear1, clear2, clear3, clear4: stop = 1'b1;
			default: stop = 1'b0;
		endcase
		
		case (curr_state)
			clear0: lineFill = 10'b1111001111;
			clear1: lineFill = 10'b1110000111;
			clear2: lineFill = 10'b1100000011;
			clear3: lineFill = 10'b1000000001;
			clear4: lineFill = 10'b0000000000;
			default: ;
		endcase
		
		if(curr_state == lock2) lock = 1'b1;
		
		
	end
endmodule

module board_memory(input logic clk, reset, vs, isStopped, isLocking, clearing,
						  input logic [4:0] x0, x1, x2, x3,
						  input logic [5:0] y0, y1, y2, y3,
						  input logic [9:0] lineFill,
						  output logic c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, stopFalling
);


	logic cr0, cr1, cr2, cr3, cr4, cr5, cr6, cr7, cr8, cr9;
	logic [9:0] b0, b1, b2, b3, b4, b5, b6, b7, b8, b9;
	logic [9:0] board [20];
	int counter;
	
	always_ff @ (posedge clk or posedge reset)
	begin
		if(reset)
		begin
			board[0] <= 10'b0000000000;
			board[1] <= 10'b0000000000;
			board[2] <= 10'b0000000000;
			board[3] <= 10'b0000000000;
			board[4] <= 10'b0000000000;
			board[5] <= 10'b0000000000;
			board[6] <= 10'b0000000000;
			board[7] <= 10'b0000000000;
			board[8] <= 10'b0000000000;
			board[9] <= 10'b0000000000;
			board[10] <= 10'b0000000000;
			board[11] <= 10'b0000000000;
			board[12] <= 10'b0000000000;
			board[13] <= 10'b0000000000;
			board[14] <= 10'b0000000000;
			board[15] <= 10'b0000000000;
			board[16] <= 10'b0000000000;
			board[17] <= 10'b0000000000;
			board[18] <= 10'b0000000000;
			board[19] <= 10'b0000000000;
		end
		
		else
		begin
			if(isStopped && ~isLocking)
			begin	
				if(clearing)
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
				end
				else
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
				end
			end
			else if(isLocking)
			begin
				board[y0][x0] = 1'b1;
				board[y1][x1] = 1'b1;
				board[y2][x2] = 1'b1;
				board[y3][x3] = 1'b1;
			end
		end
	end
	
	always_comb
	begin
		if(board[0] == 10'b1111111111) c0 = 1'b1;
		else c0 = 1'b0;
		if(board[1] == 10'b1111111111) c1 = 1'b1;
		else c1 = 1'b0;
		if(board[2] == 10'b1111111111) c2 = 1'b1;
		else c2 = 1'b0;
		if(board[3] == 10'b1111111111) c3 = 1'b1;
		else c3 = 1'b0;
		if(board[4] == 10'b1111111111) c4 = 1'b1;
		else c4 = 1'b0;
		if(board[5] == 10'b1111111111) c5 = 1'b1;
		else c5 = 1'b0;
		if(board[6] == 10'b1111111111) c6 = 1'b1;
		else c6 = 1'b0;
		if(board[7] == 10'b1111111111) c7 = 1'b1;
		else c7 = 1'b0;
		if(board[8] == 10'b1111111111) c8 = 1'b1;
		else c8 = 1'b0;
		if(board[9] == 10'b1111111111) c9 = 1'b1;	
		else c9 = 1'b0;	
		
		if(board[y0 - 1][x0] || board[y1 - 1][x1] || board[y2 - 1][x2] || board[y3 - 1][x3] || (y0 == 6'b000000 || y1 == 6'b000000 || y2 == 6'b000000 || y3 == 6'b000000))
			stopFalling = 1'b1;
		else stopFalling = 1'b0;
	end
endmodule

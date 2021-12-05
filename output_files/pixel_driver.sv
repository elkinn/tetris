module pixel_driver(input  logic        pixel_clk, isFalling,
						  input  logic [9:0]  x0, x1, x2, x3,
						  input  logic [9:0]  y0, y1, y2, y3,
						  input  logic [9:0]  DrawX,
													 DrawY,
						  input  logic [3:0]  shape,
						  input  logic [9:0]  board [20],
						  output logic [3:0]  red,
													 green,
													 blue
);
	
	logic [9:0] DrawX0, DrawY0, DrawX1, DrawY1, DrawX2, DrawY2, DrawX3, DrawY3, gameX, gameY;
	logic draw;
	
	assign DrawX0 = (x0 << 4) + 239;
	assign DrawY0 = 379 - (y0 << 4);
	assign DrawX1 = (x1 << 4) + 239;
	assign DrawY1 = 379 - (y1 << 4);	
	assign DrawX2 = (x2 << 4) + 239;
	assign DrawY2 = 379 - (y2 << 4);	
	assign DrawX3 = (x3 << 4) + 239;
	assign DrawY3 = 379 - (y3 << 4);
	
	assign gameX = (DrawX - 239) >> 4;
	assign gameY = (379 - DrawY) >> 4;

	always_ff @ (posedge pixel_clk)
	begin
		if((DrawX >= 237 && DrawX <= 239 && DrawY >= 58 && DrawY <= 381) || (DrawX >= 399 && DrawX <= 401 && DrawY >= 58 && DrawY <= 381)
			 || (DrawY >= 58 && DrawY <= 59 && DrawX >= 237 && DrawX <= 401) || (DrawY >= 380 && DrawY <= 381 && DrawX >= 237 && DrawX <= 401))
		begin
			/* background color */
			red <= 4'b1111;
			green <= 4'b1111;
			blue <= 4'b1111;
		end
		
		else if(DrawX > 239 && DrawX < 400 /*&& DrawY < 380*/) //game field (we can draw above game field but not below)
		begin
			if( (DrawX > DrawX0 && DrawX < (DrawX0 + 16) && DrawY < DrawY0 && DrawY > (DrawY0 - 16)) || (DrawX > DrawX1 && DrawX < (DrawX1 + 16) && DrawY < DrawY1 && DrawY > (DrawY1 - 16))
			 || (DrawX > DrawX2 && DrawX < (DrawX2 + 16) && DrawY < DrawY2 && DrawY > (DrawY2 - 16)) || (DrawX > DrawX3 && DrawX < (DrawX3 + 16) && DrawY < DrawY3 && DrawY > (DrawY3 - 16))) 
			begin
				/* background color */
				red <= 4'b1111;
				green <= 4'b1111;
				blue <= 4'b1111;
			end
			else if(draw)
			begin
				/* background color */
				red <= 4'b1111;
				green <= 4'b1111;
				blue <= 4'b1111;
			end
			else
			begin
				/* shape color */

				/* color table from lab 7
					{"black",          0x0, 0x0, 0x0},
					{"blue",           0x0, 0x0, 0xa},
					{"green",          0x0, 0xa, 0x0},
					{"cyan",           0x0, 0xa, 0xa},
					{"red",            0xa, 0x0, 0x0},
					{"magenta",        0xa, 0x0, 0xa},
					{"brown",          0xa, 0x5, 0x0},
					{"light gray",     0xa, 0xa, 0xa},
					{"dark gray",      0x5, 0x5, 0x5},
					{"light blue",     0x5, 0x5, 0xf},
					{"light green",    0x5, 0xf, 0x5},
					{"light cyan",     0x5, 0xf, 0xf},
					{"light red",      0xf, 0x5, 0x5},
					{"light magenta",  0xf, 0x5, 0xf},
					{"yellow",         0xf, 0xf, 0x5},
					{"white",          0xf, 0xf, 0xf}
				*/

				/* I shape color: cyan */
				if (shape == 3'b000)
				begin
					red <= 4'b0000;
					green <= 4'b1010;
					blue <= 4'b1010;
				end
				/* O shape color: yellow */
				if (shape == 3'b001)
				begin
					red <= 4'b1111;
					green <= 4'b1111;
					blue <= 4'b0101;
				end
				/* T shape color: magenta */
				if (shape == 3'b010)
				begin
					red <= 4'b1010;
					green <= 4'b0000;
					blue <= 4'b1010;
				end
				/* J shape color: blue */
				if (shape == 3'b011)
				begin
					red <= 4'b0000;
					green <= 4'b0000;
					blue <= 4'b1111;
				end
				/* L shape color: brown */
				if (shape == 3'b100)
				begin
					red <= 4'b0101;
					green <= 4'b0101;
					blue <= 4'b0000;
				end
				/* S shape color: light green */
				if (shape == 3'b101)
				begin
					red <= 4'b0101;
					green <= 4'b1111;
					blue <= 4'b0101;
				end
				/* Z shape color: red */
				if (shape == 3'b110)
				begin
					red <= 4'b1010;
					green <= 4'b0000;
					blue <= 4'b0000;
				end
			end
		end
		
		else
		begin
			/* I shape color: cyan */
			if (shape == 3'b000)
			begin
				red <= 4'b0000;
				green <= 4'b1010;
				blue <= 4'b1010;
			end
			/* O shape color: yellow */
			if (shape == 3'b001)
			begin
				red <= 4'b1111;
				green <= 4'b1111;
				blue <= 4'b0101;
			end
			/* T shape color: magenta */
			if (shape == 3'b010)
			begin
				red <= 4'b1010;
				green <= 4'b0000;
				blue <= 4'b1010;
			end
			/* J shape color: blue */
			if (shape == 3'b011)
			begin
				red <= 4'b0000;
				green <= 4'b0000;
				blue <= 4'b1111;
			end
			/* L shape color: brown */
			if (shape == 3'b100)
			begin
				red <= 4'b0101;
				green <= 4'b0101;
				blue <= 4'b0000;
			end
			/* S shape color: light green */
			if (shape == 3'b101)
			begin
				red <= 4'b0101;
				green <= 4'b1111;
				blue <= 4'b0101;
			end
			/* Z shape color: red */
			if (shape == 3'b110)
			begin
				red <= 4'b1010;
				green <= 4'b0000;
				blue <= 4'b0000;
			end
		end
		
	end
	
	always_comb
	begin
		if(board[gameY][gameX] == 1) draw = 1'b1;
		else draw = 1'b0;
	end
	
endmodule

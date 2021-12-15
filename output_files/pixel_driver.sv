module pixel_driver(input  logic        pixel_clk, isFalling,
						  input  logic [9:0]  x0, x1, x2, x3,
						  input  logic [9:0]  y0, y1, y2, y3,
						  input  logic [9:0]  DrawX,
													 DrawY,
						  input  logic [9:0]  board [20],
						  input  logic [3:0]  shape,
						  input  logic        spawnSignal,
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
			red <= 4'b1111;
			green <= 4'b1111;
			blue <= 4'b1111;
		end
		
		else if(DrawX > 239 && DrawX < 400 /*&& DrawY < 380*/) //game field (we can draw above game field but not below)
		begin
			if( (DrawX > DrawX0 && DrawX < (DrawX0 + 16) && DrawY < DrawY0 && DrawY > (DrawY0 - 16)) || (DrawX > DrawX1 && DrawX < (DrawX1 + 16) && DrawY < DrawY1 && DrawY > (DrawY1 - 16))
			 || (DrawX > DrawX2 && DrawX < (DrawX2 + 16) && DrawY < DrawY2 && DrawY > (DrawY2 - 16)) || (DrawX > DrawX3 && DrawX < (DrawX3 + 16) && DrawY < DrawY3 && DrawY > (DrawY3 - 16))) 
			begin
				red <= 4'b1111;
				green <= 4'b1111;
				blue <= 4'b1111;
			end
			else if(draw)
			begin
				red <= 4'b1111;
				green <= 4'b1111;
				blue <= 4'b1111;
			end
			else
			begin
				red <= 4'b0000;
				green <= 4'b0000;
				blue <= 4'b0000;
			end
		end
		
		else
		begin
			if (spawnSignal)
	//				red <= 4'b0000;
	//				green <= 4'b0000;
	//				blue <= 4'b0000;
					if (shape==4'b0000) //I
					begin
						red <= 4'b0000;
						green <= 4'b1010;
						blue <= 4'b1010;
					end
					else if (shape==4'b0001) //O
					begin
						red <= 4'b1111;
						green <= 4'b1111;
						blue <= 4'b0101;
					end
					else if (shape==4'b0010)//T
					begin
						red <= 4'b1010;
						green <= 4'b0000;
						blue <= 4'b1010;
					end
					else if (shape==4'b0011)//J
					begin
						red <= 4'b0000;
						green <= 4'b0000;
						blue <= 4'b1111;
					end
					else if (shape==4'b0100)//L
					begin
						red <= 4'b0101;
						green <= 4'b0101;
						blue <= 4'b0000;
					end
					else if (shape==4'b0101)//S
					begin
						red <= 4'b0101;
						green <= 4'b1111;
						blue <= 4'b0101;
					end
					else if (shape==4'b0110)//Z
					begin
						red <= 4'b1010;
						green <= 4'b0000;
						blue <= 4'b0000;
					end
					else
					begin
						red <= 4'b0000;
						green <= 4'b0000;
						blue <= 4'b0000;
					end//we never do this
			else			
				begin
					red <= 4'b0000;
					green <= 4'b0000;
					blue <= 4'b0000;
				end//we never do this
				
		end
		
	end
	
	always_comb
	begin
		if(board[gameY][gameX] == 1) draw = 1'b1;
		else draw = 1'b0;
	end
	
endmodule

module falling_piece(input  logic clk, vs, reset, isFalling, isStopped, spawnSignal, clearing,
							input  logic [7:0] keycode_i,
							input  logic [9:0] board [20],
						    output logic [4:0] x0, x1, x2, x3,
							output logic [5:0] y0, y1, y2, y3,
							output logic [3:0] shape
);
	int counter, x0shift, y0shift, x1shift, y1shift, x2shift, y2shift, x3shift, y3shift, orientation, rotate;
	logic [2:0] lsfr0, lsfr1, lsfr2;
	logic [3:0] shapeReg;
	logic [7:0] keycode;
	
	input_delay i0 (.clk(vs), .reset(reset), .in(keycode_i), .out(keycode));
	LSFR l0 (.clk(clk), .rst(reset), .d(lsfr0));
	LSFR l1 (.clk(clk), .rst(reset), .d(lsfr1));
	LSFR l2 (.clk(clk), .rst(reset), .d(lsfr2));
	
	always_ff @(posedge vs)
	begin
		if(isFalling)
		begin
			if(counter == 30) counter <= 0;
			else counter <= counter + 1;
		end
	end
	
	always_ff @ (posedge clk or posedge reset)
	begin
		if(reset)
		begin
			shapeReg <= shape;
			orientation <= 2'b00;
			unique case (shape)
				3'b000: //I
				begin
					x0 <= 5'b00011;
					x1 <= 5'b00100;
					x2 <= 5'b00101;
					x3 <= 5'b00110;
					y0 <= 6'b010100;
					y1 <= 6'b010100;
					y2 <= 6'b010100;
					y3 <= 6'b010100;
				end
				3'b001: //O
				begin
					x0 <= 5'b00100;
					x1 <= 5'b00100;
					x2 <= 5'b00101;
					x3 <= 5'b00101;
					y0 <= 6'b010100;
					y1 <= 6'b010101;
					y2 <= 6'b010100;
					y3 <= 6'b010101;
				end
				3'b010://T
				begin
					x0 <= 5'b00011;
					x1 <= 5'b00100;
					x2 <= 5'b00100;
					x3 <= 5'b00101;
					y0 <= 6'b010100;
					y1 <= 6'b010100;
					y2 <= 6'b010101;
					y3 <= 6'b010100;
				end
				3'b011://J
				begin
					x0 <= 5'b00011;
					x1 <= 5'b00011;
					x2 <= 5'b00100;
					x3 <= 5'b00101;
					y0 <= 6'b010101;
					y1 <= 6'b010100;
					y2 <= 6'b010100;
					y3 <= 6'b010100;
				end
				3'b100://L
				begin
					x0 <= 5'b00011;
					x1 <= 5'b00100;
					x2 <= 5'b00101;
					x3 <= 5'b00101;
					y0 <= 6'b010100;
					y1 <= 6'b010100;
					y2 <= 6'b010100;
					y3 <= 6'b010101;
				end
				3'b101://S
				begin	
					x0 <= 5'b00011;
					x1 <= 5'b00100;
					x2 <= 5'b00100;
					x3 <= 5'b00101;
					y0 <= 6'b010100;
					y1 <= 6'b010100;
					y2 <= 6'b010101;
					y3 <= 6'b010101;
				end
				3'b110://Z
				begin
					x0 <= 5'b00011;
					x1 <= 5'b00100;
					x2 <= 5'b00100;
					x3 <= 5'b00101;
					y0 <= 6'b010101;
					y1 <= 6'b010101;
					y2 <= 6'b010100;
					y3 <= 6'b010100;
				end
				3'b111:;//we never do this
			endcase
		end
		else if(isFalling == 1'b1)
		begin
			if(counter == 30)
			begin
				x0 <= x0;
				x1 <= x1;
				x2 <= x2;
				x3 <= x3;
				y0 <= y0 - 1;
				y1 <= y1 - 1;
				y2 <= y2 - 1;
				y3 <= y3 - 1;
			end
			else
			begin
				if(board[y0+y0shift][x0+x0shift] == 0 && board[y1+y1shift][x1+x1shift] == 0 && board[y2+y2shift][x2+x2shift] == 0 && board[y3+y3shift][x3+x3shift] == 0)
				begin
					x0 <= x0 + x0shift;
					x1 <= x1 + x1shift;
					x2 <= x2 + x2shift;
					x3 <= x3 + x3shift;
					y0 <= y0 + y0shift;
					y1 <= y1 + y1shift;
					y2 <= y2 + y2shift;
					y3 <= y3 + y3shift;
					if(rotate)
					begin
						if(orientation == 3) orientation <= 0;
						else orientation <= orientation + 1;
					end
				end	
			end	
		end
		
		else if(isStopped == 1'b1)
		begin
			if(board[y0+y0shift][x0+x0shift] == 0 && board[y1+y1shift][x1+x1shift] == 0 && board[y2+y2shift][x2+x2shift] == 0 && board[y3+y3shift][x3+x3shift] == 0)
			begin
				x0 <= x0 + x0shift;
				x1 <= x1 + x1shift;
				x2 <= x2 + x2shift;
				x3 <= x3 + x3shift;
				y0 <= y0 + y0shift;
				y1 <= y1 + y1shift;
				y2 <= y2 + y2shift;
				y3 <= y3 + y3shift;
				if(rotate)
				begin
					if(orientation == 3) orientation <= 0;
					else orientation <= orientation + 1;
				end
			end
		end
		else if(clearing)
		begin
			x0 <= -1;
			x1 <= -1;
			x2 <= -1;
			x3 <= -1;
			y0 <= -1;
			y1 <= -1;
			y2 <= -1;
			y3 <= -1;
		end
		else
		begin
			x0 <= x0;
			x1 <= x1;
			x2 <= x2;
			x3 <= x3;
			y0 <= y0;
			y1 <= y1;
			y2 <= y2;
			y3 <= y3;
		end
	end
	
	always_comb
	begin
		shape = {lsfr2[0],lsfr1[0],lsfr0[0]};
		x0shift = 0;
		x1shift = 0;
		x2shift = 0;
		x3shift = 0;
		y0shift = 0;
		y1shift = 0;
		y2shift = 0;
		y3shift = 0;
		rotate = 1'b0;
	
		if(isFalling)
		begin
			unique case(keycode) //apply shifts based on keyboard input (left/right or rotate)
				8'b01001111:
				begin
					if(x0 < 9 && x1 < 9 && x2 < 9 && x3 < 9)
					begin
						x0shift = 1;
						x1shift = 1;
						x2shift = 1;
						x3shift = 1;
					end
				end
				8'b01010000:
				begin
					if(x0 > 0 && x1 > 0 && x2 > 0 && x3 > 0)
					begin
						x0shift = -1;
						x1shift = -1;
						x2shift = -1;
						x3shift = -1;
					end
				end
				8'b01010010://rotate clockwise
				begin
					rotate = 1'b1;
					unique case (shapeReg)
						3'b000://I
						begin
							unique case (orientation)
								0:
								begin
									x0shift = 1;
									x2shift = -1;
									x3shift = -2;
									y0shift = 1;
									y2shift = -1;
									y3shift = -2;
								end
								1:
								begin
									x0shift = 1;
									x2shift = -1;
									x3shift = -2;
									y0shift = -1;
									y2shift = 1;
									y3shift = 2;
								end
								2:
								begin
									x0shift = -1;
									x2shift = 1;
									x3shift = 2;
									y0shift = -1;
									y2shift = 1;
									y3shift = 2;
								end
								3:
								begin
									x0shift = -1;
									x2shift = 1;
									x3shift = 2;
									y0shift = 1;
									y2shift = -1;
									y3shift = -2;
								end
							endcase
						end
						3'b001:;//O has no rotations
						3'b010://T
						begin
							unique case (orientation)
								0:
								begin
									x0shift = 1;
									x2shift = 1;
									x3shift = -1;
									y0shift = 1;
									y2shift = -1;
									y3shift = -1;
								end
								1:
								begin
									x0shift = 1;
									x2shift = -1;
									x3shift = -1;
									y0shift = -1;
									y2shift = -1;
									y3shift = 1;
								end
								2:
								begin
									x0shift = -1;
									x2shift = -1;
									x3shift = 1;
									y0shift = -1;
									y2shift = 1;
									y3shift = 1;
								end
								3:
								begin
									x0shift = -1;
									x2shift = 1;
									x3shift = 1;
									y0shift = 1;
									y2shift = 1;
									y3shift = -1;
								end
							endcase
						end
						3'b011://J
						begin
							unique case (orientation)
								0:
								begin
									x0shift = 2;
									x1shift = 1;
									x3shift = -1;
									y1shift = 1;
									y3shift = -1;
								end
								1:
								begin
									y0shift = -2;
									x1shift = 1;
									y1shift = -1;
									x3shift = -1;
									y3shift = 1;
								end
								2:
								begin
									x0shift = -2;
									x1shift = -1;
									y1shift = -1;
									x3shift = 1;
									y3shift = 1;
								end
								3:
								begin
									y0shift = 2;
									x1shift = -1;
									y1shift = 1;
									x3shift = 1;
									y3shift = -1;
								end
							endcase
						end
						3'b100://L
						begin
							unique case (orientation)
								0:
								begin
									x0shift = 1;
									x2shift = -1;
									y0shift = 1;
									y2shift = -1;
									y3shift = -2;
								end
								1:
								begin
									x0shift = 1;
									x2shift = -1;
									x3shift = -2;
									y0shift = -1;
									y2shift = 1;
								end
								2:
								begin
									x0shift = -1;
									x2shift = 1;
									y0shift = -1;
									y2shift = 1;
									y3shift = 2;
								end
								3:
								begin
									x0shift = -1;
									x2shift = 1;
									x3shift = 2;
									y0shift = 1;
									y2shift = -1;
								end
							endcase
						end
						3'b101://S
						begin
							unique case (orientation)
								0:
								begin
									x0shift = 1;
									x2shift = 1;
									y0shift = 1;
									y2shift = -1;
									y3shift = -2;
								end
								1:
								begin
									x0shift = 1;
									x2shift = -1;
									x3shift = -2;
									y0shift = -1;
									y2shift = -1;
								end
								2:
								begin
									x0shift = -1;
									x2shift = -1;
									y0shift = -1;
									y2shift = 1;
									y3shift = 2;
								end
								3:
								begin
									x0shift = -1;
									x2shift = 1;
									x3shift = 2;
									y0shift = 1;
									y2shift = 1;
								end
							endcase
						end
						3'b110://Z
						begin
							unique case (orientation)
								0:
								begin
									x0shift = 2;
									x1shift = 1;
									x3shift = -1;
									y1shift = -1;
									y3shift = -1;
								end
								1:
								begin
									x1shift = -1;
									x3shift = -1;
									y0shift = -2;
									y1shift = -1;
									y3shift = 1;
								end
								2:
								begin
									x0shift = -2;
									x1shift = -1;
									x3shift = 1;
									y1shift = 1;
									y3shift = 1;
								end
								3:
								begin
									x1shift = 1;
									x3shift = 1;
									y0shift = 2;
									y1shift = 1;
									y3shift = -1;
								end
							endcase
						end
						3'b111:;
					endcase
				end
				default:;	
			endcase
		end
	end
endmodule

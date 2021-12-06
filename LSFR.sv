module LSFR (input clk, rst, output[3:0] d);

	logic feedback;
	logic [3:0] d_next;
	
	assign fedback = d[3] ^ d[2] ^ d[0];
	assign d_next = {feedback, d[3:1]};
	
	always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			d <= 1;
		end
		else
		begin
			d <= d_next;
		end
	end
endmodule

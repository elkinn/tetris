module LSFR (input clk, rst, output[3:0] d);

	logic feedback;
	assign fedback = d[0] ^ d[3];
	
	always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			d <= 4'hF;
		end
		else
		begin
			d <= {d[2:0], feedback};
		end
	end
endmodule

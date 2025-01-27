
module nios_system (
	clk_clk,
	reset_reset_n,
	switches_export,
	buttons_export,
	hex0_export);	

	input		clk_clk;
	input		reset_reset_n;
	input	[7:0]	switches_export;
	input	[3:0]	buttons_export;
	output	[6:0]	hex0_export;
endmodule

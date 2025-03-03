
module nios_system (
	clk_clk,
	hex4_export,
	hex3_export,
	hex2_export,
	hex1_export,
	hex0_export,
	pushbutton_export,
	switches_export,
	pwm_o_writeresponsevalid_n);	

	input		clk_clk;
	output	[6:0]	hex4_export;
	output	[6:0]	hex3_export;
	output	[6:0]	hex2_export;
	output	[6:0]	hex1_export;
	output	[6:0]	hex0_export;
	input	[3:0]	pushbutton_export;
	input	[7:0]	switches_export;
	output		pwm_o_writeresponsevalid_n;
endmodule

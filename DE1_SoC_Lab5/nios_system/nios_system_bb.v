
module nios_system (
	clk_clk,
	hex0_export,
	hex1_export,
	hex2_export,
	hex3_export,
	hex4_export,
	pushbutton_export,
	pwm_o_ext_data_ext_data,
	switches_export);	

	input		clk_clk;
	output	[6:0]	hex0_export;
	output	[6:0]	hex1_export;
	output	[6:0]	hex2_export;
	output	[6:0]	hex3_export;
	output	[6:0]	hex4_export;
	input	[3:0]	pushbutton_export;
	output		pwm_o_ext_data_ext_data;
	input	[7:0]	switches_export;
endmodule

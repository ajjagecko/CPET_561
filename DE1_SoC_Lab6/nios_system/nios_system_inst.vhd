	component nios_system is
		port (
			clk_clk            : in  std_logic                    := 'X'; -- clk
			leds_export        : out std_logic_vector(7 downto 0);        -- export
			pushbutton1_export : in  std_logic                    := 'X'  -- export
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk            => CONNECTED_TO_clk_clk,            --         clk.clk
			leds_export        => CONNECTED_TO_leds_export,        --        leds.export
			pushbutton1_export => CONNECTED_TO_pushbutton1_export  -- pushbutton1.export
		);


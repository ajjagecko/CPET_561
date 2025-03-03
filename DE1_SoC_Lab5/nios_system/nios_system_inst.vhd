	component nios_system is
		port (
			clk_clk                    : in  std_logic                    := 'X';             -- clk
			hex4_export                : out std_logic_vector(6 downto 0);                    -- export
			hex3_export                : out std_logic_vector(6 downto 0);                    -- export
			hex2_export                : out std_logic_vector(6 downto 0);                    -- export
			hex1_export                : out std_logic_vector(6 downto 0);                    -- export
			hex0_export                : out std_logic_vector(6 downto 0);                    -- export
			pushbutton_export          : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			switches_export            : in  std_logic_vector(7 downto 0) := (others => 'X'); -- export
			pwm_o_writeresponsevalid_n : out std_logic                                        -- writeresponsevalid_n
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk                    => CONNECTED_TO_clk_clk,                    --        clk.clk
			hex4_export                => CONNECTED_TO_hex4_export,                --       hex4.export
			hex3_export                => CONNECTED_TO_hex3_export,                --       hex3.export
			hex2_export                => CONNECTED_TO_hex2_export,                --       hex2.export
			hex1_export                => CONNECTED_TO_hex1_export,                --       hex1.export
			hex0_export                => CONNECTED_TO_hex0_export,                --       hex0.export
			pushbutton_export          => CONNECTED_TO_pushbutton_export,          -- pushbutton.export
			switches_export            => CONNECTED_TO_switches_export,            --   switches.export
			pwm_o_writeresponsevalid_n => CONNECTED_TO_pwm_o_writeresponsevalid_n  --      pwm_o.writeresponsevalid_n
		);


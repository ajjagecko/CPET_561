--DE1_SoC_Lab6


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity DE1_SoC_Lab6 is
	port (
		CLOCK_50        :in std_logic;
		KEY             :in  std_logic_vector(3 downto 0);
		SW              :in  std_logic_vector(9 downto 0);
		pwm_o          :out  std_logic;
		HEX0           :out  std_logic_vector(6 downto 0);
		HEX1           :out  std_logic_vector(6 downto 0);
		HEX2           :out  std_logic_vector(6 downto 0);
		HEX4           :out  std_logic_vector(6 downto 0);
		HEX5           :out  std_logic_vector(6 downto 0);
      LEDR            :out std_logic_vector(9 downto 0)
	);
end DE1_SoC_Lab6;

architecture beh of DE1_SoC_Lab6 is

	signal reset_n : std_logic;
	signal key0_d1 : std_logic_vector(3 downto 0);
	signal key0_d2 : std_logic_vector(3 downto 0);
	signal key0_d3 : std_logic_vector(3 downto 0);
	signal sw_d1 : std_logic_vector(9 downto 0);
	signal sw_d2 : std_logic_vector(9 downto 0);

	component nios_system is
		port (
			clk_clk            : in  std_logic                    := 'X'; -- clk
			leds_export        : out std_logic_vector(7 downto 0);        -- export
			pushbutton1_export : in  std_logic                    := 'X'  -- export
		);
	end component nios_system;

begin

	synchReset_proc : process (CLOCK_50) begin
		if (rising_edge(CLOCK_50)) then
		key0_d1 <= KEY;
		key0_d2 <= key0_d1;
		key0_d3 <= key0_d2;
		end if;
	end process synchReset_proc;
	reset_n <= key0_d3(0);
	
	synchUserIn_proc : process (CLOCK_50) begin
		if (rising_edge(CLOCK_50)) then
		if (reset_n = '0') then
			sw_d1 <= "00" & x"00";
			sw_d2 <= "00" & x"00";
		else
			sw_d1 <= SW;
			sw_d2 <= sw_d1;
		end if;
		end if;
	end process synchUserIn_proc;	
	


	u0 : component nios_system
		port map (
			clk_clk            => CLOCK_50,          --         clk.clk
			leds_export        => LEDR(7 DOWNTO 0),  --        leds.export
			pushbutton1_export => key0_d3(1)         -- pushbutton1.export
		);
end;
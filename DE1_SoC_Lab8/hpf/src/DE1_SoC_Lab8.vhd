LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_signed.all;


entity DE1_SoC_Lab8 is
   port(
      clk       :in std_logic;
      reset_n   :in std_logic;
      data_i    :in std_logic_vector(15 downto 0);
      filter_en :in std_logic;
      data_o    :out std_logic_vector(15 downto 0)
   );
end DE1_SoC_Lab8;

architecture beh of DE1_SoC_Lab8 is

component low_pass_filter is
   port(
      clk       :in std_logic;
      reset_n   :in std_logic;
      data_i    :in std_logic_vector(15 downto 0);
      filter_en :in std_logic;
      data_o    :out std_logic_vector(15 downto 0)
   );
end component;

begin
   lpf:low_pass_filter
	   port map (
		   clk       => clk,      
         reset_n   => reset_n, 
         data_i    => data_i,   
         filter_en => filter_en,
         data_o    => data_o   
		);
end beh;

  
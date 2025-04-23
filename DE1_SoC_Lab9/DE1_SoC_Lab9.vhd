LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_signed.all;


entity DE1_SoC_Lab9 is
   port(
      clk       :in std_logic;
      reset_n   :in std_logic;
      write     :in std_logic;
		address   :in std_logic;
		writedata    :in std_logic_vector(15 downto 0);
      readata      :out std_logic_vector(15 downto 0)
   );
end DE1_SoC_Lab9;

architecture beh of DE1_SoC_Lab9 is

component fir_filter is
   port(
      clk        :in std_logic;
      reset_n    :in std_logic;
      addr_i     :in std_logic;
      data_i     :in std_logic_vector(15 downto 0);
      write_en_i :in std_logic;
      data_o     :out std_logic_vector(15 downto 0)
   );
end component;

begin
   fir:fir_filter
	   port map (
		   clk         => clk,       
         reset_n     => reset_n,
         addr_i      => address,
         data_i      => writedata,
         write_en_i  => write,
         data_o      => readata
		);
end beh;

  
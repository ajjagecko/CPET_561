library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity generic_counter is
   generic (
      max_count    :std_logic_vector(31 downto 0)  := x"00000003"
   );
   port (
     clk        :in std_logic;
	  reset_i    :in std_logic;
	  count    :out std_logic_vector(31 downto 0);
	  output   :out std_logic
   );
end generic_counter;

architecture beh of generic_counter is

signal cntr   :std_logic_vector(31 downto 0) := x"00000000";

begin
    gen_counter:process (clk, reset_i) begin
	   if (clk'event and clk = '1') then
         if (reset_i = '0') then
            cntr <= x"00000000";
            output <= '0';
         elsif (max_count = cntr) then
            cntr <= x"00000000";
            output <= '1';
         else
            cntr <= cntr + x"00000001";
            output <= '0';
         end if;
      end if;
   end process;
   count <= cntr;
end beh;
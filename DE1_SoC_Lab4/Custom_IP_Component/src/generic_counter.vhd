library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity generic_counter is
   generic (
      max_count    :std_logic_vector(31 downto 0)  := 3
   );
   port (
     clk        :in std_logic;
	  reset_i    :in std_logic;
	  count    :out std_logic_vector(31 downto 0);
	  output   :out std_logic_vector
   );
end generic_counter;

architecture beh of generic_counter is

signal cntr   :std_logic_vector(31 downto 0);

begin
   process (CLOCK_50) begin
      if (rising_edge(CLOCK_50)) then
         if (reset_i = '0') then
            cntr <= "00" & x"000000";
            output <= '0';
         elsif (max_count == cntr) then
            cntr <= "00" & x"000000";
            output <= '1';
         else
            cntr <= cntr + ("00" & x"000001");
            output <= '0';
         end if;
      end if;
   end process syncCntr_proc;
end beh;
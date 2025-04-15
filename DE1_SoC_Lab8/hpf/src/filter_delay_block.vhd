-- Lab 8 delay_block
-- Andrew Akre

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_signed.all;

entity filter_delay_block is
   port(
      clk           :in std_logic;
      reset_n       :in std_logic;
      filter_en     :in std_logic;
      data_i        :in std_logic_vector(15 downto 0);
      data_o        :out std_logic_vector(15 downto 0)
   );
end filter_delay_block;

architecture beh of filter_delay_block is

signal reg_delay :std_logic_vector(15 downto 0) := x"0000";

begin
   reg:process(clk, reset_n, filter_en, data_i)
      begin
         reg_delay <= reg_delay;
         if(clk'event and clk = '1') then
            if (reset_n = '0') then
               reg_delay <= x"0000";
            elsif (filter_en = '1') then
               reg_delay <= data_i;
            end if;
         end if;
      end process;
      
   data_o <= reg_delay;

end beh;
               
            
      
      
      
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity angle_counter is
   port (
	  clk                :in std_logic;
	  reset_i            :in std_logic;
     period_flag_i      :in std_logic;
	  angle_max_i        :in  std_logic_vector(31 downto 0);
	  angle_min_i        :in  std_logic_vector(31 downto 0);
	  state_pres_i       :in  std_logic_vector(3 downto 0);
	  angle_o            :out std_logic_vector(31 downto 0);
     angle_matched_flag :out std_logic;
   );
end angle_counter;

architecture beh of angle_counter is

constant SWEEP_RIGHT_STATE :std_logic_vector(3 downto 0) := "1000";
constant INT_RIGHT_STATE   :std_logic_vector(3 downto 0) := "0100";
constant SWEEP_LEFT_STATE  :std_logic_vector(3 downto 0) := "0010";
constant INT_LEFT_STATE    :std_logic_vector(3 downto 0) := "0001";

signal angle_s : std_logic_vector(31 downto 0);

begin
   angle_reset: process(clk, angle_s)
      begin
         if (reset_i = '1') then
               angle_s <= angle_min_i;
         else
            angle_s <= angle_s;
         end if;
	   end process;
      
   angle_check: process(clk, state_pres_i, period_flag_i, angle_s, angle_min_i, angle_max_i)
      begin
         case state_pres_i is 
            when SWEEP_RIGHT_STATE =>
               if (angle_max_i == angle_s) then
                  angle_matched_flag = '1';
                  angle_s <= angle_max_i;
               elsif period_flag_i = '1' then
                  angle_s <= angle_s + x"00000001";
               else
                  angle_s <= angle_s;
               end if;
            when SWEEP_LEFT_STATE => 
               if (angle_min_i == angle_s) then
                  angle_matched_flag = '1';
                  angle_s <= angle_min_i;
               elsif period_flag_i = '1' then
                  angle_s <= angle_s - x"00000001";
               else
                  angle_s <= angle_s;
               end if;
            when INT_RIGHT_STATE => 
               angle_matched_flag = '0';
               angle_s <= angle_max_i;
            when INT_LEFT_STATE => 
               angle_matched_flag = '0';
               angle_s <= angle_min_i;
            when others =>
               angle_s <= angle_s;
         end case;
   
      angle_o <= angle_s;
end beh;
   
-------------------------------------------------------------------------------
-- Name: Andrew Akre
-- Course: CPET 343
-- Task:
--    Generic State Machine cor
--    Last Updated: 21/10//2024
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity state_machine_core is
   port (
      clk       :in std_logic;
      reset     :in std_logic;
      write_en_i    :in std_logic;
      angle_flag_i  :in std_logic;
      state_pres_o  :out std_logic_vector(3 downto 0);
      state_next_o  :out std_logic_vector(3 downto 0)
   );
end entity state_machine_core;

architecture beh of state_machine_core is

constant SWEEP_RIGHT_STATE :std_logic_vector(3 downto 0) := "1000";
constant INT_RIGHT_STATE   :std_logic_vector(3 downto 0) := "0100";
constant SWEEP_LEFT_STATE  :std_logic_vector(3 downto 0) := "0010";
constant INT_LEFT_STATE    :std_logic_vector(3 downto 0) := "0001";

signal state_next_s, state_pres_s :std_logic_vector(3 downto 0);

begin
  
   state_reset:process(clk,reset) is
      begin
         state_pres_s <= state_pres_s;            --Avoiding latch
         if(reset = '1') then
            state_pres_s <= SWEEP_RIGHT_STATE;        
         elsif(clk'event and clk = '1') then
            state_pres_s <= state_next_s;
         end if;
      end process;
   
   ut03: process(state_pres_s, write_en_i, angle_flag_i)
      begin
         case state_pres_s is
         
            when SWEEP_RIGHT_STATE =>
               --led_o <= "1000";
               if ('1' = angle_flag_i) then
                  state_next_s <= INT_RIGHT_STATE;
               else
                  state_next_s <= state_pres_s;
               end if;
            when INT_RIGHT_STATE =>
               --led_o <= "0100";
               if ('1' = write_en_i) then
                  state_next_s <= SWEEP_LEFT_STATE;
               else
                  state_next_s <= state_pres_s;
               end if;
            when SWEEP_LEFT_STATE =>
               --led_o <= "0010";
               if ('1' = angle_flag_i) then
                  state_next_s <= INT_LEFT_STATE;
               else
                  state_next_s <= state_pres_s;
               end if;
            when INT_LEFT_STATE =>
               --led_o <= "0001";
               if ('1' = write_en_i) then
                  state_next_s <= SWEEP_RIGHT_STATE;
               else
                  state_next_s <= state_pres_s;
               end if;
            when others =>
               state_next_s <= state_pres_s; --NEXT TIME: MOVE THIS OUT OF when others AND ADD IT ABOVE CASE STATEMENT TO AVOID LATCHES!!!!!
               
         end case;
      end process;
      
      state_pres_o <= state_pres_s;
      state_next_o <= state_next_s;
      
end architecture;
      
      
   


   
   
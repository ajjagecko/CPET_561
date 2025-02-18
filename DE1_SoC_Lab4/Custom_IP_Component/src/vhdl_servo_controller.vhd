-------------------------------------------------------------------------------------
-- Name:   Andrew  Akre
-- Course: CPET 561
-- Task:
--       Custom I/O Component that sweeps a servo motor left and right Top Level
-- Last Update: 17/02/2025
-- Servo Specs: https://www.servocity.com/hs-311-servo/
-------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity vhdl_servo_controller is
   port (
     clk           :in  std_logic;
	  reset_i       :in  std_logic;
	  addr_i        :in  std_logic;
	  write_data_i  :in  std_logic_vector(31 downto 0);
	  write_en_i    :in  std_logic;
	  pwm_o         :out std_logic;
	  irq_o         :out std_logic
	);
end entity vhdl_servo_controller;

architecture beh of vhdl_servo_controller is

constant ANGLE_MAX_RESET :std_logic_vector(31 downto 0) := x"00000064";--"000186A0";
constant ANGLE_MIN_RESET :std_logic_vector(31 downto 0) := x"00000032";--"0000C350";

signal state_next_s, state_pres_s :std_logic_vector(3 downto 0);

signal write_en_max_s    :std_logic := '0';
signal write_en_min_s    :std_logic := '0';
signal write_data_max_s  :std_logic_vector(31 downto 0);
signal write_data_min_s  :std_logic_vector(31 downto 0);

signal angle_max_reg_s  :std_logic_vector(31 downto 0);
signal angle_min_reg_s  :std_logic_vector(31 downto 0);

signal angle_max_in_s  :std_logic_vector(31 downto 0);
signal angle_min_in_s  :std_logic_vector(31 downto 0);

signal period_count_s  :std_logic_vector(31 downto 0) := x"00000000";
signal angle_s  :std_logic_vector(31 downto 0) := x"00000000";
signal period_flag_s   :std_logic := '0';
signal angle_flag_s    :std_logic := '0';
signal pwm_s           :std_logic;

component angle_counter is
   port (
	  clk                :in std_logic;
	  reset_i            :in std_logic;
     period_flag_i      :in std_logic;
	  angle_max_i        :in  std_logic_vector(31 downto 0);
	  angle_min_i        :in  std_logic_vector(31 downto 0);
	  state_pres_i       :in  std_logic_vector(3 downto 0);
	  angle_o            :out std_logic_vector(31 downto 0);
     angle_matched_flag :out std_logic
   );
end component;

component generic_counter is
   generic (
      max_count    :std_logic_vector(31 downto 0)  := x"00000003"
   );
   port (
     clk      :in std_logic;
	  reset_i  :in std_logic;
	  count    :out std_logic_vector(31 downto 0);
	  output   :out std_logic
   );
end component;

component state_machine_core is
   port (
      clk            :in std_logic;
      reset          :in std_logic;
      write_en_i    :in std_logic;
      angle_flag_i  :in std_logic;
      state_pres_o  :out std_logic_vector(3 downto 0);
      state_next_o  :out std_logic_vector(3 downto 0);
      irq_o         :out std_logic
   );
end component;

begin

   addr_mux: process(addr_i, write_data_i, write_en_i)
      begin
	     case addr_i is
		   when '0' =>
            write_data_min_s <= write_data_i;
            write_en_min_s   <= write_en_i;
            write_data_max_s <= write_data_max_s;
            write_en_max_s   <= write_en_max_s;
		   when '1' =>
            write_data_max_s <= write_data_i;
            write_en_max_s   <= write_en_i;
            write_data_min_s <= write_data_min_s;
            write_en_min_s   <= write_en_min_s;  
		   when others =>
		      write_data_max_s <= write_data_max_s;
            write_en_max_s   <= write_en_max_s;
		      write_data_min_s <= write_data_min_s;
            write_en_min_s   <= write_en_min_s;
         end case;
      end process;

   min_reg: process(clk, write_en_min_s, write_data_min_s, angle_min_reg_s)
      begin
         if (reset_i = '1') then
            angle_min_reg_s <= ANGLE_MIN_RESET;
         elsif (clk'event and clk = '1') then
            if write_en_min_s = '1' then
               angle_min_reg_s <= write_data_min_s;
               write_en_min_s <= '0';
			else
			   angle_min_reg_s <= angle_min_reg_s;
			end if;
		 end if;
	  end process;
	  
   max_reg: process(clk, write_en_max_s, write_data_max_s, angle_max_reg_s)
      begin
         if (reset_i = '1') then
		    angle_max_reg_s <= ANGLE_MAX_RESET;
		 elsif (clk'event and clk = '1') then
		    if write_en_max_s = '1' then
			   angle_max_reg_s <= write_data_max_s;
			   write_en_max_s <= '0';
			else
			   angle_max_reg_s <= angle_max_reg_s;
			end if;
		 end if;
	  end process;
	  

   angle_proc: angle_counter
      port map (
         clk                => clk,
         reset_i            => reset_i,
         period_flag_i      => period_flag_s,
         angle_max_i        => angle_max_reg_s,
         angle_min_i        => angle_min_reg_s,
         state_pres_i       => state_pres_s,
         angle_o            => angle_s,
         angle_matched_flag => angle_flag_s 
	  );
	  
   counter: generic_counter
      generic map (
	     max_count => x"000003E8"--"000F4240";
	  )
	  port map (
         clk      => clk,
         reset_i  => reset_i,
         count  => period_count_s,
         output   => period_flag_s
	  );
     
     
   state_machine: state_machine_core
      port map (
         clk          => clk,
         reset        => reset_i,
         write_en_i   => write_en_i,
         angle_flag_i => angle_flag_s,
         state_pres_o => state_pres_s,
         state_next_o => state_next_s,
         irq_o        => irq_o
      );
	  
   compare_process: process(clk, angle_s, period_count_s)
      begin
         if(clk'event and clk = '1') then 
            if (period_count_s > angle_s) then
               pwm_s <= '0';
            else
               pwm_s <= '1';
            end if;
         else
            pwm_s <= pwm_s;
         end if;
      end process;
  
   pwm_o <= pwm_s;
   
end beh;
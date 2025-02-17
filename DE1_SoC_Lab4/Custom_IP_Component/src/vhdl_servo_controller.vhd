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

constant ANGLE_MAX_RESET :std_logic_vector(31 downto 0) := "";
constant ANGLE_MIN_RESET :std_logic_vector(31 downto 0) := "";

constant SWEEP_RIGHT_STATE :std_logic_vector(3 downto 0) := "1000";
constant INT_RIGHT_STATE   :std_logic_vector(3 downto 0) := "0100";
constant SWEEP_LEFT_STATE  :std_logic_vector(3 downto 0) := "0010";
constant INT_LEFT_STATE    :std_logic_vector(3 downto 0) := "0001";

signal state_next_s, state_pres_s :std_logic_vector(3 downto 0);

signal write_en_max_s    :std_logic := '0';
signal write_en_min_s    :std_logic := '0';
signal write_data_max_s  :std_logic_vector(31 downto 0);
signal write_data_min_s  :std_logic_vector(31 downto 0);

signal angle_max_reg_s  :std_logic_vector(31 downto 0);
signal angle_min_reg_s  :std_logic_vector(31 downto 0);

signal angle_max_in_s  :std_logic_vector(31 downto 0);
signal angle_min_in_s  :std_logic_vector(31 downto 0);

component angle_counter is
   port (
	  clk            :in std_logic;
	  reset_i        :in std_logic;
      last_angle_i   :in  std_logic_vector(31 downto 0);
	  angle_max_i    :in  std_logic_vector(31 downto 0);
	  angle_min_i    :in  std_logic_vector(31 downto 0);
	  state_pres_i   :in  std_logic_vector(3 downto 0);
	  angle_next_o   :out std_logic_vector(31 downto 0)
   );
end component;

component generic_counter is
   generic (
      max_count   :integer := 3
   );
   port (
      clk       :in  std_logic;
      reset_i   :in  std_logic;
      count_o   :out  std_logic_vector(31 downto 0)
   );
end component;

component compare is
   port (
      angle_i   :in  std_logic_vector(31 downto 0);
	  count_i   :in  std_logic_vector(31 downto 0);
	  pwm_out   :out std_logic
   );
 end component

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
	  

   angle_counter: angle_counter
      port map (
	     clk           => clk,
		 reset_i       => reset_i,
         last_angle_i  => angle_s,
         angle_max_i   => angle_max_reg_s,
         angle_min_i   => angle_min_reg_s,
         state_pres_i  => state_pres_s,
         angle_next_o  => angle_s
	  );
	  
	  
   generic_counter: generic_counter
      generic map (
	     max_count => 1000000;
	  )
	  port map (
	     clk      => clk,
         reset_i  => reset_i,
         count_o  => period_count_s
	  );
	  
   compare: compare
      port map (
	  angle_i 
      count_i 
      pwm_out 
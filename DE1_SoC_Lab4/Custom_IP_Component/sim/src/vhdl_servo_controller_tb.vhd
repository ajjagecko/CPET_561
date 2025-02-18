-------------------------------------------------------------------------------
-- Dr. Kaputa, modified by Andrew Akre
-- seven segment test bench retrofited into eight_bit_sub_adder_tb
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vhdl_servo_controller_tb is
end vhdl_servo_controller_tb;

architecture arch of vhdl_servo_controller_tb is

component vhdl_servo_controller is
   port (
     clk           :in  std_logic;
	  reset_i       :in  std_logic;
	  addr_i        :in  std_logic;
	  write_data_i  :in  std_logic_vector(31 downto 0);
	  write_en_i    :in  std_logic;
	  pwm_o         :out std_logic;
	  irq_o         :out std_logic
	);
end component;


constant period :time := 10ns;
signal  clk           :std_logic;
signal  reset_i       :std_logic := '1';
signal  addr_i        :std_logic;
signal  write_data_i  :std_logic_vector(31 downto 0);
signal  write_en_i    :std_logic;
signal  pwm_o         :std_logic;
signal  irq_o         :std_logic;

begin

sequential_tb : process 
    begin
      report "****************** sequential testbench start ****************";
      -- Reset
      wait for 80ns;
      
      -- Addition 1
            
      report "****************** sequential testbench stop ****************";
      wait;
  end process; 

-- clock process
clock: process
  begin
    clk <= not clk;
    wait for period/2;
end process; 
 
-- reset process
async_reset: process
  begin
    wait for 2 * period;
    reset_i <= '0';
    wait;
end process;

-- DUT
dut: vhdl_servo_controller
   port map(
      clk          => clk,           
      reset_i      => reset_i,       
      addr_i       => addr_i,        
      write_data_i => write_data_i,  
      write_en_i   => write_en_i,    
      pwm_o        => pwm_o,         
      irq_o        => irq_o         
   );

end architecture;
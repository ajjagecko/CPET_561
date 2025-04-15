-------------------------------------------------------------------------------
-- Dr. Kaputa, modified by Andrew Akre
-- seven segment test bench retrofited into eight_bit_sub_adder_tb
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_signed.ALL;
use ieee.numeric_std.all;
use std.textio.all;

entity hpf_tb is
end hpf_tb;

architecture arch of hpf_tb is

component high_pass_filter is
   port(
      clk       :in std_logic;
      reset_n   :in std_logic;
      data_i    :in std_logic_vector(15 downto 0);
      filter_en :in std_logic;
      data_o    :out std_logic_vector(15 downto 0)
   );
end component;

constant period :time := 10ns;
signal clk               :std_logic := '0';
signal reset_n           :std_logic := '0';

signal data_i    :std_logic_vector(15 downto 0) := x"0000";
signal filter_en :std_logic := '0';
signal data_o    :std_logic_vector(15 downto 0) := x"0000"; 

TYPE audio IS ARRAY (39 DOWNTO 0) OF std_logic_vector (15 DOWNTO 0);
signal audioSampleArray :audio;

begin

sequential_tb : process 
   
   file read_file : text open read_mode is "../src/one_cycle_200_8k.csv";
   file results_file : text open write_mode is "../src/output_waveform.csv";
   variable lineIn : line;
   variable lineOut : line;
   variable readValue : integer;
   variable writeValue : integer;

begin
      wait for 100 ns;
      reset_n <= '1';
      --Read data from a file into array
      for i in 0 to 39 loop
         readline(read_file, lineIn);
         read(lineIn, readValue);
         audioSampleArray(i) <= std_logic_vector(to_signed(readValue, 16));
         wait for 50 ns;
      end loop;
      file_close(read_file);
      
      for i in 1 to 10 loop
         for j in 0 to 39 loop
         
            data_i <= audioSampleArray(j);
            filter_en <= '1';
            wait for 15 ns;
            filter_en <= '0';
            wait for 15 ns;
            
            --writeValue := to_integer(unsigned(data_o));
            writeValue := to_integer(signed(data_o));
            write(lineOut, writeValue);
            writeline(results_file, lineOut);
            
         end loop;
      end loop;
      
      file_close(results_file);
      
      wait;
      
end process; 

-- clock process
clock: process
  begin
    clk <= not clk;
    wait for period/2;
end process; 


-- DUT
dut:high_pass_filter
   port map (
	   clk       => clk,      
      reset_n   => reset_n, 
      data_i    => data_i,   
      filter_en => filter_en,
      data_o    => data_o   
	);

end architecture;
-------------------------------------------------------------------------------
-- Dr. Kaputa, modified by Andrew Akre
-- seven segment test bench retrofited into eight_bit_sub_adder_tb
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity raminfr_be_tb is
end raminfr_be_tb;

architecture arch of raminfr_be_tb is

component raminfr_be IS
   PORT(
     clk               :IN std_logic;
	  reset_n           :IN std_logic;
	  writebyteenable_n :In std_logic_vector(3 DOWNTO 0);
	  address           :IN std_logic_vector(11 DOWNTO 0);
	  writedata         :IN std_logic_vector(31 DOWNTO 0);
	  --
	  readdata  :OUT std_logic_vector(31 DOWNTO 0)
   );
END component raminfr_be;

constant period :time := 10ns;
signal clk               :std_logic := '0';
signal reset_i           :std_logic := '0';
signal i                 :unsigned(11 DOWNTO 0) := x"000";
signal writebyteenable_n :std_logic_vector(3 DOWNTO 0);
signal address           :std_logic_vector(11 DOWNTO 0);
signal writedata         :std_logic_vector(31 DOWNTO 0);
signal readdata          :std_logic_vector(31 DOWNTO 0);

begin

sequential_tb : process 
    begin
      report "****************** sequential testbench start ****************";
      -- Reset + first full cycle
      
      
      
      
      wait for 50ns; 
      for j in 0 to 4095 loop
         address <= std_logic_vector(i);
         writedata <= x"00000000";
         writebyteenable_n <= "0000";
         i <= i + x"001";
         wait for 5ns; 
         assert readdata = x"00000000" report "Failed Full Word Test";
         wait for 5ns; 
      end loop;
      
      for j in 0 to 4095 loop
         address <= std_logic_vector(i);
         writedata <= x"11111111";
         writebyteenable_n <= "0011";
         i <= i + x"001";
         wait for 5ns; 
         assert readdata = x"11110000" report "Failed Top Half Word Test";
         wait for 5ns; 
      end loop;
      
      
      for j in 0 to 4095 loop
         address <= std_logic_vector(i);
         writedata <= x"22222222";
         writebyteenable_n <= "1100";
         i <= i + x"001";
         wait for 5ns; 
         assert readdata = x"11112222" report "Failed Bottom Half Word Test";
         wait for 5ns; 
      end loop;
      
      for j in 0 to 4095 loop
         address <= std_logic_vector(i);
         writedata <= x"33333333";
         writebyteenable_n <= "1110";
         i <= i + x"001";
         wait for 5ns; 
         assert readdata = x"11112233" report "Failed Byte 0 Test";
         wait for 5ns; 
      end loop;
      
      for j in 0 to 4095 loop
         address <= std_logic_vector(i);
         writedata <= x"44444444";
         writebyteenable_n <= "1101";
         i <= i + x"001";
         wait for 5ns; 
         assert readdata = x"11114433" report "Failed Byte 1 Test";
         wait for 5ns; 
      end loop;
      
      for j in 0 to 4095 loop
         address <= std_logic_vector(i);
         writedata <= x"55555555";
         writebyteenable_n <= "1011";
         i <= i + x"001";
         wait for 5ns; 
         assert readdata = x"11554433" report "Failed Byte 2 Test";
         wait for 5ns; 
      end loop;
      
      for j in 0 to 4095 loop
         address <= std_logic_vector(i);
         writedata <= x"66666666";
         writebyteenable_n <= "0111";
         i <= i + x"001";
         wait for 5ns; 
         assert readdata = x"66554433" report "Failed Byte 0 Test";
         wait for 5ns; 
      end loop;
      
      assert readdata = x"00000000" report "Simulation Complete";
      
      
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
    reset_i <= '1';
    wait;
end process;

-- DUT
dut:raminfr_be
   PORT MAP(
     clk               => clk              ,
	  reset_n           => reset_i          ,
	  writebyteenable_n => writebyteenable_n,
	  address           => address          ,
	  writedata         => writedata        ,
	  --                   --
	  readdata          => readdata         
   );


end architecture;
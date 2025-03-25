-------------------------------------------------------------------------------------
-- Name:   Andrew  Akre
-- Course: CPET 561
-- Task:
--       Custom I/O Component RAM
-------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY raminfr_be IS
   PORT(
     clk               :IN std_logic;
	  reset_n           :IN std_logic;
	  writebyteenable_n :In std_logic_vector(3 DOWNTO 0);
	  address           :IN std_logic_vector(11 DOWNTO 0);
	  writedata         :IN std_logic_vector(31 DOWNTO 0);
	  --
	  readdata  :OUT std_logic_vector(31 DOWNTO 0)
   );
END ENTITY raminfr_be;

ARCHITECTURE rtl OF raminfr_be IS
   
   TYPE ram_type IS ARRAY (4095 DOWNTO 0) OF std_logic_vector (7 DOWNTO 0);
   SIGNAL RAM0       :ram_type;
   SIGNAL RAM1       :ram_type;
   SIGNAL RAM2       :ram_type;
   SIGNAL RAM3       :ram_type;
   SIGNAL read_addr :std_logic_vector(11 DOWNTO 0);
   
BEGIN

   RamBlock:PROCESS(clk)
   BEGIN
      IF (clk'event AND clk = '1') THEN
         IF (reset_n = '0') THEN
            read_addr <=(OTHERS=>'0');
         ELSE
            CASE writebyteenable_n is
               when "0000" =>
                  RAM0(conv_integer(address)) <= writedata(7 DOWNTO 0);
                  RAM1(conv_integer(address)) <= writedata(15 DOWNTO 8);
                  RAM2(conv_integer(address)) <= writedata(23 DOWNTO 16);
                  RAM3(conv_integer(address)) <= writedata(31 DOWNTO 24);
               when "0001" =>
                  RAM1(conv_integer(address)) <= writedata(15 DOWNTO 8);
                  RAM2(conv_integer(address)) <= writedata(23 DOWNTO 16);
                  RAM3(conv_integer(address)) <= writedata(31 DOWNTO 24);
               when "0010" =>
                  RAM0(conv_integer(address)) <= writedata(7 DOWNTO 0);
                  RAM2(conv_integer(address)) <= writedata(23 DOWNTO 16);
                  RAM3(conv_integer(address)) <= writedata(31 DOWNTO 24);
               when "0011" => 
                  RAM2(conv_integer(address)) <= writedata(23 DOWNTO 16);
                  RAM3(conv_integer(address)) <= writedata(31 DOWNTO 24); 
               when "0100" =>
                  RAM0(conv_integer(address)) <= writedata(7 DOWNTO 0);
                  RAM1(conv_integer(address)) <= writedata(15 DOWNTO 8);
                  RAM3(conv_integer(address)) <= writedata(31 DOWNTO 24);
               when "0101" =>
                  RAM1(conv_integer(address)) <= writedata(15 DOWNTO 8);
                  RAM3(conv_integer(address)) <= writedata(31 DOWNTO 24);
               when "0110" =>
                  RAM0(conv_integer(address)) <= writedata(7 DOWNTO 0);
                  RAM3(conv_integer(address)) <= writedata(31 DOWNTO 24);
               when "0111" =>
                  RAM3(conv_integer(address)) <= writedata(31 DOWNTO 24);
               when "1000" =>
                  RAM0(conv_integer(address)) <= writedata(7 DOWNTO 0);
                  RAM1(conv_integer(address)) <= writedata(15 DOWNTO 8);
                  RAM2(conv_integer(address)) <= writedata(23 DOWNTO 16);
               when "1001" =>
                  RAM1(conv_integer(address)) <= writedata(15 DOWNTO 8);
                  RAM2(conv_integer(address)) <= writedata(23 DOWNTO 16);
               when "1010" =>
                  RAM0(conv_integer(address)) <= writedata(7 DOWNTO 0);
                  RAM2(conv_integer(address)) <= writedata(23 DOWNTO 16);
               when "1011" =>
                  RAM2(conv_integer(address)) <= writedata(23 DOWNTO 16);
               when "1100" =>
                  RAM0(conv_integer(address)) <= writedata(7 DOWNTO 0);
                  RAM1(conv_integer(address)) <= writedata(15 DOWNTO 8);
               when "1101" =>
                  RAM1(conv_integer(address)) <= writedata(15 DOWNTO 8);
               when "1110" =>
                  RAM0(conv_integer(address)) <= writedata(7 DOWNTO 0);
               when OTHERS =>
            END CASE; 
         END IF;
         read_addr <= address;
      END IF;
   END PROCESS RamBlock;
   
   readdata <= RAM3(conv_integer(read_addr)) & RAM2(conv_integer(read_addr)) & RAM1(conv_integer(read_addr)) & RAM0(conv_integer(read_addr));

END ARCHITECTURE rtl;
   
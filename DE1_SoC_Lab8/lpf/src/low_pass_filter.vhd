-- Lab 8 Filter
-- Andrew Akre

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_signed.all;

entity low_pass_filter is
   port(
      clk       :in std_logic;
      reset_n   :in std_logic;
      data_i    :in std_logic_vector(15 downto 0);
      filter_en :in std_logic;
      data_o    :out std_logic_vector(15 downto 0)
   );
end low_pass_filter;

architecture beh of low_pass_filter is

TYPE data_array IS ARRAY (16 DOWNTO 0) OF std_logic_vector (15 DOWNTO 0);
TYPE result_array IS ARRAY (16 DOWNTO 0) OF std_logic_vector (31 DOWNTO 0);

constant low_pass_const :data_array := (x"0052", x"00BB", x"01E2", x"0408", x"071B", x"0AAD", x"0E11", x"1080", x"1162", x"1080", x"0E11", x"0AAD",x"071B", x"0408", x"01E2", x"00BB", x"0052");
signal dataa_sig        :data_array := (OTHERS=>x"0000");
signal result_sig       :data_array := (OTHERS=>x"0000");
signal result_full      :result_array := (OTHERS=>x"00000000");

component mult_ip is
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		result	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;

component filter_delay_block is
   port(
      clk       :in std_logic;
      reset_n   :in std_logic;
      data_i    :in std_logic_vector(15 downto 0);
      filter_en :in std_logic;
      data_o    :out std_logic_vector(15 downto 0)
   );
end component;

begin

   dataa_sig(0) <= data_i;
   
   regs: for i in 0 to 15 generate 
      reg_block:filter_delay_block
         port map(
            clk       => clk,
            reset_n   => reset_n,
            data_i    => dataa_sig(i),
            filter_en => filter_en,
            data_o    => dataa_sig((i + 1))
         );
   end generate;

   mult: for i in 0 to 16 generate
      mult_ip_inst : mult_ip 
         PORT MAP (
		      dataa	 => dataa_sig(i),
		      datab	 => low_pass_const(i),
		      result => result_full(i)
         );
         
      result_sig(i) <= result_full(i)(30 downto 15);
   end generate;
   
   data_o <= result_sig(16) + result_sig(15) + result_sig(14) + result_sig(13) + result_sig(12) + result_sig(11) + result_sig(10) + result_sig(9) + result_sig(8) + result_sig(7) + result_sig(6) + result_sig(5) + result_sig(4) + result_sig(3) + result_sig(2) + result_sig(1) + result_sig(0);

end beh;

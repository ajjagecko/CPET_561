-- Lab 8 Filter
-- Andrew Akre

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_signed.all;

entity high_pass_filter is
   port(
      clk       :in std_logic;
      reset_n   :in std_logic;
      data_i    :in std_logic_vector(15 downto 0);
      filter_en :in std_logic;
      data_o    :out std_logic_vector(15 downto 0)
   );
end high_pass_filter;

architecture beh of high_pass_filter is

TYPE data_array IS ARRAY (16 DOWNTO 0) OF std_logic_vector (15 DOWNTO 0);
TYPE result_array IS ARRAY (16 DOWNTO 0) OF std_logic_vector (31 DOWNTO 0);

constant high_pass_const :data_array := (x"003E", x"FF9B", x"FE9F", x"0000", x"0535", x"05B2", x"F5AC", x"DAB7", x"4C91", x"DAB7", x"F5AC", x"05B2", x"0535", x"0000", x"FE9F", x"FF9B", x"003E");
signal dataa_sig        :data_array := (OTHERS=>x"0000");
signal result_sig       :std_logic_vector (31 DOWNTO 0);
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
		      datab	 => high_pass_const(i),
		      result => result_full(i)
         );
   end generate;
   
   result_sig <= result_full(16) + result_full(15) + result_full(14) + result_full(13) + result_full(12) + result_full(11) + result_full(10) + result_full(9) + result_full(8) + result_full(7) + result_full(6) + result_full(5) + result_full(4) + result_full(3) + result_full(2) + result_full(1) + result_full(0);
   data_o <= result_sig(30 downto 15);

end beh;

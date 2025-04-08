-- Lab 8 Filter
-- Andrew Akre

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.std_logic_signed.all;

entity low_pass_filter is
   port(
      clk       :in std_logic;
      reset_n   :in std_logic;
      data_i    :in std_logic_vector(15 dowtno 0);
      filter_en :in std_logic;
      data_o    :out std_logic_vector(15 downto 0)
   );
end low_pass_filter;

architecture beh of low_pass_filter is

TYPE filter_const IS ARRAY (16 DOWNTO 0) OF std_logic_vector (15 DOWNTO 0);
constant low_pass_const :filter_const := ();

signal result_sig :std_logic_vector(16 downto 0);


component mult_ip is
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;

component delay_ff is
	PORT
	(
		dataa		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		ff_en    : IN STD_LOGIC;
		result	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;

begin

   dataa_sig(0) <= data_in

   mult: for i in 0 to 16 generate
      mult_ip_inst : mult_ip 
         PORT MAP (
		      dataa	 => dataa_sig(i),
		      datab	 => low_pass_const(i),
		      result => result_sig(i)
         );
   end generate;
   
   data_o <= 
   
	   
   

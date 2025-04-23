-- Lab 9 Filter (modified Lab 8 hpf)
-- Andrew Akre

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;

entity fir_filter is
   port(
      clk        :in std_logic;
      reset_n    :in std_logic;
      addr_i     :in std_logic;
      data_i     :in std_logic_vector(15 downto 0);
      write_en_i :in std_logic;
      data_o     :out std_logic_vector(15 downto 0)
   );
end fir_filter;

architecture beh of fir_filter is

TYPE data_array IS ARRAY (16 DOWNTO 0) OF std_logic_vector (15 DOWNTO 0);
TYPE result_array IS ARRAY (16 DOWNTO 0) OF std_logic_vector (31 DOWNTO 0);

signal high_pass_const :data_array := (x"003E", x"FF9B", x"FE9F", x"0000", x"0535", x"05B2", x"F5AC", x"DAB7", x"4C91", x"DAB7", x"F5AC", x"05B2", x"0535", x"0000", x"FE9F", x"FF9B", x"003E");
signal low_pass_const :data_array := (x"0052", x"00BB", x"01E2", x"0408", x"071B", x"0AAD", x"0E11", x"1080", x"1162", x"1080", x"0E11", x"0AAD",x"071B", x"0408", x"01E2", x"00BB", x"0052");

signal const_sig        :data_array := (OTHERS=>x"0000");
signal dataa_sig        :data_array := (OTHERS=>x"0000");
signal result_sig       :signed (31 DOWNTO 0);
signal result_full      :result_array := (OTHERS=>x"00000000");

signal filter_type      :std_logic := '0';
signal data_in_s        :std_logic_vector(15 downto 0);

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
   in_reg: process(clk, data_i, addr_i, data_in_s, filter_type)
      begin
         data_in_s   <= data_in_s;
         filter_type <= filter_type;
         if(clk'event and clk = '1') then
            if (write_en_i = '1') then
               case addr_i is
                  when '0' =>
                     data_in_s <= data_i;
                  when '1' => 
                     filter_type <= data_i(0);
                  when others =>
                     data_in_s <= data_in_s;
                     filter_type <= filter_type;
               end case;
            end if;
         end if;
      end process;






   const_mux:process(filter_type, high_pass_const, low_pass_const)
   begin
      if(filter_type = '1') then
         const_sig <= high_pass_const;
      else
         const_sig <= low_pass_const;
      end if;
   end process;

   clk_in:process(clk, data_in_s)
   begin
      dataa_sig(0) <= dataa_sig(0);
      if(clk'event and clk = '1') then
         dataa_sig(0) <= data_in_s;
	  end if;
   end process;
   
   regs: for i in 0 to 15 generate 
      reg_block:filter_delay_block
         port map(
            clk       => clk,
            reset_n   => reset_n,
            data_i    => dataa_sig(i),
            filter_en => write_en_i,
            data_o    => dataa_sig((i + 1)) -- Feeds to next value in delay path
         );
   end generate;

   mult: for i in 0 to 16 generate
      mult_ip_inst : mult_ip 
         PORT MAP (
		      dataa	 => dataa_sig(i),
		      datab	 => const_sig(i),
		      result => result_full(i)
         );
   end generate;
   
   result_sig <= signed(result_full(16)) + signed(result_full(15)) + signed(result_full(14)) + signed(result_full(13)) + signed(result_full(12)) + signed(result_full(11)) + signed(result_full(10)) + signed(result_full(9)) + signed(result_full(8)) + signed(result_full(7)) + signed(result_full(6)) + signed(result_full(5)) + signed(result_full(4)) + signed(result_full(3)) + signed(result_full(2)) + signed(result_full(1)) + signed(result_full(0));
   data_o <= std_logic_vector(result_sig(30 downto 15));

end beh;

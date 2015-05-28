library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity delay_chain is
	generic(
		C_CLK_FREQ_HZ : integer := 40000000;
		width        : integer := 1
	);
	port(
		clk_i		: in  std_logic;
		delay		: in	std_logic_vector(3 downto 0);
		data_i	: in  std_logic_vector(width-1 downto 0);
		data_o	: out std_logic_vector(width-1 downto 0)
	);
end delay_chain;

architecture Behavioral of delay_chain is

begin
	
	-- Docs:
	-- http://www.xilinx.com/support/documentation/sw_manuals/xilinx14_7/xst_v6s6.pdf
	-- http://www.xilinx.com/support/documentation/application_notes/xapp465.pdf
	
	gen_SRLC16E_reg : for i in 0 to (width-1) generate
	begin
		SRLC16E_reg : SRLC16E
		generic map(
			INIT => X"0000"
		)
		port map(
			D 		=> data_i(i), 	-- insert input signal
			CLK 	=> clk_i, 		-- insert Clock signal
			CE		=> '1',
			A0 	=> delay(0), 	-- insert Address 0 signal
			A1 	=> delay(1), 	-- insert Address 1 signal
			A2 	=> delay(2), 	-- insert Address 2 signal
			A3 	=> delay(3), 	-- insert Address 3 signal
			Q 		=> data_o(i), 	-- insert output signal
			Q15 	=> open			-- insert cascadable output signal	
		);
	end generate gen_SRLC16E_reg;
	
end Behavioral;


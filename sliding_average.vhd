library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sliding_average is
	generic(
		C_CLK_FREQ_HZ   : integer := 40000000;
		length			: integer := 5
	);
	port(
		clk_i	: in  std_logic;
		data_i	: in  std_logic;
		data_o	: out std_logic
	);
end sliding_average;

architecture Behavioral of sliding_average is

begin


end Behavioral;


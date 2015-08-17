library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.functions.all;
use work.components.all;

entity edge_detector is
	port(
		clk_i		: in  std_logic;
		signal_i	: in  std_logic;
		edge_o		: out std_logic
	);
end entity edge_detector;

architecture Behavioral of edge_detector is
	signal signal_reg : std_logic;
begin

	process(clk_i)
	begin
		if rising_edge(clk_i) then
			signal_reg <= signal_i;
		end if;
	end process;
	edge_o <= (not signal_i) and signal_reg;

end architecture Behavioral;

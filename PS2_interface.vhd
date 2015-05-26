library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PS2_interface is
	generic(
		C_CLK_FREQ_HZ        : integer := 40000000
	);
	port ( 
		clk_i				: in  	std_logic;
		ps2_clk_io		: inout  std_logic;
		ps2_data_io		: inout  std_logic;
		ps2_key_up_o   : out 	std_logic;
		ps2_key_down_o : out 	std_logic
	);
end PS2_interface;

architecture Behavioral of PS2_interface is


begin

	--DUMMY PROCESS
	process(clk_i)
	begin
		if rising_edge(clk_i) then
				if ps2_clk_io = '0' and ps2_data_io = '0' then
					ps2_key_up_o	<= '0';
					ps2_key_down_o <= '1';
				else
					ps2_key_up_o	<= '1';
					ps2_key_down_o <= '0';
				end if;
		end if;
	end process;

end Behavioral;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PS2_interface is
	generic(
		C_CLK_FREQ_HZ        : integer := 40000000
	);
	port ( 
		clk_i				: in  	std_logic;
		ps2_clk_io		: in  	std_logic;	-- inout for PS/2 keyboard
		ps2_data_io		: in	  	std_logic;	-- inout for PS/2 keyboard
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
			ps2_key_up_o	<= ps2_clk_io;
			ps2_key_down_o <= ps2_data_io;
		end if;
	end process;

end Behavioral;


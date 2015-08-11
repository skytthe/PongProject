library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debug is
	generic(
		C_CLK_FREQ_HZ     : integer := 40000000
	);
	port(
		clk_i		 		: in  std_logic;
		debug_i			: in	std_logic_vector(6 downto 0);
		led_o				: out std_logic_vector(6 downto 0)
	);
end debug;

architecture Behavioral of debug is
	signal led : std_logic_vector(6 downto 0);
begin

	process(clk_i)
	begin
		if rising_edge(clk_i) then
			led <= debug_i;
		end if;
	end process;
	
	
	process(clk_i)
	begin
		if rising_edge(clk_i) then
			led_o <= led;
		end if;
	end process;
	

end Behavioral;


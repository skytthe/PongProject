library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity user_input is
	generic(
		C_CLK_FREQ_HZ     : integer := 40000000
	);
	port(
		clk_i		 		: in  std_logic;
		dip4_i			: in	std_logic_vector(3 downto 0);
		dip8_i			: in	std_logic_vector(7 downto 0);
		btn_i				: in	std_logic_vector(1 downto 0);
		control_o		: out std_logic_vector(6 downto 0)
	);
end user_input;

architecture Behavioral of user_input is

	signal a,b,c : std_logic;

begin
	

	a <= dip4_i(3) or dip4_i(2) or dip4_i(1) or dip4_i(0);
	b <= dip8_i(7) or dip8_i(6) or dip8_i(5) or dip8_i(4) or dip8_i(3) or dip8_i(2) or dip8_i(1) or dip8_i(0);
	c <= btn_i(1) or btn_i(0);

	process(clk_i)
	begin
		if rising_edge(clk_i) then
			control_o <= a&b&c & btn_i & a & b; 
		end if;
	end process;

end Behavioral;


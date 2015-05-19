library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
	port(
		-- onboard clock input
		clk_200M_i 		: in  std_logic;
				-- onboard leds output
		led_o 			: out std_logic_vector (3 downto 0);
		
		-- Baseboard 4-bit dip-switch input
		dip_sw_i			: in	std_logic_vector (3 downto 0)
	);
end main;

architecture Behavioral of main is
	signal wire : std_logic_vector(3 downto 0);
begin
	
	
	process(clk_200M_i)
	begin
		if rising_edge(clk_200M_i) then
			wire <= dip_sw_i;
		end if;
	end process;
	
	process(clk_200M_i)
	begin
		if rising_edge(clk_200M_i) then
			led_o <= wire;
		end if;
	end process;

end Behavioral;


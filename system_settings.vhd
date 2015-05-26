library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity system_settings is
	port(
		clk_i          		: in	std_logic;
		dip4_db_i      		: in 	std_logic_vector(3 downto 0);
		dip4_db_tick_i 		: in 	std_logic_vector(3 downto 0);
		dip8_db_i      		: in 	std_logic_vector(7 downto 0);
		dip8_db_tick_i 		: in 	std_logic_vector(7 downto 0);		
		ctrl_gc_ps2_ena_o		: out std_logic;
		ctrl_led_o				: out	std_logic_vector(3 downto 0)
	);
end system_settings;

architecture Behavioral of system_settings is
	signal a,b,c,d : std_logic;
begin
	a <= dip4_db_i(3) or dip4_db_i(2) or dip4_db_i(1) or dip4_db_i(0);
	b <= dip8_db_i(7) or dip8_db_i(6) or dip8_db_i(5) or dip8_db_i(4) or dip8_db_i(3) or dip8_db_i(2) or dip8_db_i(1) or dip8_db_i(0);
	c <= dip4_db_tick_i(3) or dip4_db_tick_i(2) or dip4_db_tick_i(1) or dip4_db_tick_i(0);
	d <= dip8_db_tick_i(7) or dip8_db_tick_i(6) or dip8_db_tick_i(5) or dip8_db_tick_i(4) or dip8_db_tick_i(3) or dip8_db_tick_i(2) or dip8_db_tick_i(1) or dip8_db_tick_i(0);

	process(clk_i)
	begin
		if rising_edge(clk_i) then			
			ctrl_led_o <= a & b & c & d;
		end if;
	end process;

end Behavioral;


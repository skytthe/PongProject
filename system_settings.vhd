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
		chipscope_i				: in 	std_logic;
		-- Filter
		ctrl_filter_select_o	: out	std_logic;
		-- Graphics Engine
		ctrl_ge_signal_o		: out	std_logic;
		-- Game Controller
		ctrl_gc_ps2_ena_o		: out	std_logic;
		ctrl_gc_cs_ena_o		: out	std_logic;
		-- MicroBlaze
		ctrl_MB_ai_ena_o		: out	std_logic;
		-- Debug
		ctrl_debug_led_o		: out	std_logic_vector(3 downto 0)
	);
end system_settings;

architecture Behavioral of system_settings is
	signal a,b,c,d : std_logic;
begin

	-- simple DIP switch based control
	process(clk_i)
	begin
		if rising_edge(clk_i) then
			ctrl_filter_select_o	<= dip8_db_i(0);
			-- Graphics Engine
			ctrl_ge_signal_o		<= dip8_db_i(2);
			-- Game Controller
			ctrl_gc_ps2_ena_o		<= dip8_db_i(6);
			ctrl_gc_cs_ena_o		<= chipscope_i;
			-- MicroBlaze
			ctrl_MB_ai_ena_o		<= dip8_db_i(7);
			-- Debug
			ctrl_debug_led_o(3)	<= dip8_db_i(7);
			ctrl_debug_led_o(2)	<= dip8_db_i(6);
			ctrl_debug_led_o(1)	<= chipscope_i;
			ctrl_debug_led_o(0)	<= a or b or c or d;
		end if;
	end process;



	a <= dip4_db_i(3) or dip4_db_i(2) or dip4_db_i(1) or dip4_db_i(0);
	b <= dip8_db_i(7) or dip8_db_i(6) or dip8_db_i(5) or dip8_db_i(4) or dip8_db_i(3) or dip8_db_i(2) or dip8_db_i(1) or dip8_db_i(0);
	c <= dip4_db_tick_i(3) or dip4_db_tick_i(2) or dip4_db_tick_i(1) or dip4_db_tick_i(0);
	d <= dip8_db_tick_i(7) or dip8_db_tick_i(6) or dip8_db_tick_i(5) or dip8_db_tick_i(4) or dip8_db_tick_i(3) or dip8_db_tick_i(2) or dip8_db_tick_i(1) or dip8_db_tick_i(0);

end Behavioral;


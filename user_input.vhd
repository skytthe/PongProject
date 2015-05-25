library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity user_input is
	generic(
		C_CLK_FREQ_HZ        : integer := 40000000;
		C_DEBOUNCE_PERIOD_MS : integer := 10
	);
	port(
		clk_i     	: in  std_logic;
		dip4_i    	: in  std_logic_vector(3 downto 0);
		dip8_i    	: in  std_logic_vector(7 downto 0);
		btn_i     	: in  std_logic_vector(1 downto 0);
		ps2_clk_io	: in	std_logic;
		ps2_data_io	: in	std_logic;
		control_o 	: out std_logic_vector(6 downto 0)
	);
end user_input;

architecture Behavioral of user_input is
	signal a, b, c : std_logic;

begin

	generate_debounce_dip4 : for i in 0 to 3 generate
		debounce_dip4 : entity work.debounce
			generic map(
				C_CLK_FREQ_HZ        => C_CLK_FREQ_HZ,
				C_DEBOUNCE_PERIOD_MS => C_DEBOUNCE_PERIOD_MS,
				C_EDGE_SENSITIVITY   => 0
			)
			port map(
				clk_i      => clk_i,
				signal_i   => dip4_i(i),
				db_level_o => open,
				db_tick_o  => open
			);
	end generate generate_debounce_dip4;

	generate_debounce_dip8 : for i in 0 to 7 generate
		debounce_dip8 : entity work.debounce
			generic map(
				C_CLK_FREQ_HZ        => C_CLK_FREQ_HZ,
				C_DEBOUNCE_PERIOD_MS => C_DEBOUNCE_PERIOD_MS,
				C_EDGE_SENSITIVITY   => 0
			)
			port map(
				clk_i      => clk_i,
				signal_i   => dip8_i(i),
				db_level_o => open,
				db_tick_o  => open
			);
	end generate generate_debounce_dip8;

	generate_debounce_btn : for i in 0 to 1 generate
		debounce_dip4 : entity work.debounce
			generic map(
				C_CLK_FREQ_HZ        => C_CLK_FREQ_HZ,
				C_DEBOUNCE_PERIOD_MS => C_DEBOUNCE_PERIOD_MS,
				C_EDGE_SENSITIVITY   => 0
			)
			port map(
				clk_i      => clk_i,
				signal_i   => btn_i(i),
				db_level_o => open,
				db_tick_o  => open
			);
	end generate generate_debounce_btn;
	
--	ps2_interface : entity work.PS2_interface
--		port map(
--			
--		);

	a <= dip4_i(3) or dip4_i(2) or dip4_i(1) or dip4_i(0);
	b <= dip8_i(7) or dip8_i(6) or dip8_i(5) or dip8_i(4) or dip8_i(3) or dip8_i(2) or dip8_i(1) or dip8_i(0);
	c <= btn_i(1) or btn_i(0);

	process(clk_i)
	begin
		if rising_edge(clk_i) then
			control_o <= a & b & c & btn_i & a & b;
		end if;
	end process;

end Behavioral;


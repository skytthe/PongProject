library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity user_input is
	generic(
		C_CLK_FREQ_HZ        : integer := 40000000;
		C_DEBOUNCE_PERIOD_MS : integer := 10
	);
	port(
		clk_i          : in  	std_logic;
		dip4_i         : in  	std_logic_vector(3 downto 0);
		dip8_i         : in  	std_logic_vector(7 downto 0);
		btn_i          : in  	std_logic_vector(1 downto 0);
--		ps2_clk_io     : inout  std_logic;
--		ps2_data_io    : inout  std_logic;
		dip4_db_o      : out 	std_logic_vector(3 downto 0);
		dip4_db_tick_o : out 	std_logic_vector(3 downto 0);
		dip8_db_o      : out 	std_logic_vector(7 downto 0);
		dip8_db_tick_o : out 	std_logic_vector(7 downto 0);
		btn_db_o       : out 	std_logic_vector(1 downto 0);
		btn_db_tick_o  : out		std_logic_vector(1 downto 0);
		ps2_key_up_o   : out 	std_logic;
		ps2_key_down_o : out 	std_logic
	);
end user_input;

architecture Behavioral of user_input is

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
				db_level_o => dip4_db_o(i),
				db_tick_o  => dip4_db_tick_o(i)
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
				db_level_o => dip8_db_o(i),
				db_tick_o  => dip8_db_tick_o(i)
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
				db_level_o => btn_db_o(i),
				db_tick_o  => btn_db_tick_o(i)
			);
	end generate generate_debounce_btn;

	-- TODO:	implement actual PS/2 keyboard interface
	--			up / down keys emulated with push btns
	ps2_interface : entity work.PS2_interface
		generic map(
			C_CLK_FREQ_HZ => C_CLK_FREQ_HZ
		)
		port map(
			clk_i  			=> clk_i,
			ps2_clk_io  	=> btn_i(0),--ps2_clk_io,
		   ps2_data_io 	=> btn_i(1),--ps2_data_io,
		   ps2_key_up_o   => ps2_key_up_o,
		   ps2_key_down_o => ps2_key_down_o
		);

end Behavioral;


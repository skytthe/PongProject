library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filter is
	generic(
		C_CLK_FREQ_HZ     : integer := 40000000
	);
	port(
		clk_i 					: in  std_logic;
		-- input from vga sampler
		hsync_i				: in  std_logic;
		vsync_i				: in  std_logic;
		data_i				: in  std_logic;
		pixel_x_i			: in	std_logic_vector(10 downto 0);
		pixel_y_i			: in	std_logic_vector(9 downto 0);
		-- output for graphics engine
		filter_ge_hsync_o		: out std_logic;
		filter_ge_vsync_o		: out std_logic;
		filter_ge_data_o		: out std_logic;
		filter_ge_pixel_x_o	: out	std_logic_vector(10 downto 0);
		filter_ge_pixel_y_o	: out std_logic_vector(9 downto 0);
		-- output for game state detector
		filter_gs_hsync_o		: out std_logic;
		filter_gs_vsync_o		: out std_logic;
		filter_gs_data_o		: out std_logic;
		filter_gs_pixel_x_o	: out	std_logic_vector(10 downto 0);
		filter_gs_pixel_y_o	: out std_logic_vector(9 downto 0)
	);
end filter;

architecture Behavioral of filter is
	signal sliding_average_data : std_logic;
begin

	-- Sliding average filter
	sliding_average : entity work.sliding_average
	generic map(
		C_CLK_FREQ_HZ	=> 40000000,
		FILTER_LENGTH	=> 5
	)
	port map(
		clk_i		=> clk_i,
		data_i	=> data_i,
		data_o	=> sliding_average_data
	);	

	process (clk_i) is
	begin
		if rising_edge(clk_i) then
		filter_ge_hsync_o		<= hsync_i;
		filter_ge_vsync_o		<= vsync_i;
		filter_ge_data_o		<= sliding_average_data;
		filter_ge_pixel_x_o	<= pixel_x_i;
		filter_ge_pixel_y_o	<= pixel_y_i;

		filter_gs_hsync_o		<= hsync_i;
		filter_gs_vsync_o		<= vsync_i;
		filter_gs_data_o		<= sliding_average_data;
		filter_gs_pixel_x_o	<= pixel_x_i;
		filter_gs_pixel_y_o	<= pixel_y_i;
		end if;
	end process;
	
end Behavioral;


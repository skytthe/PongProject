library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_sampler is
	generic(
		C_CLK_FREQ_HZ     : integer := 40000000
	);
	port(
		--
		clk_i 		: in  std_logic;
		--
		control_i	: in std_logic_vector(3 downto 0);
		--	adc
		vga_hsync_i		: in  std_logic;
		vga_vsync_i		: in  std_logic;
		vga_data_i		: in  std_logic;
		-- 
		vga_hsync_o		: out	std_logic;
		vga_vsync_o		: out	std_logic;	
		vga_data_o		: out	std_logic;
		vga_pixel_x_o	: out	std_logic_vector(10 downto 0);
		vga_pixel_y_o	: out std_logic_vector(9 downto 0)
	);
end VGA_sampler;

architecture Behavioral of VGA_sampler is
	signal hsync_delayed,vsync_delayed : std_logic;
begin


	-- threshold: only read MSB from red ADC channel
	threshold : process (clk_i) is
	begin
		if rising_edge(clk_i) then
			vga_data_o  <= vga_data_i;
		end if;
	end process threshold;
	
	-- Pixel counter
	pixel_counter : entity work.pixel_counter
		generic map(
			C_CLK_FREQ_HZ	=> C_CLK_FREQ_HZ
		)
		port map(
		clk_40M_i 		=> clk_i,
		hsync_i 			=> hsync_delayed,
		vsync_i 			=> vsync_delayed,
		pixel_x_o 		=> vga_pixel_x_o,
		pixel_y_o 		=> vga_pixel_y_o,
		visable_area_o	=> open		
		);


	-- Delay chain
	sync_delay : entity work.delay_chain
		generic map(
			C_CLK_FREQ_HZ	=> C_CLK_FREQ_HZ,
			width				=> 2
		)
		port map(
			clk_i => clk_i,
			delay => control_i,
			data_i(0) => vga_hsync_i,
			data_i(1) => vga_vsync_i,
			data_o(0) => hsync_delayed,
			data_o(1) => vsync_delayed
		);
	
	vga_hsync_o <= hsync_delayed;
	vga_vsync_o <= vsync_delayed;
	
end Behavioral;


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
		
		--	adc
		vga_hsync_i		: in  std_logic;
		vga_vsync_i		: in  std_logic;
		vga_r_clk_o		: out std_logic;
		vga_r_i			: in  std_logic_vector(9 downto 0);
		vga_g_clk_o		: out std_logic;
		vga_g_i			: in  std_logic_vector(9 downto 0);
		vga_b_clk_o		: out std_logic;
		vga_b_i			: in  std_logic_vector(9 downto 0);
		
		-- 
		vga_hsync_o		: out  std_logic;
		vga_vsync_o		: out  std_logic;	
		vga_data_o		: out  std_logic
	);
end VGA_sampler;

architecture Behavioral of VGA_sampler is

begin


end Behavioral;


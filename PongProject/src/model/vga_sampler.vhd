library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.log_pkg.all;

entity vga_sampler is
	port (
		clk_i		: in std_logic;
		rst			: in std_logic;
		
		r_i			: in  std_logic_vector(C_ADC_WIDTH-1 downto 0);
		g_i			: in  std_logic_vector(C_ADC_WIDTH-1 downto 0);
		b_i			: in  std_logic_vector(C_ADC_WIDTH-1 downto 0);
		hsync_i		: in  std_logic;
		vsync_i 	: in  std_logic;
		
		color_o		: out std_logic;
		hsync_o 	: out std_logic;
		vsync_o 	: out std_logic;
		pixel_cnt_o	: out std_logic_vector(log2r(C_PIXEL_PR_LINE)-1 downto 0);
		line_cnt_o	: out std_logic_vector(log2r(C_LINES_PR_FRAME)-1 downto 0)
	);
end entity vga_sampler;

architecture Behavioral of vga_sampler is
	
begin
	
end architecture Behavioral;

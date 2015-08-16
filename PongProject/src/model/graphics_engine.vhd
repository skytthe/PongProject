library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.functions.all;
use work.components.all;

entity graphics_engine is
	port (
		clk : in std_logic;
		rst : in std_logic;
		
		control		: in  std_logic_vector(2 downto 0);
		
		color_i		: in  std_logic;
		hsync_i 	: in  std_logic;
		vsync_i 	: in  std_logic;
		pixel_cnt_i	: in  std_logic_vector(log2r(C_PIXEL_PR_LINE)-1 downto 0);
		line_cnt_i	: in  std_logic_vector(log2r(C_LINES_PR_FRAME)-1 downto 0);
		
		r_o			: out std_logic_vector(C_DAC_WIDTH-1 downto 0);
		g_o			: out std_logic_vector(C_DAC_WIDTH-1 downto 0);
		b_o			: out std_logic_vector(C_DAC_WIDTH-1 downto 0);
		hsync_o		: out std_logic;
		vsync_o		: out std_logic
	);
end entity graphics_engine;

architecture Behavioral of graphics_engine is
	
begin
	
end architecture Behavioral;
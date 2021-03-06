library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.functions.all;
use work.components.all;

entity filter is
	port (
		clk_i : in std_logic;
		
		control_i		: in  std_logic_vector(2 downto 0);
		
		color_i		: in  std_logic;
		hsync_i 	: in  std_logic;
		vsync_i 	: in  std_logic;
		pixel_cnt_i	: in  std_logic_vector(log2r(C_PIXEL_PR_LINE)-1 downto 0);
		line_cnt_i	: in  std_logic_vector(log2r(C_LINES_PR_FRAME)-1 downto 0);
		
		-- for game state detector
		color_gsd_o		: out std_logic;
		pixel_cnt_gsd_o	: out std_logic_vector(log2r(C_PIXEL_PR_LINE)-1 downto 0);
		line_cnt_gsd_o	: out std_logic_vector(log2r(C_LINES_PR_FRAME)-1 downto 0);
		
		-- for graphics engine
		color_ge_o		: out std_logic;
		hsync_ge_o 		: out std_logic;
		vsync_ge_o 		: out std_logic;
		pixel_cnt_ge_o	: out std_logic_vector(log2r(C_PIXEL_PR_LINE)-1 downto 0);
		line_cnt_ge_o	: out std_logic_vector(log2r(C_LINES_PR_FRAME)-1 downto 0)
	);
end entity filter;

architecture Behavioral of filter is
	
begin
	
	color_ge_o		<= color_i;
	hsync_ge_o 		<= hsync_i;
	vsync_ge_o 		<= vsync_i;
	pixel_cnt_ge_o	<= pixel_cnt_i;
	line_cnt_ge_o	<= line_cnt_i;
	
	color_gsd_o		<= color_i;
	pixel_cnt_gsd_o	<= pixel_cnt_i;
	line_cnt_gsd_o	<= line_cnt_i;
	
	
end architecture Behavioral;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.functions.all;
use work.components.all;

entity filter is
	port (
		clk : in std_logic;
		rst : in std_logic;
		
		control		: in  std_logic_vector(2 downto 0);
		
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
	
end architecture Behavioral;
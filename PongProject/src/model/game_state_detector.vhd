library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.functions.all;
use work.components.all;

entity game_state_detector is
	port (
		clk_i : in std_logic;
		
		color_gsd_i		: in  std_logic;
		pixel_cnt_gsd_i	: in  std_logic_vector(log2r(C_PIXEL_PR_LINE)-1 downto 0);
		line_cnt_gsd_i	: in  std_logic_vector(log2r(C_LINES_PR_FRAME)-1 downto 0);
		
		gs_flag			: out std_logic;
		gs_bat1_pos_y	: out std_logic_vector(log2r(C_V_LN-(C_BAT_HEIGHT-1))-1 downto 0);
		gs_bat2_pos_y	: out std_logic_vector(log2r(C_V_LN-(C_BAT_HEIGHT-1))-1 downto 0);
		gs_ball_pos_x	: out std_logic_vector(log2r(C_H_PX-(C_BALL_WIDTH-1))-1 downto 0);
		gs_ball_pos_y	: out std_logic_vector(log2r(C_V_LN-(C_BALL_HEIGHT-1))-1 downto 0);
		gs_ball_speed	: out std_logic_vector(6 downto 0);
		gs_score_bat1	: out std_logic_vector(6 downto 0);
		gs_score_bat2	: out std_logic_vector(6 downto 0)
	);
end entity game_state_detector;

architecture Behavioral of game_state_detector is
	
	signal flag_ball_pos	: std_logic;
	signal flag_bat1_pos	: std_logic;
	signal flag_bat2_pos	: std_logic;
	signal flag_ball_speed	: std_logic;
	
begin
	
end architecture Behavioral;
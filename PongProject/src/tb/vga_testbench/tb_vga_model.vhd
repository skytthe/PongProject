library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.functions.all;
use work.components.all;

entity tb_vga_model is
	port (
		clk_i 	: in  std_logic;
		
		r_i		: in  std_logic_vector(9 downto 0);
		g_i		: in  std_logic_vector(9 downto 0);
		b_i		: in  std_logic_vector(9 downto 0);
		hsync_i : in  std_logic;
		vsync_i	: in  std_logic;
		
		r_o		: out std_logic_vector(2 downto 0);
		g_o		: out std_logic_vector(2 downto 0);
		b_o		: out std_logic_vector(2 downto 0);
		hsync_o : out std_logic;
		vsync_o	: out std_logic;

		gs_flag_o		: out std_logic;
		gs_bat1_pos_y_o	: out std_logic_vector(log2r(C_V_LN-(C_BAT_HEIGHT-1))-1 downto 0);
		gs_bat2_pos_y_o	: out std_logic_vector(log2r(C_V_LN-(C_BAT_HEIGHT-1))-1 downto 0);
		gs_ball_pos_x_o	: out std_logic_vector(log2r(C_H_PX-(C_BALL_WIDTH-1))-1 downto 0);
		gs_ball_pos_y_o	: out std_logic_vector(log2r(C_V_LN-(C_BALL_HEIGHT-1))-1 downto 0);
		gs_ball_speed_o	: out std_logic_vector(6 downto 0);
		gs_score_bat1_o	: out std_logic_vector(6 downto 0);
		gs_score_bat2_o	: out std_logic_vector(6 downto 0)		
	);
end entity tb_vga_model;

architecture Behavioral of tb_vga_model is

	-- VGA sampler
	signal vga_color	: std_logic;
	signal vga_hsync	: std_logic;
	signal vga_vsync	: std_logic;
	signal vga_pxl_cnt	: std_logic_vector(log2r(C_PIXEL_PR_LINE)-1 downto 0);
	signal vga_line_cnt	: std_logic_vector(log2r(C_LINES_PR_FRAME)-1 downto 0);
	
	-- Filter
	signal fltr_color_gsd			: std_logic;
	signal fltr_fltr_pixel_cnt_gsd	: std_logic_vector(log2r(C_PIXEL_PR_LINE)-1 downto 0);
	signal fltr_line_cnt_gsd		: std_logic_vector(log2r(C_LINES_PR_FRAME)-1 downto 0);
	signal fltr_color_ge			: std_logic;
	signal fltr_hsync_ge			: std_logic;
	signal fltr_vsync_ge			: std_logic;
	signal fltr_pixel_cnt_ge		: std_logic_vector(log2r(C_PIXEL_PR_LINE)-1 downto 0);
	signal fltr_line_cnt_ge			: std_logic_vector(log2r(C_LINES_PR_FRAME)-1 downto 0);

	-- Control
	signal ctrl_filter			: std_logic_vector(2 downto 0);
	signal ctrl_graphics_engine	: std_logic_vector(2 downto 0);

begin


	VGAsampler : entity work.vga_sampler
	port map(
		clk_i       => clk_i,
		r_i         => r_i,
		g_i         => g_i,
		b_i         => b_i,
		hsync_i     => hsync_i,
		vsync_i     => vsync_i,
		color_o     => vga_color,
		hsync_o     => vga_hsync,
		vsync_o     => vga_vsync,
		pixel_cnt_o => vga_pxl_cnt,
		line_cnt_o  => vga_line_cnt
	);
	
	Filter : entity work.filter
		port map(
			clk_i           => clk_i,
			control_i       => ctrl_filter,
			color_i         => vga_color,
			hsync_i         => vga_hsync,
			vsync_i         => vga_vsync,
			pixel_cnt_i     => vga_pxl_cnt,
			line_cnt_i      => vga_line_cnt,
			color_gsd_o     => fltr_color_gsd,
			pixel_cnt_gsd_o => fltr_fltr_pixel_cnt_gsd,
			line_cnt_gsd_o  => fltr_line_cnt_gsd,
			color_ge_o      => fltr_color_ge,
			hsync_ge_o      => fltr_hsync_ge,
			vsync_ge_o      => fltr_vsync_ge,
			pixel_cnt_ge_o  => fltr_pixel_cnt_ge,
			line_cnt_ge_o   => fltr_line_cnt_ge
		);
		
	GraphicsEngine : entity work.graphics_engine
		port map(
			clk_i       => clk_i,
			control_i   => ctrl_graphics_engine,
			color_i     => fltr_color_ge,
			hsync_i     => fltr_hsync_ge,
			vsync_i     => fltr_vsync_ge,
			pixel_cnt_i => fltr_pixel_cnt_ge,
			line_cnt_i  => fltr_line_cnt_ge,
			r_o         => r_o,
			g_o         => g_o,
			b_o         => b_o,
			hsync_o     => hsync_o,
			vsync_o     => vsync_o
		);
		
		GameStateDetector : entity work.game_state_detector
			port map(
				clk_i           => clk_i,
				color_gsd_i     => fltr_color_gsd,
				pixel_cnt_gsd_i => fltr_fltr_pixel_cnt_gsd,
				line_cnt_gsd_i  => fltr_line_cnt_gsd,
				gs_flag         => gs_flag_o,
				gs_bat1_pos_y   => gs_bat1_pos_y_o,
				gs_bat2_pos_y   => gs_bat2_pos_y_o,
				gs_ball_pos_x   => gs_ball_pos_x_o,
				gs_ball_pos_y   => gs_ball_pos_y_o,
				gs_ball_speed   => gs_ball_speed_o,
				gs_score_bat1   => gs_score_bat1_o,
				gs_score_bat2   => gs_score_bat2_o
			);
	
end architecture Behavioral;
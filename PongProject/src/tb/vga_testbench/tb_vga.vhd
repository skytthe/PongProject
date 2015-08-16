library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.functions.all;
use work.components.all;

--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_vga is
end entity tb_vga;

architecture Behavioral of tb_vga is
	-- Clocks
	signal clk_40M          : std_logic := '0';

	-- routing signals
	signal r_i,b_i,g_i 		: std_logic_vector(9 downto 0);
	signal hsync_i,vsync_i	: std_logic;
	signal r_o,b_o,g_o 		: std_logic_vector(2 downto 0);
	signal hsync_o,vsync_o	: std_logic;
	
	signal gs_flag			: std_logic;
	signal gs_bat1_pos_y	: std_logic_vector(log2r(C_V_LN-(C_BAT_HEIGHT-1))-1 downto 0);
	signal gs_bat2_pos_y	: std_logic_vector(log2r(C_V_LN-(C_BAT_HEIGHT-1))-1 downto 0);
	signal gs_ball_pos_x	: std_logic_vector(log2r(C_H_PX-(C_BALL_WIDTH-1))-1 downto 0);
	signal gs_ball_pos_y	: std_logic_vector(log2r(C_V_LN-(C_BALL_HEIGHT-1))-1 downto 0);
	signal gs_ball_speed	: std_logic_vector(6 downto 0);
	signal gs_score_bat1	: std_logic_vector(6 downto 0);
	signal gs_score_bat2	: std_logic_vector(6 downto 0);

begin

	-- Clock process definitions
	clk_40M_process : process
	begin
		clk_40M <= '0';
		wait for C_CLK_PRD_NS / 2;
		clk_40M <= '1';
		wait for C_CLK_PRD_NS / 2;
	end process;

	-- Component declarations
	VGAgenerator : entity work.tb_vga_generator
		port map(
			r_o     => r_i,
			g_o     => g_i,
			b_o     => b_i,
			hsync_o => hsync_i,
			vsync_o => vsync_i
		);
		
	PongModel : entity work.tb_vga_model
		port map(
			clk_i           => clk_40M,
			r_i             => r_i,
			g_i             => g_i,
			b_i             => b_i,
			hsync_i         => hsync_i,
			vsync_i         => vsync_i,
			r_o             => r_o,
			g_o             => g_o,
			b_o             => b_o,
			hsync_o         => hsync_o,
			vsync_o         => vsync_o,
			gs_flag_o       => gs_flag,
			gs_bat1_pos_y_o => gs_bat1_pos_y,
			gs_bat2_pos_y_o => gs_bat2_pos_y,
			gs_ball_pos_x_o => gs_ball_pos_x,
			gs_ball_pos_y_o => gs_ball_pos_y,
			gs_ball_speed_o => gs_ball_speed,
			gs_score_bat1_o => gs_score_bat1,
			gs_score_bat2_o => gs_score_bat2
		);
	
	VGAsampler : entity work.tb_vga_sampler
		port map(
			r_i     => r_o,
			g_i     => g_o,
			b_i     => b_o,
			hsync_i => hsync_o,
			vsync_i => vsync_o
		);

--	-- Stimulus process
--	stim_proc : process
--
--	begin
--
--	end process;

end architecture Behavioral;
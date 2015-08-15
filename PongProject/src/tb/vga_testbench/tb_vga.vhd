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
			clk_i   => clk_40M,
			r_i     => r_i,
			g_i     => g_i,
			b_i     => b_i,
			hsync_i => hsync_i,
			vsync_i => vsync_i,
			r_o     => r_o,
			g_o     => g_o,
			b_o     => b_o,
			hsync_o => hsync_o,
			vsync_o => vsync_o
		);
	
	VGAsampler : entity work.tb_vga_sampler
		port map(
			r_i     => r_o,
			g_i     => g_o,
			b_i     => b_o,
			hsync_i => hsync_o,
			vsync_i => vsync_o
		);

	-- Stimulus process
	stim_proc : process

	begin

	end process;

end architecture Behavioral;

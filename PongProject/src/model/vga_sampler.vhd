library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.functions.all;
use work.components.all;

entity vga_sampler is
	port (
		clk_i		: in std_logic;
		
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
	
	signal hsync_delayed	: std_logic;
	signal vsync_delayed	: std_logic;
	
	signal hsync_f_edge	: std_logic;
	signal vsync_f_edge	: std_logic;
	
	signal pixel_cnt_reg : unsigned(log2r(C_PIXEL_PR_LINE)-1 downto 0) := to_unsigned(C_PIXEL_PR_LINE-1	,log2r(C_PIXEL_PR_LINE));
	signal pixel_cnt_nxt : unsigned(log2r(C_PIXEL_PR_LINE)-1 downto 0);
	
	signal line_cnt_reg : unsigned(log2r(C_LINES_PR_FRAME)-1 downto 0) := to_unsigned(C_LINES_PR_FRAME-1,log2r(C_LINES_PR_FRAME));
	signal line_cnt_nxt : unsigned(log2r(C_LINES_PR_FRAME)-1 downto 0);	
	
	
begin
	-- down sample vga color data to black/white
	process(clk_i)
	begin
		if rising_edge(clk_i) then
			color_o <= r_i(C_ADC_WIDTH-1);
		end if;
	end process;
	
	-- delay sync signals
	sync_delay : entity work.delay_chain_SRLC16E
	generic map(
		width => 2
	)
	port map(
		clk_i => clk_i,
		delay => std_logic_vector(to_unsigned(C_ADC_DELAY-1,4)),
		data_i(0) => hsync_i,
		data_i(1) => vsync_i,
		data_o(0) => hsync_delayed,
		data_o(1) => vsync_delayed
	);
	process(clk_i)
	begin
		if rising_edge(clk_i) then
			hsync_o <= hsync_delayed;
			vsync_o <= vsync_delayed;
		end if;
	end process;
	
	
	-- sync edge detectors
	hsync_edge_detector : entity work.edge_detector
		port map(
			clk_i    => clk_i,
			signal_i => hsync_delayed,
			edge_o   => hsync_f_edge
		);
	vsync_edge_detector : entity work.edge_detector
		port map(
			clk_i    => clk_i,
			signal_i => vsync_delayed,
			edge_o   => vsync_f_edge
		);
		
	-- HS and VS counters
	process(clk_i)
	begin
		if rising_edge(clk_i) then		
			pixel_cnt_reg <= pixel_cnt_nxt;
			line_cnt_reg <= line_cnt_nxt;
		end if;
	end process;
	pixel_cnt_o	<= std_logic_vector(pixel_cnt_reg);
	line_cnt_o	<= std_logic_vector(line_cnt_reg);
	
	pixel_cnt_nxt <=	(others=>'0')	when hsync_f_edge = '1' else
							pixel_cnt_reg+1;
					 
	line_cnt_nxt <=	(others=>'0')	when vsync_f_edge = '1' else
							line_cnt_reg+1	when hsync_f_edge = '1' else
							line_cnt_reg;


end architecture Behavioral;
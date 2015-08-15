library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.functions.all;
use work.components.all;

entity tb_vga_generator is
	generic(
		G_PXL_CLK_PRD	: time    := 25 ns;
		G_COLOR_WIDTH	: integer := 10	
	);
	port (
		r_o		: out std_logic_vector(G_COLOR_WIDTH-1 downto 0);
		g_o		: out std_logic_vector(G_COLOR_WIDTH-1 downto 0);
		b_o		: out std_logic_vector(G_COLOR_WIDTH-1 downto 0);
		hsync_o : out std_logic;
		vsync_o	: out std_logic		
	);
end entity tb_vga_generator;

architecture Behavioral of tb_vga_generator is

	signal pxl_clk			: std_logic := '0';
	
	signal pixel_cnt_comp	: std_logic_vector(log2r(C_PIXEL_PR_LINE)-1 downto 0);
	signal line_cnt_comp	: std_logic_vector(log2r(C_LINES_PR_FRAME)-1 downto 0);
	
	---
	
	signal pixel_cnt_reg : unsigned(log2r(C_PIXEL_PR_LINE)-1 downto 0) := to_unsigned(C_PIXEL_PR_LINE-1, log2r(C_PIXEL_PR_LINE));
	signal pixel_cnt_nxt : unsigned(log2r(C_PIXEL_PR_LINE)-1 downto 0);
	
	signal line_cnt_reg : unsigned(log2r(C_LINES_PR_FRAME)-1 downto 0) := to_unsigned(C_LINES_PR_FRAME-1, log2r(C_LINES_PR_FRAME));
	signal line_cnt_nxt : unsigned(log2r(C_LINES_PR_FRAME)-1 downto 0);	

	signal mem_cnt_reg : unsigned(log2r(C_H_PX*C_V_LN)-1 downto 0) := (others=>'0');
	signal mem_cnt_nxt : unsigned(log2r(C_H_PX*C_V_LN)-1 downto 0);
	signal mem_data	: std_logic := '0';
	
	signal r : std_logic_vector(C_ADC_WIDTH-1 downto 0);
	signal g : std_logic_vector(C_ADC_WIDTH-1 downto 0);
	signal b : std_logic_vector(C_ADC_WIDTH-1 downto 0);
	
	type slv_vector is array(G_COLOR_WIDTH-1 downto 0) of std_logic_vector(C_ADC_WIDTH-1 downto 0);
	signal r_reg : slv_vector;
	signal g_reg : slv_vector;
	signal b_reg : slv_vector;
	
begin
	
	-- pixel clock generator
	process
	begin
		wait for G_PXL_CLK_PRD*10;
		loop
			pxl_clk <= '0';
			wait for G_PXL_CLK_PRD/2;
			pxl_clk <= '1';
			wait for G_PXL_CLK_PRD/2;
		end loop;
	end process;
	
	VGAgenerator : entity work.vga_generator
		port map(
			clk_i     => pxl_clk,
			rst_i     => '0',
			hsync_o   => hsync_o,
			vsync_o   => vsync_o,
			pixel_cnt => pixel_cnt_comp,
			line_cnt  => line_cnt_comp
		);
	
	-- adc delay simulator
	process(pxl_clk)
	begin
		if rising_edge(pxl_clk) then
			r_reg <= r_reg(G_COLOR_WIDTH-2 downto 0) & r;
			g_reg <= g_reg(G_COLOR_WIDTH-2 downto 0) & g;
			b_reg <= b_reg(G_COLOR_WIDTH-2 downto 0) & b;
		end if;
	end process;
	r_o <= r;
	g_o <= g;
	b_o <= b;
	
	
	
	
	-- HS and VS generator
	process(pxl_clk)
	begin
		if rising_edge(pxl_clk) then		
			pixel_cnt_reg <= pixel_cnt_nxt;
			line_cnt_reg <= line_cnt_nxt;
		end if;
	end process;
	
	
	pixel_cnt_nxt <=	pixel_cnt_reg+1 when pixel_cnt_reg<C_PIXEL_PR_LINE-1 
												 else 
							(others=>'0');

	line_cnt_nxt  <=	line_cnt_reg+1 when	pixel_cnt_reg=C_PIXEL_PR_LINE-1 and 
														line_cnt_reg<C_LINES_PR_FRAME-1 
												else 
							(others=>'0')  when 	pixel_cnt_reg=C_PIXEL_PR_LINE-1 
												else
							line_cnt_reg;
	
	hsync_o <= '0' when pixel_cnt_reg < C_H_pulse else '1';
	vsync_o <= '0' when line_cnt_reg  < C_V_Pulse else '1';


	-- pixel color generator
	r <=	(others=>'1')	when	(pixel_cnt_reg > (C_HS_OFFSET-1)	and 
											 pixel_cnt_reg < (C_HS_OFFSET2)	and 
											 line_cnt_reg  > (C_VS_OFFSET-1)	and 
											 line_cnt_reg  < (C_VS_OFFSET2))	and 
											 mem_data = '1'
									else
				(others=>'0');
	g <=	(others=>'1')	when	(pixel_cnt_reg > (C_HS_OFFSET-1)	and 
											 pixel_cnt_reg < (C_HS_OFFSET2)	and 
											 line_cnt_reg  > (C_VS_OFFSET-1)	and 
											 line_cnt_reg  < (C_VS_OFFSET2))	and 
											 mem_data = '1'
									else
				(others=>'0');
	b <=	(others=>'1')	when	(pixel_cnt_reg > (C_HS_OFFSET-1)	and 
											 pixel_cnt_reg < (C_HS_OFFSET2)	and 
											 line_cnt_reg  > (C_VS_OFFSET-1)	and 
											 line_cnt_reg  < (C_VS_OFFSET2))	and 
											 mem_data = '1'
									else
				(others=>'0');
			
	-- memory adress generator
	process(pxl_clk)
	begin
		if rising_edge(pxl_clk) then		
			mem_cnt_reg <= mem_cnt_nxt;
		end if;
	end process;

	mem_cnt_nxt <=	mem_cnt_reg+1 	when	(pixel_cnt_reg > (C_HS_OFFSET-1) and 
													 pixel_cnt_reg < (C_HS_OFFSET2)  and 
													 line_cnt_reg  > (C_VS_OFFSET-1) and 
													 line_cnt_reg  < (C_VS_OFFSET2-1))
											else 
						mem_cnt_reg+1 	when	(pixel_cnt_reg > (C_HS_OFFSET-1) and 
													 pixel_cnt_reg < (C_HS_OFFSET2-1)and 
													 line_cnt_reg  > (C_VS_OFFSET-1) and 
													 line_cnt_reg  < (C_VS_OFFSET2))
											else 
						mem_cnt_reg;
	
	pong_image_rom : entity work.tb_image_rom
	port map(
		clk_i  => pxl_clk,
		adr_i  => std_logic_vector(mem_cnt_nxt),
		data_o => mem_data
	);
	
end architecture Behavioral;


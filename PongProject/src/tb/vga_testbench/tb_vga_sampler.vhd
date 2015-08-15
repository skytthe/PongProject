library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.textio.all;
use ieee.std_logic_textio.all;

use work.constants.all;
use work.functions.all;
use work.components.all;

entity tb_vga_sampler is
	generic(
		G_FILE_NAME		: string	:= "../output/data_output.txt";
--		G_CLK_FREQ_HZ	: integer := 40000000;
		G_PXL_CLK_PRD	: time    := 25.001 ns
	);
	port (
		r_i		: in std_logic_vector(2 downto 0);
		g_i		: in std_logic_vector(2 downto 0);
		b_i		: in std_logic_vector(2 downto 0);
		hsync_i : in std_logic;
		vsync_i	: in std_logic
	);
end entity tb_vga_sampler;

architecture Behavioral of tb_vga_sampler is

	signal pxl_clk : std_logic;

	signal pixel_cnt_reg : unsigned(log2r(C_PIXEL_PR_LINE)-1 downto 0) := to_unsigned(C_PIXEL_PR_LINE-1	,log2r(C_PIXEL_PR_LINE));
	signal pixel_cnt_nxt : unsigned(log2r(C_PIXEL_PR_LINE)-1 downto 0);
	
	signal line_cnt_reg : unsigned(log2r(C_LINES_PR_FRAME)-1 downto 0) := to_unsigned(C_LINES_PR_FRAME-1,log2r(C_LINES_PR_FRAME));
	signal line_cnt_nxt : unsigned(log2r(C_LINES_PR_FRAME)-1 downto 0);	

	-- data delay
	signal r_reg : std_logic_vector(r_i'length-1 downto 0);
	signal g_reg : std_logic_vector(g_i'length-1 downto 0);
	signal b_reg : std_logic_vector(b_i'length-1 downto 0);
	
	-- falling_egde detector
	signal hsync_f_egde : std_logic;
	signal hsync_f_egde_reg : std_logic;
	signal vsync_f_egde : std_logic;
	signal vsync_f_egde_reg : std_logic;
	
	file output_file : text open write_mode is G_FILE_NAME;

begin

	-- pixel sampler clock generator
	process
	begin
		wait for G_PXL_CLK_PRD/2;
		loop
			pxl_clk <= '0';
			wait for G_PXL_CLK_PRD/2;
			pxl_clk <= '1';
			wait for G_PXL_CLK_PRD/2;
		end loop;
	end process;
	
	-- data delay register
	process(pxl_clk)
	begin
		if rising_edge(pxl_clk) then
			r_reg <= r_i;
			g_reg <= g_i;
			b_reg <= b_i;
		end if;
	end process;

	--hsync falling_egde detector
	process(pxl_clk)
	begin
		if rising_edge(pxl_clk) then
			hsync_f_egde_reg <= hsync_i;
		end if;
	end process;
	hsync_f_egde <= (not hsync_i) and hsync_f_egde_reg;
	
	--vsync falling_egde detector
		process(pxl_clk)
	begin
		if rising_edge(pxl_clk) then
			vsync_f_egde_reg <= vsync_i;
		end if;
	end process;
	vsync_f_egde <= (not vsync_i) and vsync_f_egde_reg;
	
	
		-- HS and VS counters
	process(pxl_clk)
	begin
		if rising_edge(pxl_clk) then		
			pixel_cnt_reg <= pixel_cnt_nxt;
			line_cnt_reg <= line_cnt_nxt;
		end if;
	end process;
	
	pixel_cnt_nxt <= (others=>'0')	when hsync_f_egde = '1'
												else
							pixel_cnt_reg+1;
					 
	line_cnt_nxt <=  (others=>'0')	when vsync_f_egde = '1'
												else
							line_cnt_reg+1	when hsync_f_egde = '1'
												else
							line_cnt_reg;
	
	-- export visable pixels to txt file
	process(pxl_clk)
		variable l	: line;
	begin
		if rising_edge(pxl_clk) then
			if (pixel_cnt_reg > (C_HS_OFFSET-1)	and pixel_cnt_reg < (C_HS_OFFSET2)	and 
				 line_cnt_reg  > (C_VS_OFFSET-1)	and line_cnt_reg  < (C_VS_OFFSET2)) then
				write(l,r_reg);
				write(l,g_reg);
				write(l,b_reg);
				writeline(output_file,l);			
			end if;
		end if;
	end process;

end architecture Behavioral;

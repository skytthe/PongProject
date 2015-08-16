library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.constants.all;
use work.functions.all;
use work.components.all;

entity vga_generator is
	port (
		clk_i			: in  std_logic;
		rst_i			: in  std_logic;
		hsync_o 		: out std_logic := '1';
		vsync_o 		: out std_logic := '1';
		pixel_cnt	: out std_logic_vector(log2r(C_PIXEL_PR_LINE)-1 downto 0)  := (others=>'0');
		line_cnt		: out std_logic_vector(log2r(C_LINES_PR_FRAME)-1 downto 0) := (others=>'0')
	);
end entity vga_generator;

architecture Behavioral of vga_generator is
	signal pixel_cnt_reg : unsigned(log2r(C_PIXEL_PR_LINE)-1 downto 0) := to_unsigned(C_PIXEL_PR_LINE-1	,log2r(C_PIXEL_PR_LINE));
	signal pixel_cnt_nxt : unsigned(log2r(C_PIXEL_PR_LINE)-1 downto 0);
	
	signal line_cnt_reg : unsigned(log2r(C_LINES_PR_FRAME)-1 downto 0) := to_unsigned(C_LINES_PR_FRAME-1	,log2r(C_LINES_PR_FRAME));
	signal line_cnt_nxt : unsigned(log2r(C_LINES_PR_FRAME)-1 downto 0);	
begin
	
	-- HS and VS generator
	process(clk_i)
	begin
		if rising_edge(clk_i) then		
			pixel_cnt_reg <= pixel_cnt_nxt;
			line_cnt_reg <= line_cnt_nxt;
		end if;
	end process;
	
	
	pixel_cnt_nxt <=	(others=>'0')		when rst_i = '1' else
							pixel_cnt_reg+1 	when pixel_cnt_reg<C_PIXEL_PR_LINE-1 else 
							(others=>'0');

	line_cnt_nxt  <=	(others=>'0')		when rst_i = '1' else
							line_cnt_reg+1		when pixel_cnt_reg=C_PIXEL_PR_LINE-1 and 
													line_cnt_reg<C_LINES_PR_FRAME-1 else 
							(others=>'0')		when pixel_cnt_reg=C_PIXEL_PR_LINE-1 else
							line_cnt_reg;
	
	hsync_o <= '1' when rst_i = '1' else '0' when pixel_cnt_reg < C_H_pulse else '1';
	vsync_o <= '1' when rst_i = '1' else '0' when line_cnt_reg  < C_V_Pulse else '1';
	pixel_cnt <= std_logic_vector(pixel_cnt_reg);
	line_cnt  <= std_logic_vector(line_cnt_reg);
	
end architecture Behavioral;
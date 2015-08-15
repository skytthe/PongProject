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
		vsync_o	: out std_logic		
	);
end entity tb_vga_model;

architecture Behavioral of tb_vga_model is
	
begin

	model : process (clk_i) is
	begin
		if rising_edge(clk_i) then
			r_o <= r_i(9 downto 7);
			g_o <= g_i(9 downto 7);
			b_o <= b_i(9 downto 7);
			hsync_o <= hsync_i;
			vsync_o <= vsync_i;
		end if;
	end process model;
	
	
	
end architecture Behavioral;

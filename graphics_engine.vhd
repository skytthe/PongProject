library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity graphics_engine is
	generic(
		C_CLK_FREQ_HZ     : integer := 40000000
	);
	port(
		--
		clk_i	 			: in  std_logic;
		--
		vga_hsync_i		: in  std_logic;
		vga_vsync_i		: in  std_logic;
		vga_data_i		: in  std_logic;
		--
		vga_hsync_o 	: out std_logic;
		vga_vsync_o		: out std_logic;
		vga_r_o			: out std_logic_vector(2 downto 0);
		vga_g_o			: out std_logic_vector(2 downto 0);
		vga_b_o			: out std_logic_vector(2 downto 0)				
	);
end graphics_engine;

architecture Behavioral of graphics_engine is

begin

	name : process (clk_i) is
	begin
		if rising_edge(clk_i) then
			vga_hsync_o <= vga_hsync_i;
			vga_vsync_o <= vga_vsync_i;
			vga_r_o  <= vga_data_i & vga_data_i & vga_data_i;
			vga_g_o  <= vga_data_i & vga_data_i & vga_data_i;
			vga_b_o  <= vga_data_i & vga_data_i & vga_data_i;
		end if;
	end process name;
	
end Behavioral;


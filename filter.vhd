library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity filter is
	generic(
		C_CLK_FREQ_HZ     : integer := 40000000
	);
	port(
		clk_i 			: in  std_logic;
		--
		vga_hsync_i		: in  std_logic;
		vga_vsync_i		: in  std_logic;
		vga_data_i		: in  std_logic;
		--
		vga_hsync_o		: out std_logic;
		vga_vsync_o		: out std_logic;
		vga_data_o		: out std_logic
	);
end filter;

architecture Behavioral of filter is

begin

	name : process (clk_i) is
	begin
		if rising_edge(clk_i) then
			vga_hsync_o <= vga_hsync_i;
			vga_vsync_o <= vga_vsync_i;
			vga_data_o  <= vga_data_i;
		end if;
	end process name;
	
end Behavioral;


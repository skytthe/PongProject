library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity clock_resources is
	port(
		clk_200M_i			: in  std_logic;
		clk_40M_o			: out	std_logic;
		adc_40M_vga_r_o	: out	std_logic
	);
end clock_resources;

architecture Behavioral of clock_resources is
	signal clk_40M			: std_logic;
	signal clk_40M_180	: std_logic;
begin

	clk_scaling : entity work.dcm
	port map(	
		clk_200M_i 		=> clk_200M_i,
		clk_40M_o 		=> clk_40M,
		clk_40M_180_o 	=> clk_40M_180
	);	
	
	clk_40M_o 		<= clk_40M;

	ODDR2_clk_adc_r : ODDR2
	generic map(
		DDR_ALIGNMENT 	=> "NONE", 	
		INIT 				=> '0', 		
		SRTYPE 			=> "SYNC"
		)
	port map (
		Q  => adc_40M_vga_r_o,	
		C0 => clk_40M, 		
		C1 => clk_40M_180, 			
		CE => '1',  			
		D0 => '1',   		
		D1 => '0',   			
		R  => '0',    		
		S  => '0'
	);

end Behavioral;


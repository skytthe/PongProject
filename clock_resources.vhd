library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Library UNISIM;
use UNISIM.vcomponents.all;

entity clock_resources is
	port(
		clk_200M_i			: in  std_logic;
		clk_40M_o			: out	std_logic;
		clk_40M_180_o		: out	std_logic;
		adc_40M_vga_r_o	: out	std_logic;
		adc_40M_vga_g_o	: out	std_logic;
		adc_40M_vga_b_o	: out	std_logic
	);
end clock_resources;

architecture Behavioral of clock_resources is
	signal clk_40M			: std_logic;
	signal clk_40M_180	: std_logic;
begin

	clk_scaling : entity work.dcm
	port map(	
		-- Clock in ports
		clk_200M_i 		=> clk_200M_i,
		-- Clock out ports
		clk_40M 			=> clk_40M,
		clk_40M_180 	=> clk_40M_180
	);	
	
	clk_40M_o 		<= clk_40M;
	clk_40M_180_o	<= clk_40M_180;

	ODDR2_clk_adc_r : ODDR2
	generic map(
		DDR_ALIGNMENT 	=> "NONE", 	
		INIT 				=> '0', 		
		SRTYPE 			=> "SYNC" 	-- Specifies "SYNC" or "ASYNC" set/reset
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
	ODDR2_clk_adc_g : ODDR2
	generic map(
		DDR_ALIGNMENT 	=> "NONE", 	
		INIT 				=> '0', 		
		SRTYPE 			=> "SYNC" 	-- Specifies "SYNC" or "ASYNC" set/reset
		)
	port map (
		Q  => adc_40M_vga_g_o,	
		C0 => clk_40M, 		
		C1 => clk_40M_180, 			
		CE => '1',  			
		D0 => '1',   		
		D1 => '0',   			
		R  => '0',    		
		S  => '0'
	);
	ODDR2_clk_adc_b : ODDR2
	generic map(
		DDR_ALIGNMENT 	=> "NONE", 	
		INIT 				=> '0', 		
		SRTYPE 			=> "SYNC" 	-- Specifies "SYNC" or "ASYNC" set/reset
		)
	port map (
		Q  => adc_40M_vga_b_o,	
		C0 => clk_40M, 		
		C1 => clk_40M_180, 			
		CE => '1',  			
		D0 => '1',   		
		D1 => '0',   			
		R  => '0',    		
		S  => '0'
	);end Behavioral;


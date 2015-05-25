library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PS2_interface is
	generic(
		C_CLK_FREQ_HZ        : integer := 40000000
	);
	port ( 
		clk_100M_i	: in  	std_logic;
		
		ps2_clk_io	: inout  std_logic;
		ps2_data_io	: inout  std_logic;
		
		up_o 			: out 	std_logic;
		stop_o		: out 	std_logic;
		down_o		: out 	std_logic
	);
end PS2_interface;

architecture Behavioral of PS2_interface is

	signal rx_data : std_logic_vector(7 downto 0);
	signal read : std_logic;

begin

	-- component instantiation (direct module reference style)
	ps2interface_inst0 : entity work.ps2interface 
		port map(
			clk 		=> clk_100M_i,
			rst 		=> '0',
			
			ps2_clk  => ps2_clk_io,
			ps2_data => ps2_data_io,
						
			tx_data 	=> "00000000",
			write 	=> '0',
			
			rx_data 	=> rx_data,
			read 		=> read,
			busy 		=> open,
			err 		=> open
		);

	-- component instantiation (direct module reference style)
	ps2_rx_fsm_inst0 : entity work.ps2_rx_fsm 
		port map(
			clk_i 		=> clk_100M_i,
			
			rx_data_i	=> rx_data,
			read_i		=> read,
			
			up_o 			=> up_o,
			stop_o		=> stop_o,
			down_o		=> down_o
		);

end Behavioral;


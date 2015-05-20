library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
	port(
		-- onboard clock input
		clk_200M_i 				: in  	std_logic;

		-- onboard USB-UART interface (FT232H)
--		ft232h_rst_o			: out 	std_logic;
--		ft232h_acbus7_i 		: in  	std_logic;
--		ft232h_rs232_rx_i		: in  	std_logic;
--		ft232h_rs232_tx_o 	: out		std_logic;
		
		-- onboard leds output
		led_o 					: out  	std_logic_vector (6 downto 0);
		
		-- Baseboard 4-bit dip-switch input
		dip_sw_i					: in		std_logic_vector (3 downto 0);
		
		-- Baseboard Digilent PMOD connector
--		p7_io						: inout	std_logic_vector(7 downto 0);
--		p8_io						: inout	std_logic_vector(7 downto 0);
		
		-- J7-connector: Digital (PS/2, 8-bit dip-switch, 2x push-buttons) expantion board io
		j7_dip_sw_i 			: in  	std_logic_vector (7 downto 0);
		j7_btn_i 				: in  	std_logic_vector (1 downto 0)
--		j7_ps2_clk_io			: inout  std_logic;
--		j7_ps2_data_io			: inout  std_logic;
		
		-- J8-connector: VGA-output expantion board
--		j8_vga_hsync_o			: out		std_logic;
--		j8_vga_vsync_o			: out		std_logic;
--		j8_vga_r_o				: out		std_logic_vector (2 downto 0);
--		j8_vga_g_o				: out		std_logic_vector (2 downto 0);
--		j8_vga_b_o				: out		std_logic_vector (2 downto 0);
		
		-- FX2-connector: VGA ADC input board
--		fx2_vga_hsync_i		: in		std_logic;
--		fx2_vga_vsync_i		: in		std_logic;
		
--		fx2_vga_r_clk_o		: out		std_logic;
--		fx2_vga_r_i				: in 		std_logic_vector (9 downto 0);

--		fx2_vga_g_clk_o		: out		std_logic;
--		fx2_vga_g_i				: in 		std_logic_vector (9 downto 0);

--		fx2_vga_b_clk_o		: out		std_logic;
--		fx2_vga_b_i				: in 		std_logic_vector (9 downto 0)	
	);
end main;

architecture Behavioral of main is
	---------------------------------
	-- Components			------------
	---------------------------------
	component dcm
	port(
		-- Clock in ports
		clk_200M_i		: in	std_logic;
		-- Clock out ports
		clk_40M  		: out	std_logic;
		clk_40M_180		: out	std_logic
	);
	end component;
	---------------------------------


	------------------------------------------------------
	-- Signals											------------
	------------------------------------------------------
	-- Clocks											
	signal clk_40M 		: std_logic;
	signal clk_40M_180	: std_logic;
	-- mixed												
	signal debug_wire 	: std_logic_vector(6 downto 0);
	------------------------------------------------------

begin

	dcm_40M : dcm
	port map(	
		-- Clock in ports
		clk_200M_i 	=> clk_200M_i,
		-- Clock out ports
		clk_40M 		=> clk_40M,
		clk_40M_180 => clk_40M_180
	);	
	
	debug : entity work.debug
	generic map(
		C_CLK_FREQ_HZ     => 40000000
	)
	port map(
		clk_i 	=> clk_40M,
		debug_i 	=> debug_wire,
		led_o		=> led_o
	);
	
	user_input : entity work.user_input
	generic map(
		C_CLK_FREQ_HZ     => 40000000
	)
	port map(
		clk_i 		=> clk_40M,
		dip4_i		=> dip_sw_i,
		dip8_i		=> j7_dip_sw_i,
		btn_i 		=> j7_btn_i,
		control_o	=> debug_wire
	);

end Behavioral;


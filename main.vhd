library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Library UNISIM;
use UNISIM.vcomponents.all;

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
		j7_btn_i 				: in  	std_logic_vector (1 downto 0);
		j7_ps2_clk_io			: inout  std_logic;
		j7_ps2_data_io			: inout  std_logic;
		
		-- J8-connector: VGA-output expantion board
		j8_vga_hsync_o			: out		std_logic;
		j8_vga_vsync_o			: out		std_logic;
		j8_vga_r_o				: out		std_logic_vector (2 downto 0);
		j8_vga_g_o				: out		std_logic_vector (2 downto 0);
		j8_vga_b_o				: out		std_logic_vector (2 downto 0);
		
		-- FX2-connector: VGA ADC input board
		fx2_vga_hsync_i		: in		std_logic;
		fx2_vga_vsync_i		: in		std_logic;
		
		fx2_adc_r_clk_o		: out		std_logic;
		fx2_adc_r_msb_i		: in 		std_logic;

		fx2_adc_g_clk_o		: out		std_logic;
		fx2_adc_g_msb_i		: in 		std_logic;

		fx2_adc_b_clk_o		: out		std_logic;
		fx2_adc_b_msb_i		: in 		std_logic	
	);
end main;

architecture Behavioral of main is

	------------------------------------------------------
	-- Signals							 		------------
	------------------------------------------------------
	-- Clocks									  		
	signal clk_40M 		: std_logic;
	signal clk_40M_180	: std_logic;
	-- ADC clocks
	signal adc_40M_vga_r	: std_logic;
	signal adc_40M_vga_g	: std_logic;
	signal adc_40M_vga_b	: std_logic;
	-- VGA busses		[hsync,vsync,data] MSB
	signal bus_vga_sampler	: std_logic_vector(2 downto 0);
	signal bus_vga_filter	: std_logic_vector(2 downto 0);
	------------------------------------------------------

	-- User Input signals
	signal ui_dip4_db      	: std_logic_vector(3 downto 0);
	signal ui_dip4_db_tick 	: std_logic_vector(3 downto 0);
	signal ui_dip8_db      	: std_logic_vector(7 downto 0);
	signal ui_dip8_db_tick 	: std_logic_vector(7 downto 0);
	signal ui_btn_db       	: std_logic_vector(1 downto 0);
	signal ui_btn_db_tick  	: std_logic_vector(1 downto 0);
	signal ui_ps2_key_down 	: std_logic;
	signal ui_ps2_key_up   	: std_logic;
	
	-- Game Controller
	signal gc_commads			: std_logic_vector(2 downto 0);
	
	-- ChipScope
	signal cs_vio_up			: std_logic;
	signal cs_vio_down		: std_logic;
	signal cs_vio_ena 		: std_logic;
	
	-- System Settings - control signals
	signal ctrl_led			: std_logic_vector(3 downto 0);
	signal ctrl_gc_ps2_ena	: std_logic;

begin

	clk_resources : entity work.clock_resources
	port map(
		clk_200M_i 			=> clk_200M_i,
		clk_40M_o			=> clk_40M,
		clk_40M_180_o		=> clk_40M_180,
		adc_40M_vga_r_o	=> adc_40M_vga_r,
		adc_40M_vga_g_o	=> adc_40M_vga_g,
		adc_40M_vga_b_o	=> adc_40M_vga_b
	);
	
	
	fx2_adc_r_clk_o <= adc_40M_vga_r;
	fx2_adc_g_clk_o <= adc_40M_vga_g;
	fx2_adc_b_clk_o <= adc_40M_vga_b;
	
	vga_sampler : entity work.VGA_sampler
	generic map(
		C_CLK_FREQ_HZ  => 40000000,
		delay 			=> 5
	)
	port map(
		clk_i       => clk_40M,
		control_i 	=> dip_sw_i,
	   vga_hsync_i => fx2_vga_hsync_i,
		vga_vsync_i => fx2_vga_vsync_i,
		vga_r_clk_o => open,
		vga_r_i     => fx2_adc_r_msb_i,
		vga_g_clk_o => open,
		vga_g_i     => fx2_adc_g_msb_i,
		vga_b_clk_o => open,
		vga_b_i     => fx2_adc_b_msb_i,
		vga_hsync_o => bus_vga_sampler(0),
		vga_vsync_o => bus_vga_sampler(1),
		vga_data_o	=> bus_vga_sampler(2)
	);
	
	filter: entity work.filter
	generic map(
		C_CLK_FREQ_HZ     => 40000000
	)
	port map(
		clk_i       => clk_40M,
		vga_hsync_i => bus_vga_sampler(0),
		vga_vsync_i => bus_vga_sampler(1),
		vga_data_i  => bus_vga_sampler(2),
		vga_hsync_o => bus_vga_filter(0),
		vga_vsync_o => bus_vga_filter(1),
		vga_data_o  => bus_vga_filter(2)
	);
	
	graphics_engine : entity work.graphics_engine
	generic map(
		C_CLK_FREQ_HZ     => 40000000
	)
	port map(
		clk_i       => clk_40M,
	    vga_hsync_i => bus_vga_filter(0),
	    vga_vsync_i => bus_vga_filter(1),
	    vga_data_i  => bus_vga_filter(2),
	    vga_hsync_o => j8_vga_hsync_o,
	    vga_vsync_o => j8_vga_vsync_o,
	    vga_r_o     => j8_vga_r_o,
	    vga_g_o     => j8_vga_g_o,
	    vga_b_o     => j8_vga_b_o
	);
	
	
	
	
	user_input : entity work.user_input
	generic map(
		C_CLK_FREQ_HZ     => 40000000
	)
	port map(
		clk_i 		=> clk_40M,
		dip4_i		=> dip_sw_i,
		dip8_i		=> j7_dip_sw_i,
		btn_i 		=> not j7_btn_i,
		ps2_clk_io	=> j7_ps2_clk_io,
		ps2_data_io	=> j7_ps2_data_io,
		dip4_db_o      => ui_dip4_db,
		dip4_db_tick_o => ui_dip4_db_tick,
		dip8_db_o      => ui_dip8_db,
		dip8_db_tick_o => ui_dip8_db_tick,
		btn_db_o       => ui_btn_db,
		btn_db_tick_o  => ui_btn_db_tick,
		ps2_key_down_o => ui_ps2_key_down,
		ps2_key_up_o   => ui_ps2_key_up
	);
	
	cs : entity work.chipscope
	port map(
		clk_i => clk_40M,
		cs_up =>   cs_vio_up,
		cs_down => cs_vio_down,
		cs_ena =>  cs_vio_ena
	);
	
	game_controller : entity work.game_controller
	port map(
		clk_i 			=> clk_40M,
		cs_up_i 			=> cs_vio_up,
		cs_down_i 		=> cs_vio_down,
		cs_ena_i 		=> cs_vio_ena,
		ps2_up_i 		=> ui_ps2_key_up,
		ps2_down_i 		=> ui_ps2_key_down,
		ps2_ena_i 		=> ctrl_gc_ps2_ena,
		btn_up_i 		=> ui_btn_db(0),
		btn_down_i 		=> ui_btn_db(1),
		gc_commads_o 	=> gc_commads
	);
	
	system_settings : entity work.system_settings
	port map(
		clk_i 					=> clk_40M,
		dip4_db_i 				=> ui_dip4_db,
		dip4_db_tick_i 		=> ui_dip4_db_tick,
		dip8_db_i 				=> ui_dip8_db,
		dip8_db_tick_i 		=> ui_dip8_db_tick,
		ctrl_gc_ps2_ena_o		=> ctrl_gc_ps2_ena,
		ctrl_led_o 				=> ctrl_led
	);
	
	debug : entity work.debug
	generic map(
		C_CLK_FREQ_HZ     => 40000000
	)
	port map(
		clk_i 	=> clk_40M,
		debug_i 	=> ctrl_led & gc_commads,
		led_o		=> led_o
	);

end Behavioral;


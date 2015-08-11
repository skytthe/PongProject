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
--		j7_ps2_clk_io			: inout  std_logic;
--		j7_ps2_data_io			: inout  std_logic;
		
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
		fx2_adc_r_msb_i		: in 		std_logic

--		fx2_adc_g_clk_o		: out		std_logic;
--		fx2_adc_g_msb_i		: in 		std_logic;

--		fx2_adc_b_clk_o		: out		std_logic;
--		fx2_adc_b_msb_i		: in 		std_logic	
	);
end main;

architecture Behavioral of main is

	------------------------------------------------------------
	-- Signals							 						
	------------------------------------------------------------
	-- VGA busses		[hsync,vsync,data] MSB
	signal bus_vga_sampler	: std_logic_vector(2 downto 0);
	signal bus_vga_filter	: std_logic_vector(2 downto 0);




-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-- NEW STUFF START
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------


	------------------------------------------------------------
	-- Signals							 						
	------------------------------------------------------------
	-- Clocks									  		
	signal clk_40M 			: std_logic;

	-- physical pins
	signal clk_adc_r_40M		: std_logic;
	signal btn_inverted		: std_logic_vector(1 downto 0);
	
	-- VGA sampler 
	
	-- User Input
	signal ui_dip4_db      	: std_logic_vector(3 downto 0);
	signal ui_dip4_db_tick 	: std_logic_vector(3 downto 0);
	signal ui_dip8_db      	: std_logic_vector(7 downto 0);
	signal ui_dip8_db_tick 	: std_logic_vector(7 downto 0);
	signal ui_btn_db       	: std_logic_vector(1 downto 0);
	signal ui_btn_db_tick  	: std_logic_vector(1 downto 0);
	signal ui_ps2_key_up   	: std_logic;
	signal ui_ps2_key_down 	: std_logic;
	
	-- ChipScope
	signal cs_vio_up			: std_logic;
	signal cs_vio_down		: std_logic;
	signal cs_vio_ena 		: std_logic;
	
	-- Game Controller
	signal gc_commads			: std_logic_vector(2 downto 0);
	
	-- System Settings - control signals
	signal ctrl_filter_select	: std_logic;
	signal ctrl_ge_signal		: std_logic;
	signal ctrl_gc_ps2_ena		: std_logic;
	signal ctrl_gc_cs_ena		: std_logic;
	signal ctrl_MB_ai_ena		: std_logic;
	signal ctrl_debug_led		: std_logic_vector(3 downto 0);













	-- VGA sampler
	signal vga_hsync		: std_logic;
	signal vga_vsync		: std_logic;
	signal vga_data		: std_logic;
	signal vga_pixel_x	: std_logic_vector(10 downto 0);
	signal vga_pixel_y	: std_logic_vector(9 downto 0);

	-- Filter
	signal filter_ge_hsync		: std_logic;
	signal filter_ge_vsync		: std_logic;
	signal filter_ge_data		: std_logic;


begin

	vga_sampler : entity work.VGA_sampler
	generic map(
		C_CLK_FREQ_HZ  => 40000000
	)
	port map(
		clk_i 			=> clk_40M,
		control_i 		=> dip_sw_i,	--TODO: redo to system settings or auto
		vga_hsync_i 	=> fx2_vga_hsync_i,
		vga_vsync_i 	=> fx2_vga_vsync_i,
		vga_data_i 		=> fx2_adc_r_msb_i,
		vga_hsync_o 	=> vga_hsync,
		vga_vsync_o 	=> vga_vsync,
		vga_data_o 		=> vga_data,
		vga_pixel_x_o 	=> vga_pixel_x,
		vga_pixel_y_o 	=> vga_pixel_y
	);
	
	filter: entity work.filter
	generic map(
		C_CLK_FREQ_HZ     => 40000000
	)
	port map(
		clk_i 					=> clk_40M,
		hsync_i		 			=> vga_hsync,
		vsync_i 					=> vga_vsync,
		data_i 					=> vga_data,
		pixel_x_i 				=> vga_pixel_x,
		pixel_y_i 				=> vga_pixel_y,
		filter_ge_hsync_o 	=> filter_ge_hsync,
		filter_ge_vsync_o 	=> filter_ge_vsync,
		filter_ge_data_o 		=> filter_ge_data,
		filter_ge_pixel_x_o	=> open,
		filter_ge_pixel_y_o 	=> open,
		filter_gs_hsync_o 	=> open,
		filter_gs_vsync_o 	=> open,
		filter_gs_data_o 		=> open,
		filter_gs_pixel_x_o 	=> open,
		filter_gs_pixel_y_o 	=> open
	);
	
	graphics_engine : entity work.graphics_engine
	generic map(
		C_CLK_FREQ_HZ     => 40000000
	)
	port map(
		clk_i       => clk_40M,
	   vga_hsync_i => filter_ge_hsync,
	   vga_vsync_i => filter_ge_vsync,
	   vga_data_i  => filter_ge_data,
	   vga_hsync_o => j8_vga_hsync_o,
	   vga_vsync_o => j8_vga_vsync_o,
	   vga_r_o     => j8_vga_r_o,
	   vga_g_o     => j8_vga_g_o,
	   vga_b_o     => j8_vga_b_o
	);














	-- clocks
	clk_resources : entity work.clock_resources
	port map(
		clk_200M_i 			=> clk_200M_i,
		clk_40M_o			=> clk_40M,
		adc_40M_vga_r_o	=> clk_adc_r_40M
	);
	
	-- physical pins
	fx2_adc_r_clk_o <= clk_adc_r_40M;
	btn_inverted <= not j7_btn_i;



	user_input : entity work.user_input
	generic map(
		C_CLK_FREQ_HZ     	=> 40000000,
		C_DEBOUNCE_PERIOD_MS	=> 10
	)
	port map(
		clk_i 		=> clk_40M,
		dip4_i		=> dip_sw_i,
		dip8_i		=> j7_dip_sw_i,
		btn_i 		=> btn_inverted,
--		ps2_clk_io	=> j7_ps2_clk_io,
--		ps2_data_io	=> j7_ps2_data_io,
		dip4_db_o      => ui_dip4_db,
		dip4_db_tick_o => ui_dip4_db_tick,
		dip8_db_o      => ui_dip8_db,
		dip8_db_tick_o => ui_dip8_db_tick,
		btn_db_o       => ui_btn_db,
		btn_db_tick_o  => ui_btn_db_tick,
		ps2_key_up_o   => ui_ps2_key_up,
		ps2_key_down_o => ui_ps2_key_down
	);

	cs : entity work.chipscope
	port map(
		clk_i 	=> clk_40M,
		cs_up 	=>	cs_vio_up,
		cs_down 	=> cs_vio_down,
		cs_ena 	=> cs_vio_ena
	);

	game_controller : entity work.game_controller
	port map(
		clk_i 			=> clk_40M,
		cs_up_i 			=> cs_vio_up,
		cs_down_i 		=> cs_vio_down,
		cs_ena_i 		=> ctrl_gc_cs_ena,
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
		chipscope_i 			=> cs_vio_ena,
		ctrl_filter_select_o => ctrl_filter_select,
		ctrl_ge_signal_o 		=> ctrl_ge_signal,
		ctrl_gc_ps2_ena_o 	=> ctrl_gc_ps2_ena,
		ctrl_gc_cs_ena_o 		=> ctrl_gc_cs_ena,
		ctrl_MB_ai_ena_o 		=> ctrl_MB_ai_ena,
		ctrl_debug_led_o 		=> ctrl_debug_led
	);
	
	debug : entity work.debug
	generic map(
		C_CLK_FREQ_HZ     => 40000000
	)
	port map(
		clk_i 					=> clk_40M,
		debug_i(6 downto 3) 	=> ctrl_debug_led,
		debug_i(2 downto 0) 	=> gc_commads,
		led_o						=> led_o
	);

end Behavioral;


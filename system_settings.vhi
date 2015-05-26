
-- VHDL Instantiation Created from source file system_settings.vhd -- 03:22:47 05/26/2015
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT system_settings
	PORT(
		clk_i : IN std_logic;
		dip4_db_i : IN std_logic_vector(3 downto 0);
		dip4_db_tick_i : IN std_logic_vector(3 downto 0);
		dip8_db_i : IN std_logic_vector(7 downto 0);
		dip8_db_tick_i : IN std_logic_vector(7 downto 0);          
		control_led_o : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	Inst_system_settings: system_settings PORT MAP(
		clk_i => ,
		dip4_db_i => ,
		dip4_db_tick_i => ,
		dip8_db_i => ,
		dip8_db_tick_i => ,
		control_led_o => 
	);



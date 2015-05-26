
-- VHDL Instantiation Created from source file game_controller.vhd -- 03:27:14 05/26/2015
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT game_controller
	PORT(
		clk_i : IN std_logic;
		cs_up_i : IN std_logic;
		cs_down_i : IN std_logic;
		cs_ena_i : IN std_logic;
		ps2_up_i : IN std_logic;
		ps2_down_i : IN std_logic;
		ps2_ena_i : IN std_logic;
		btn_up_i : IN std_logic;
		btn_down_i : IN std_logic;          
		gc_up_o : OUT std_logic;
		gc_down_o : OUT std_logic
		);
	END COMPONENT;

	Inst_game_controller: game_controller PORT MAP(
		clk_i => ,
		cs_up_i => ,
		cs_down_i => ,
		cs_ena_i => ,
		ps2_up_i => ,
		ps2_down_i => ,
		ps2_ena_i => ,
		btn_up_i => ,
		btn_down_i => ,
		gc_up_o => ,
		gc_down_o => 
	);



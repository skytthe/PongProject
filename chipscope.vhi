
-- VHDL Instantiation Created from source file chipscope.vhd -- 02:15:37 05/26/2015
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT chipscope
	PORT(
		clk_i : IN std_logic;          
		cs_up : OUT std_logic;
		cs_down : OUT std_logic;
		cs_ena : OUT std_logic
		);
	END COMPONENT;

	Inst_chipscope: chipscope PORT MAP(
		clk_i => ,
		cs_up => ,
		cs_down => ,
		cs_ena => 
	);



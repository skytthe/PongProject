library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity game_controller is
	port(
		clk_i          : in  	std_logic;
		cs_up_i			: in  	std_logic;
		cs_down_i		: in  	std_logic;
		cs_ena_i			: in  	std_logic;
		ps2_up_i			: in  	std_logic;
		ps2_down_i		: in  	std_logic;
		ps2_ena_i		: in  	std_logic;
		btn_up_i			: in  	std_logic;
		btn_down_i		: in  	std_logic;
		gc_commads_o	: out  	std_logic_vector(2 downto 0)
	);
end game_controller;

architecture Behavioral of game_controller is

	signal control_up,control_down	:	std_logic;
	
	-- FSM
	type state_type is (stop,up,down); 
   signal state  		: state_type := stop;
   signal next_state : state_type;
	signal fsm_output	: std_logic_vector(2 downto 0);
	
begin

	-- select control input
	process(clk_i)
	begin
		if rising_edge(clk_i) then
			if (cs_ena_i = '1') then
				control_up 		<= cs_up_i;
				control_down 	<= cs_down_i;
			elsif (ps2_ena_i = '1') then
				control_up 		<= ps2_up_i;
				control_down 	<= ps2_down_i;
			else
				control_up 		<= btn_up_i;
				control_down 	<= btn_down_i;				
			end if;
		end if;
	end process;
	
	
	-- control FSM

	
-- This is a sample state-machine using enumerated types.
-- This will allow the synthesis tool to select the appropriate
-- encoding style and will make the code more readable.
 
--Insert the following in the architecture before the begin keyword
   --Use descriptive names for the states, like st1_reset, st2_search
-- type state_type is (st1_<name_state>, st2_<name_state>, ...); 
-- signal state, next_state : state_type; 
   --Declare internal signals for all outputs of the state-machine
-- signal <output>_i : std_logic;  -- example output signal
   --other outputs
 
--Insert the following in the architecture after the begin keyword
   SYNC_PROC: process(clk_i)
   begin
      if rising_edge(clk_i) then
--         if (reset = '1') then
--            state <= stop;
--            gc_commads_o <= "000";
--         else
            state <= next_state;
				gc_commads_o <= fsm_output;
--         end if;        
      end if;
   end process;
 
   --MOORE State-Machine - Outputs based on state only
   OUTPUT_DECODE: process (state)
   begin
		case (state) is
         when stop =>
				fsm_output <= "010";
         when up =>
				fsm_output <= "100";
         when down =>
				fsm_output <= "001";
         when others =>
				fsm_output <= "010";
      end case;   
   end process;
 
   NEXT_STATE_DECODE: process (state, control_up, control_down)
   begin
      --declare default state for next_state to avoid latches
      next_state <= state;  --default is to stay in current state
      --insert statements to decode next_state
      --below is a simple example
      case (state) is
         when stop =>
            if control_up = '1' then
               next_state <= up;
				elsif control_down = '1' then
               next_state <= down;
            end if;
         when up =>
            if control_up = '0' then
               next_state <= stop;
            end if;
         when down =>
            if control_down = '0' then
               next_state <= stop;
            end if;
         when others =>
            next_state <= stop;
      end case;      
   end process;

end Behavioral;


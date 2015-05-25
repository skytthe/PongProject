library ieee;
use ieee.std_logic_1164.all;

entity ps2_rx_fsm is
	port ( 
		clk_i 		: in  std_logic;
		
		rx_data_i	: in  std_logic_vector (7 downto 0);
		read_i 		: in  std_logic;
		
		up_o 			: out std_logic;
		stop_o 		: out std_logic;
		down_o 		: out std_logic
	);
end ps2_rx_fsm;

architecture Behavioral of ps2_rx_fsm is

	type STATE_TYPE is (ST_IDLE, ST_EXTENDED, ST_BREAK, ST_UP, ST_DOWN, ST_STOP, ST_BUSY);
	signal cur_state, nxt_state : STATE_TYPE := ST_IDLE;

	constant BREAK_CODE 		: std_logic_vector(7 downto 0) := "11110000"; --0xF0
	constant EXTENDED_CODE 	: std_logic_vector(7 downto 0) := "11100000"; --0xE0
	constant UP_CODE 			: std_logic_vector(7 downto 0) := "01110101"; --0x75 : Key Press = 0xE0 0x75 , Key Release = 0xE0 0xF0 0x75
	constant DOWN_CODE 		: std_logic_vector(7 downto 0) := "01110010"; --0x72 : Key Press = 0xE0 0x72 , Key Release = 0xE0 0xF0 0x72

begin

	-- FSM
	process(clk_i)
	begin
		if rising_edge(clk_i) then
			cur_state <= nxt_state;
		end if;
	end process;

	-- Output logic
	process(cur_state)
	begin
		
		-- default
		up_o 		<= '0';
		down_o 	<= '0';
		stop_o 	<= '0';
		
		case cur_state is
			when ST_UP   => up_o   <= '1';
			when ST_DOWN => down_o <= '1';
			when ST_STOP => stop_o <= '1';
			when others  => null;
		end case;
		
	end process;

	-- next state logic
	process(cur_state, rx_data_i, read_i)
	begin
		
		-- default
		nxt_state <= cur_state;
		
		case cur_state is
			when ST_IDLE =>
				if read_i = '1' then
					if rx_data_i = EXTENDED_CODE then
						nxt_state <= ST_EXTENDED;
					else
						nxt_state <= ST_STOP;
					end if;
				end if;

			when ST_EXTENDED =>
				if read_i = '1' then
					if rx_data_i = UP_CODE then
						nxt_state <= ST_UP;
					elsif rx_data_i = DOWN_CODE then
						nxt_state <= ST_DOWN;
					else
						nxt_state <= ST_BREAK;
					end if;
				end if;
				
			when ST_BREAK =>
				if read_i = '1' then
					nxt_state <= ST_STOP;
				end if;
			
			when ST_BUSY =>
				if read_i = '1' then
					if rx_data_i = BREAK_CODE then
						nxt_state <= ST_BREAK;
					end if;
				end if;
				
			when ST_UP =>
				nxt_state <= ST_BUSY;
			
			when ST_DOWN =>
				nxt_state <= ST_BUSY;

			when ST_STOP =>
				nxt_state <= ST_IDLE;

			when others =>
				nxt_state <= ST_STOP;
				
		end case;
	end process;

end Behavioral;


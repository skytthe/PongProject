library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sliding_average is
	generic(
		C_CLK_FREQ_HZ	: integer := 40000000;
		FILTER_LENGTH	: integer := 3
	);
	port(
		clk_i		: in  std_logic;
		data_i	: in  std_logic;
		data_o	: out std_logic
	);
end sliding_average;

architecture Behavioral of sliding_average is
	signal color_shift_register	: STD_LOGIC_VECTOR (FILTER_LENGTH-1 downto 0);
	signal number_of_whites			: integer := 0;

begin

	-- Sliding filter
	process(clk_i)
		variable change_in_number_of_whites : integer := 0; 
	begin
		if rising_edge(clk_i) then
			change_in_number_of_whites := 0;
		
			if(data_i = '1') then
				change_in_number_of_whites := 1;
			end if;
			
			if(color_shift_register(2) = '1') then
				change_in_number_of_whites := change_in_number_of_whites - 1;
			end if; 
			
			number_of_whites <= number_of_whites + change_in_number_of_whites;
			
			if(number_of_whites > FILTER_LENGTH/2) then
				data_o <= '1';
			else
				data_o <= '0';
			end if;
			
			color_shift_register <= color_shift_register(FILTER_LENGTH-2 downto 0) & data_i;
		end if;
	end process;

end Behavioral;


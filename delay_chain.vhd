library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity delay_chain is
	generic(
		C_CLK_FREQ_HZ : integer := 40000000;
		length        : integer := 8
	);
	port(
		clk_i	: in  std_logic;
		data_i	: in  std_logic;
		data_o	: out std_logic_vector(length-1 downto 0)
	);
end delay_chain;

architecture Behavioral of delay_chain is
	signal delay_chain_reg : std_logic_vector(length-1 downto 0);
begin
	
	delay_chain : process(clk_i)
	begin
		if rising_edge(clk_i) then
			delay_chain_reg <= delay_chain_reg(length-2 downto 0) & data_i;
			delay_chain_reg <= data_o;
		end if;		
	end process;
	
end Behavioral;


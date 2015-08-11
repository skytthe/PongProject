library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity chipscope is
	port(
		clk_i		: in	std_logic;
		cs_up		: out	std_logic;
		cs_down	: out	std_logic;
		cs_ena	: out	std_logic
	);
	
end chipscope;

architecture Behavioral of chipscope is

	component cs_icon
		PORT (
			CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0)
		);
	end component;
	
	component cs_vio
		PORT (
			CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
			ASYNC_OUT : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
	end component;

	signal controlVIO 		: std_logic_vector(35 downto 0); 
	signal cs_vio_async_o	: std_logic_vector(2 downto 0);
	
begin

	chipscope_icon : cs_icon
	port map (
		CONTROL0 => controlVIO
	);
	
	chipscope_vio : cs_vio
	port map (
		CONTROL => controlVIO,
		ASYNC_OUT => cs_vio_async_o
	);
	
	sync_cs_vio : process(clk_i)
	begin
		if rising_edge(clk_i) then
			cs_up		<= cs_vio_async_o(0);
			cs_down	<= cs_vio_async_o(1);
			cs_ena	<= cs_vio_async_o(2);
		end if;
	end process;

end Behavioral;

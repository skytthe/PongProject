library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use ieee.std_logic_textio.all;
use std.textio.all;

entity image_rom is
	port (
		clk_i 	: in std_logic;
		adr_i 	: in std_logic_vector(18 downto 0);
		data_o	: out std_logic
	);
end entity image_rom;

architecture Behavioral of image_rom is
	
	type ROM is array(0 to 800*600) of std_logic;
	
	impure function load_rom(list_file : in string) return ROM is
		file image_list		: text is in list_file;
		variable list_line	: line;
		variable image_rom 	: ROM;
	begin
		for i in ROM' range loop
			readline (image_list, list_line);                             
			read (list_line, image_rom(i));  	
		end loop;
		return image_rom;
	end function;
		
	signal image_rom : ROM := load_rom("image_rom.list");
	
begin
	
	process(clk_i)
	begin
		if rising_edge(clk_i) then
			data_o <= image_rom(to_integer(unsigned(adr_i)));
		end if;
	end process ;
	
end architecture Behavioral;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_sampler is
	generic(
		C_CLK_FREQ_HZ     : integer := 40000000;
		delay : integer := 4
	);
	port(
		--
		clk_i 		: in  std_logic;
		--
		control_i	: in std_logic_vector(3 downto 0);
		--	adc
		vga_hsync_i		: in  std_logic;
		vga_vsync_i		: in  std_logic;
		vga_r_clk_o		: out std_logic;
		vga_r_i			: in  std_logic;
		vga_g_clk_o		: out std_logic;
		vga_g_i			: in  std_logic;
		vga_b_clk_o		: out std_logic;
		vga_b_i			: in  std_logic;
		
		-- 
		vga_hsync_o		: out  std_logic;
		vga_vsync_o		: out  std_logic;	
		vga_data_o		: out  std_logic
	);
end VGA_sampler;

architecture Behavioral of VGA_sampler is
	signal		HsyncReg,VsyncReg : std_logic_vector(15 downto 0);
begin

	process (clk_i)
		variable count : std_logic := '0';
	begin
		if rising_edge(clk_i) then
			count := not count;
			
			vga_r_clk_o <= count;
			vga_g_clk_o <= count;
			vga_b_clk_o <= count;
		end if;
	end process;

--	vga_r_clk_o <= clk_i;
--	vga_g_clk_o <= clk_i;
--	vga_b_clk_o <= clk_i;

--	vga_hsync_o <= Hsync_reg(delay-1);
--	vga_vsync_o <= Vsync_reg(delay-1);

	name : process (clk_i) is
	begin
		if rising_edge(clk_i) then
--			Hsync_reg <= Hsync_reg(delay-2 downto 0) & vga_hsync_i;
--			Vsync_reg <= Vsync_reg(delay-2 downto 0) & vga_vsync_i;	
			vga_data_o  <= vga_r_i;-- and vga_g_i and vga_b_i;
		end if;
	end process name;
	
process (clk_i)
begin
	if rising_edge(clk_i) then
--	if adc_clk ='1' then
		HsyncReg <= HsyncReg(14 downto 0) & vga_hsync_i;
		VsyncReg <= VsyncReg(14 downto 0) & vga_vsync_i;
		
		
   case (control_i) is 
      when "0000" =>
			vga_hsync_o <= HsyncReg(0);
			vga_vsync_o <= VsyncReg(0);
      when "0001" =>
			vga_hsync_o <= HsyncReg(1);
			vga_vsync_o <= VsyncReg(1);
      when "0010" =>
			vga_hsync_o <= HsyncReg(2);
			vga_vsync_o <= VsyncReg(2);
      when "0011" =>
			vga_hsync_o <= HsyncReg(3);
			vga_vsync_o <= VsyncReg(3);
      when "0100" =>
			vga_hsync_o <= HsyncReg(4);
			vga_vsync_o <= VsyncReg(4);
      when "0101" =>
			vga_hsync_o <= HsyncReg(5);
			vga_vsync_o <= VsyncReg(5);
      when "0110" =>
			vga_hsync_o <= HsyncReg(6);
			vga_vsync_o <= VsyncReg(6);
      when "0111" =>
			vga_hsync_o <= HsyncReg(7);
			vga_vsync_o <= VsyncReg(7);
      when "1000" =>
			vga_hsync_o <= HsyncReg(8);
			vga_vsync_o <= VsyncReg(8);
      when "1001" =>
			vga_hsync_o <= HsyncReg(9);
			vga_vsync_o <= VsyncReg(9);
      when "1010" =>
			vga_hsync_o <= HsyncReg(10);
			vga_vsync_o <= VsyncReg(10);
      when "1011" =>
			vga_hsync_o <= HsyncReg(11);
			vga_vsync_o <= VsyncReg(11);
      when "1100" =>
			vga_hsync_o <= HsyncReg(12);
			vga_vsync_o <= VsyncReg(12);
      when "1101" =>
			vga_hsync_o <= HsyncReg(13);
			vga_vsync_o <= VsyncReg(13);
      when "1110" =>
			vga_hsync_o <= HsyncReg(14);
			vga_vsync_o <= VsyncReg(14);
      when "1111" =>
			vga_hsync_o <= HsyncReg(15);
			vga_vsync_o <= VsyncReg(15);
      when others =>
         null;
   end case;
				
		
--	end if;
	end if;
end process;


end Behavioral;


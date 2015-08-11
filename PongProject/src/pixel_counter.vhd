library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.VComponents.all;

entity pixel_counter is
	generic(
		C_CLK_FREQ_HZ     : integer := 40000000
	);
   port ( 
		clk_40M_i		: in  std_logic;
      hsync_i 			: in  std_logic;
      vsync_i 			: in  std_logic;
      pixel_x_o 		: out std_logic_vector(10 downto 0);
      pixel_y_o 		: out std_logic_vector(9 downto 0);
		visable_area_o	: out std_logic
	);
end pixel_counter;

architecture Behavioral of pixel_counter is
	constant Y_vis_min : unsigned(9 downto 0)  :=  "0000101011";  --
	constant Y_vis_max : unsigned(9 downto 0)	 :=  "1000001010";  --
	constant X_vis_min : unsigned(10 downto 0) := "00010010111";  --
	constant X_vis_max : unsigned(10 downto 0) := "01100010001";  --
		
	signal	Hsync_shift_reg	: std_logic_vector(2 downto 0);
	signal	Vsync_shift_reg	: std_logic_vector(2 downto 0);

	signal	Hsync_rising	: std_logic;
	signal	Vsync_rising	: std_logic;
	
	signal	Xcounter			: unsigned(10 downto 0) := "00000000000";
	signal	Ycounter			: unsigned(9 downto 0) := "0000000000";
	
	signal	Xcounter_temp	: unsigned(10 downto 0) := "00000000000";
	signal	Ycounter_temp	: unsigned(9 downto 0) := "0000000000";
begin

	-- edge detection: Hsync , Vsync
	process (clk_40M_i,Hsync_shift_reg,Vsync_shift_reg)
	begin
		if rising_edge(clk_40M_i) then
--			if (ena_clk_25M_i = '1') then
				Hsync_shift_reg <= Hsync_shift_reg(1 downto 0) & hsync_i;
				Vsync_shift_reg <= Vsync_shift_reg(1 downto 0) & vsync_i;				
--			end if;
			Hsync_rising <= Hsync_shift_reg(2) AND Hsync_shift_reg(1) AND not Hsync_shift_reg(0);
			Vsync_rising <= Vsync_shift_reg(2) AND Vsync_shift_reg(1) AND not Vsync_shift_reg(0);			
		end if;
	end process;
	
	
	-- Xcounter (x)
	process(clk_40M_i)
	begin
		if (rising_edge(clk_40M_i)) then
			if (Hsync_rising = '1') then
				Xcounter <= (others => '0');
			else
				Xcounter <= Xcounter + 1;
			end if;
		end if;
	end process;
	pixel_x_o <= std_logic_vector(Xcounter);
	
	-- Ycounter (y)
	process(clk_40M_i)
	begin
		if (rising_edge(clk_40M_i)) then
			if (Vsync_rising = '1') then
				Ycounter <= (others => '0');
			elsif (Hsync_rising = '1') then
				Ycounter <= Ycounter + 1;
			end if;
		end if;
	end process;
	pixel_y_o <= std_logic_vector(Ycounter);

	process(clk_40M_i)
	begin
		if (rising_edge(clk_40M_i)) then	
			if (
			(Xcounter >= X_vis_min) and
			(Xcounter <= X_vis_max) and
			(Ycounter >= Y_vis_min) and
			(Ycounter <= Y_vis_max)
			) then
				visable_area_o <= '1';
			else
				visable_area_o <= '0';			
			end if;
		end if;
	end process;
end Behavioral;


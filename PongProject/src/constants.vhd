library ieee;
use ieee.std_logic_1164.all;

package constants is
--		----------------
--		-- 640x480@60 --
--		----------------
--		constant C_H_Pulse 			: integer := 96;
--		constant C_H_BP 			: integer := 48;
--		constant C_H_PX 			: integer := 640;
--		constant C_H_FP 			: integer := 16;
--		
--		constant C_HS_OFFSET  	 	: integer := C_H_Pulse+C_H_BP;
--		constant C_HS_OFFSET2  	 	: integer := C_H_Pulse+C_H_BP+C_H_PX;
--		constant C_PIXEL_PR_LINE 	: integer := C_H_FP+C_H_Pulse+C_H_BP+C_H_PX;		
--			
--		constant C_V_Pulse 			: integer := 2;
--		constant C_V_BP 			: integer := 33;
--		constant C_V_LN 			: integer := 480;
--		constant C_V_FP 			: integer := 10;
--		
--		constant C_VS_OFFSET 		: integer := C_V_Pulse+C_V_BP;	
--		constant C_VS_OFFSET2		: integer := C_V_Pulse+C_V_BP+C_V_LN;
--		constant C_LINES_PR_FRAME 	: integer := C_V_FP+C_V_Pulse+C_V_BP+C_V_LN	

	----------------
	-- 800x600@60 --
	----------------
	constant C_H_Pulse 			: integer := 128;
	constant C_H_BP 			: integer := 88;
	constant C_H_PX 			: integer := 800;
	constant C_H_FP 			: integer := 40;
		
	constant C_HS_OFFSET		: integer := C_H_Pulse+C_H_BP;	
	constant C_HS_OFFSET2		: integer := C_H_Pulse+C_H_BP+C_H_PX;	
	constant C_PIXEL_PR_LINE	: integer := C_H_FP+C_H_Pulse+C_H_BP+C_H_PX;		
			
	constant C_V_Pulse			: integer := 4;
	constant C_V_BP				: integer := 23;
	constant C_V_LN				: integer := 600;
	constant C_V_FP				: integer := 1;
		
	constant C_VS_OFFSET 		: integer := C_V_Pulse+C_V_BP;
	constant C_VS_OFFSET2		: integer := C_V_Pulse+C_V_BP+C_V_LN;
	constant C_LINES_PR_FRAME 	: integer := C_V_FP+C_V_Pulse+C_V_BP+C_V_LN;	
	
	constant C_BAT_WIDTH		: integer := 19;
	constant C_BAT_HEIGHT		: integer := 199;
	constant C_BALL_WIDTH		: integer := 19;
	constant C_BALL_HEIGHT		: integer := 19;
	
	constant C_CLK_FREQ_HZ		: integer := 40000000;
	constant C_CLK_PRD_NS		: time    := 25 ns;
	
	constant C_ADC_WIDTH		: natural := 10;
	constant C_DAC_WIDTH		: natural := 3;

end package constants;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.log_pkg.all;

entity debounce is
   generic(
      C_CLK_FREQ_HZ          : integer := 40000000;           -- Clock frequency [Hz]
      C_DEBOUNCE_PERIOD_MS   : integer range 1 to 200 := 1;  -- Debounce period [ms]
      C_EDGE_SENSITIVITY     : integer range 0 to 2 := 2      -- Determines when the db_tick output will be strobed: 0->rising edge, 1->falling edge, 2->both edge
      );
   port(
      clk_i       : in  std_logic;
      signal_i    : in  std_logic;
      db_level_o  : out std_logic;
      db_tick_o   : out std_logic
      );
end debounce ;

architecture fsmd of debounce is

   constant LOADVAL  : integer   := (C_CLK_FREQ_HZ/1000)*C_DEBOUNCE_PERIOD_MS;   -- ex: (66*10^6/1000)*20 = 1320000 -> 1320000/66*10^6 = 20ms
   constant N        : integer   := log2c(LOADVAL);
   
   type state_type is (ZERO, WAIT0, ONE, WAIT1);
   signal state_reg  : state_type := ZERO;
   signal state_next : state_type;
   
   signal q_reg   : unsigned(N-1 downto 0);
   signal q_next  : unsigned(N-1 downto 0);
   
   signal q_load  : std_logic;
   signal q_dec   : std_logic;
   signal q_zero  : std_logic;
   
begin

   ------------------------------------------------
   -- FSMD state & data registers
   ------------------------------------------------
      process(clk_i)
      begin
         if rising_edge(clk_i) then
				state_reg <= state_next;
            q_reg <= q_next;
         end if;
      end process;
   ------------------------------------------------
   
   ------------------------------------------------
   -- FSMD data path (counter) next-state logic
   ------------------------------------------------
      q_next <= TO_UNSIGNED(LOADVAL, N) when q_load='1' else
                q_reg - 1 when q_dec='1' else
                q_reg;
                
      q_zero <= '1' when q_next=0 else '0';
   ------------------------------------------------

   ------------------------------------------------
   -- FSMD control path next-state logic
   ------------------------------------------------
      process(state_reg, signal_i, q_zero)
      begin
         
         -- defaults
         state_next  <= state_reg;         
         q_load      <= '0';
         q_dec       <= '0';
         db_tick_o   <= '0';
         
         
         case state_reg is
            -----------------------------
            -- State: ZERO
            -----------------------------
               when ZERO =>
                  db_level_o <= '0';
                  if (signal_i='1') then
                     state_next <= wait1;
                     q_load <= '1';
                  end if;
            -----------------------------
            
            -----------------------------
            -- State: WAIT1
            -----------------------------
            when WAIT1=>
               db_level_o <= '0';
               if (signal_i='1') then
                  q_dec <= '1';
                  if (q_zero='1') then
                     state_next <= one;                     
                     if C_EDGE_SENSITIVITY /= 1 then 	-- when C_EDGE_SENSITIVITY is 0 or 2
                        db_tick_o <= '1';          	-- generate tick on rising edge
                     end if;
                  end if;
               else -- signal_i='0'
                  state_next <= zero;
               end if;
            -----------------------------
            
            -----------------------------
            -- State: ONE
            -----------------------------
               when ONE =>
                  db_level_o <= '1';
                  if (signal_i='0') then
                     state_next <= wait0;
                     q_load <= '1';
                  end if;
            -----------------------------
            
            -----------------------------
            -- State: WAIT0
            -----------------------------
               when WAIT0=>
                  db_level_o <= '1';
                  if (signal_i='0') then
                     q_dec <= '1';
                     if (q_zero='1') then
                        state_next <= zero;
                        if C_EDGE_SENSITIVITY /= 0 then 	-- when C_EDGE_SENSITIVITY is 1 or 2
                           db_tick_o <= '1';          	-- generate tick on falling edge
                        end if;
                     end if;
                  else -- signal_i='1'
                     state_next <= one;
                  end if;
            -----------------------------
         end case;
      end process;
   ------------------------------------------------
   
end fsmd;


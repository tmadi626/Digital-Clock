library ieee;

use ieee.std_logic_1164.all;

use ieee.std_logic_unsigned.all;

entity Clock is
		Port (SW: in std_logic_vector(7 downto 0);	-- INPUT SWITCHES
				KEY : in std_logic_vector (3 downto 0);-- INPUT BUTTONS
				CLOCK_50: in std_logic; 					-- FPGA BOARD INTERNAL 50MHz CLOCK
				LEDR : out std_logic_vector (9 downto 0);-- LEDRs To Reflect the time set
				HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(6 downto 0));-- ALL OF THE HEX DISPLAYS
end Clock;

architecture design of Clock is
--==============================
--	COMPONENTS USED:
    component SevSegDecoder
			port (Num: in std_logic_vector(3 downto 0);
					HEX: out std_logic_vector(6 downto 0) );
    end component;
	 
	 component Counter26Bit
			port (rst,clk : in std_logic;
					sec1: out std_logic );
    end component;
	 
	 
	 component Counter4Bit
			port (rst,clk,load: in std_logic;
					Cin: in std_logic_vector(3 downto 0);
					bound: in std_logic_vector(3 downto 0);
					X: out std_logic;
					Cout: out std_logic_vector(3 downto 0) );
    end component;
	 component Compare
			port (ValIn: in std_logic_vector(3 downto 0);
				Limit: in std_logic_vector(3 downto 0);
				ValOut: out std_logic_vector(3 downto 0) );
    end component;
	 component Indicator
	 	 port(Switches: in std_logic_vector(7 downto 0);	-- INPUT SWITCHES
			 LEDRs: out std_logic_vector (9 downto 0) );
	 end component;
--==============================
--	SIGNALS USED FOR INPUT:
	signal KEY_B0: std_logic:= '1';
	signal KEY_B2: std_logic:= '1';
	signal KEY_B3: std_logic:= '1';

-- SIGNALS USED FOR COUNTERS INPUT
	signal OneSecond: std_logic :='0';	-- For the 50MHz Clock
	signal ResetSecond: std_logic :='1';
	signal ResetMins: std_logic :='1';
	signal ResetHours: std_logic :='1'; -- Max Hours Reached 23:59:59
	
		--Signals for the counters Outputs to the Displays
			--1st Seconds Counter
			signal CoutSec0: std_logic_vector(3 downto 0);	-- the output for the hex display
			signal Sec1Reached: std_logic :='0';				-- the clock for the next counter
			--2nd Seconds Counter
			signal CoutSec1: std_logic_vector(3 downto 0);	-- the output for the hex display
			signal Sec60Reached: std_logic :='0';				-- the clock for the next counter
			
			--1st Minutes Counter
			signal CoutMin0: std_logic_vector(3 downto 0);	-- the output for the hex display
			signal Min1Reached: std_logic :='0';				-- the clock for the next counter
			--2nd Minutes Counter
			signal CoutMin1: std_logic_vector(3 downto 0);	-- the output for the hex display
			signal Min60Reached: std_logic :='0';				-- the clock for the next counter
			
			--1st Hours Counter
			signal CoutHr0: std_logic_vector(3 downto 0);	-- the output for the hex display
			signal Hr1Reached: std_logic :='0';				-- the clock for the next counter
			--2nd Hours Counter
			signal CoutHr1: std_logic_vector(3 downto 0);	-- the output for the hex display
			signal Hr24Reached: std_logic :='0';				-- the clock for the next counter
			
--	SIGNALS USED FOR INPUT:
	signal CheckedHr0Input: std_logic_vector(3 downto 0);
--==============================
begin
	KEY_B0<= KEY(0);
	KEY_B2<= KEY(2);
	KEY_B3<= KEY(3);
	
	ResetSecond <= KEY_B2 and KEY_B3 and (not Hr24Reached) and KEY_B0; -- When setting the Minutes/Hrs Seconsd reset  and when pressing KEY(0)
	
	ResetMins <= (not Hr24Reached) and KEY_B0; --- Resetting Minutes when 24Hr reach or when KEY(0) perssed

	
	-- COUNTER:
   COUNTER_26BIT: Counter26Bit port map(KEY_B0, CLOCK_50, OneSecond);
	
	-- SECONDS COUNTERS:
	-- Load is '1' because we never load the seconds| Cin is "0000" because we just have to input something| bound is "1010" because when 10 we roll over
	--												RESET		|	CLOCK	  |LOAD|		Cin  |Bound|	X			| Cout
	COUNTER1Sec: Counter4Bit port map(ResetSecond, OneSecond, '1', "0000", "1001", Sec1Reached, CoutSec0);
	COUNTER60Sec: Counter4Bit port map(ResetSecond, Sec1Reached, '1', "0000", "0101", Sec60Reached, CoutSec1);
	
	-- MINUTES COUNTERS:
	COUNTER1Min: Counter4Bit port map(ResetMins, Sec60Reached, KEY_B3, SW(3 downto 0), "1001", Min1Reached, CoutMin0);
	COUNTER60Min: Counter4Bit port map(ResetMins, Min1Reached, KEY_B3, SW(7 downto 4), "0101", Min60Reached, CoutMin1);
	
	-- HOURS COUNTERS:
	COMPARE1Hr: Compare port map(SW(3 downto 0), CoutHr1, CheckedHr0Input);
	COUNTER1Hr: Counter4Bit port map(ResetHours, Min60Reached, KEY_B2, CheckedHr0Input, "1001", Hr1Reached, CoutHr0);
	
	COUNTER24Hr: Counter4Bit port map(ResetHours, Hr1Reached, KEY_B2, SW(7 downto 4), "0010", Hr24Reached, CoutHr1);
	
	-- LEDRS REFLECT Switches
	Indicator8: Indicator port map(SW,LEDR);
	
	-- DISPLAYS:
   S0_DISPLAY: SevSegDecoder port map(CoutSec0, HEX0);
   S10_DISPLAY: SevSegDecoder port map(CoutSec1, HEX1);
	 
	M0_DISPLAY: SevSegDecoder port map(CoutMin0, HEX2);
   M10_DISPLAY: SevSegDecoder port map(CoutMin1, HEX3);
	 
   H0_DISPLAY: SevSegDecoder port map(CoutHr0, HEX4);
   H10_DISPLAY: SevSegDecoder port map(CoutHr1, HEX5);
	
	process(CoutHr0, KEY_B0)
	begin
	ResetHours <= '1';
	
		if( KEY_B0 = '0') then	-- Hours resets if KEY(0) pressed
			ResetHours <= '0';
	
		elsif( CoutHr1 = "0010" and CoutHr0 >= "0100") then	-- Hours  resets once the clock Reaches:  23:59:59 + 00:00:01 or more
				ResetHours<= '0';
			
		end if;
	
	end process;

	
end design;
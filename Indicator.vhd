library ieee;
use ieee.std_logic_1164.all;


entity Indicator is
	port(Switches: in std_logic_vector(7 downto 0);	-- INPUT SWITCHES
		LEDRs: out std_logic_vector (9 downto 0) );
end Indicator;


architecture design of Indicator is

begin
	
	process(Switches)
	begin
		
		LEDRs<="00"&Switches;
		
	end process;

end design;
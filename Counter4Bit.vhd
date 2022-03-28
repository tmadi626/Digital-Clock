library ieee;

use ieee.std_logic_1164.all;

use ieee.std_logic_unsigned.all;

entity Counter4Bit is
		Port (rst,clk,load: in std_logic;
				Cin: in std_logic_vector(3 downto 0);
				bound: in std_logic_vector(3 downto 0);
				X: out std_logic;	-- Signal which it should mark the output
				Cout: out std_logic_vector(3 downto 0));
end Counter4Bit;

architecture count_arch of Counter4Bit is
	signal count : std_logic_vector(3 downto 0);
	signal o : std_logic;
begin
	process(rst, clk, load)
	begin
		
		if (rst = '0') then	--Check for Reset
			count <= "0000";
			o <= '0';
		
		elsif(load='0' and Cin<=bound) then	--Check for Load
			count<= Cin;
		elsif (clk'event and clk = '1' and count=bound) then -- Check if the count reached the specified input
			count <= "0000";												-- Then Reset
			o <= '1';
		elsif (clk'event and clk = '1') then	-- Count up for each clock cycle
			count <= count + '1';
			o <= '0';
		end if;
	end process;
	X <= o;
	Cout<=count;
end count_arch;
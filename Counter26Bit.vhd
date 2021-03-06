library ieee;

use ieee.std_logic_1164.all;

use ieee.std_logic_unsigned.all;

entity Counter26Bit is
		Port (rst,clk : in std_logic;
				sec1: out std_logic);
end Counter26Bit;

architecture design of Counter26Bit is
	signal count : std_logic_vector(25 downto 0);
	signal o : std_logic;
begin
	process(rst,clk)
	begin
		if (rst = '0') then
			count <= "00000000000000000000000000";
			o<= '0';
		elsif (clk'event and clk = '1') then
			if (count="10111110101111000001111111") then --   starting from 0 to 49,999,999 -- 10111110101111000001111111 -- FOR SPEED: 00000000000100001001000000
				o<= '1';
				count <= "00000000000000000000000000";
			else
				count <= count + '1';
				o<= '0';
			end if;
		end if;
	end process;
	sec1 <= o;
end design;
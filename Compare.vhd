library ieee;

use ieee.std_logic_1164.all;

use ieee.std_logic_unsigned.all;

entity Compare is
		Port (ValIn: in std_logic_vector(3 downto 0);
				Limit: in std_logic_vector(3 downto 0);
				ValOut: out std_logic_vector(3 downto 0));
end Compare;

architecture design of Compare is
	
begin
	process(ValIn, Limit)
	begin
	
		if(Limit >= "0010") then	--if 20:00:00
			if(ValIn<="0011")then	--if 2X:00:00 where X is (3,2,1,0)
				ValOut <= ValIn;
			end if;
		else
			ValOut <= ValIn;
		end if;
	end process;
	
end design;
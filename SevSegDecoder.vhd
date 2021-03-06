library ieee;
use ieee.std_logic_1164.all;

entity SevSegDecoder is 
			port (Num: in std_logic_vector(3 downto 0);
					HEX: out std_logic_vector(6 downto 0) );
end SevSegDecoder ;


architecture LogicFunction of SevSegDecoder is
begin

	process(Num)
	begin
		
		case Num is
		-- For 0
		when "0000" =>
			HEX <= "1000000";
		-- For 1
		when "0001" =>
			HEX <= "1111001";
		-- For 2
		when "0010" =>
			HEX <= "0100100";
		-- For 3
		when "0011" =>
			HEX <= "0110000";
		-- For 4
		when "0100" =>
			HEX <= "0011001";
		-- For 5
		when "0101" =>
			HEX <= "0010010";
		-- For 6
		when "0110" =>
			HEX <= "0000010";
		-- For 7
		when "0111" =>
			HEX <= "1111000";
		-- For 8
		when "1000" =>
			HEX <= "0000000";
		-- For 9
		when "1001" =>
			HEX <= "0011000";
		-- For A
		when "1010" =>
			HEX <= "0001000";
		-- For B
		when "1011" =>
			HEX <= "0000011";
		-- For C
		when "1100" =>
			HEX <= "1000110";
		-- For D
		when "1101" =>
			HEX <= "0100001";
		-- For E
		when "1110" =>
			HEX <= "0000110";	
		-- For F
		when "1111" =>
			HEX <= "0001110";
		-- OFF all 1s
		when others =>
			HEX <= "1111111";
		end case;
	end process;
end LogicFunction;
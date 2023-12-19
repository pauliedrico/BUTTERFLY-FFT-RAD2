library ieee;
use ieee.std_logic_1164.all;

entity ROM_ROUND is
port(
	CLK: in std_logic;
	ADD: in std_logic_vector(3 downto 0);
	EN: in std_logic;
	Q: out std_logic_vector(2 downto 0)
);
end entity;

architecture behavioral of ROM_ROUND is

begin

process(CLK)
begin

if(rising_edge(CLK) and EN='1') then
	case ADD is
      		when "0000" => Q <= "000"; 
		when "0001" => Q <= "001";
        	when "0010" => Q <= "001";
		when "0011" => Q <= "010";
		when "0100" => Q <= "010";
		when "0101" => Q <= "011";
		when "0110" => Q <= "011";
		when "0111" => Q <= "100";
		when "1000" => Q <= "100";
		when "1001" => Q <= "100";
		when "1010" => Q <= "101";
		when "1011" => Q <= "101";
		when "1100" => Q <= "110";
		when "1101" => Q <= "110";
		when "1110" => Q <= "111";
		when "1111" => Q <= "111";
		when others =>
    	end case;
end if;
	
end process;

end behavioral;

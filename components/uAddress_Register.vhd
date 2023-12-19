library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uAddress_Register is
generic(
	N: integer := 8
);
port(
	CLK,RST: IN STD_LOGIC;
	Input: IN STD_LOGIC_vector(N downto 0);
	Output: OUT STD_LOGIC_vector(N downto 0)
);
end uAddress_Register;

architecture behavioral of uAddress_Register is
begin
process(CLK,RST)
	begin
		if(RST='0') then 
			Output<=(others=>'0');
		elsif(falling_edge(clk)) then
			Output<=Input;
		end if;
end process;
end behavioral;
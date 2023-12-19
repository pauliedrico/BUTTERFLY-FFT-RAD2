library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Late_Status_PLA is
port(
	Status_START: IN STD_LOGIC;
	CC: IN STD_LOGIC;
	LSB: IN STD_LOGIC;
	CC_Validation: OUT STD_LOGIC;
	Out_LSP: OUT STD_LOGIC
);
end Late_Status_PLA;

architecture behavioral of Late_Status_PLA is
begin
process(Status_START,LSB,CC)
	begin
		if CC='0' then 
			Out_LSP<=LSB;
			CC_Validation<='0';
		else
			if(Status_START='1')then
				CC_Validation<='1';
				Out_LSP<='1';
			else
				CC_Validation<='0';
				Out_LSP<='0';
			end if;
		end if;
end process;
end behavioral;
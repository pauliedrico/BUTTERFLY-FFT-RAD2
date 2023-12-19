library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PIPE_ADDER is
port(
	CLK,RST,ADD_nDIFF: IN STD_LOGIC;
	A: IN std_logic_vector(32 downto 0);
	B: IN std_logic_vector(32 downto 0);
	SUM: OUT std_logic_vector(32 downto 0) 
);
end PIPE_ADDER;

architecture behavioral of PIPE_ADDER is

signal a_signed, b_signed: signed(32 downto 0);
signal a_signed_resize, b_signed_resize: signed(32 downto 0);
signal sum_signed, sum_pipe: signed(32 downto 0);

begin

a_signed<=signed(A);
b_signed<=signed(B);
a_signed_resize<=resize(a_signed,33);
b_signed_resize<=resize(b_signed,33);

SUM<=std_logic_vector(sum_signed);

sum_output: process(CLK)
	begin
	if(CLK'event and CLK='1') then
		if(RST='1') then 
			sum_pipe<=(others=>'0');
			sum_signed<=(others=>'0');
		else
			if(ADD_nDIFF='1') then
				sum_pipe<=a_signed_resize+b_signed_resize;
				sum_signed<=sum_pipe;
			else
				sum_pipe<=a_signed_resize-b_signed_resize;
				sum_signed<=sum_pipe;
			end if;
		end if;
	end if;	
end process;
end behavioral;

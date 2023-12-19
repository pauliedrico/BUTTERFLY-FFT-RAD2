library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PIPE_MULT is
port(
	CLK, RST, MULT_nSHIFT: IN STD_LOGIC;
	A,B: IN std_logic_vector(15 downto 0);
	MULT_OUT: OUT std_logic_vector(30 downto 0);
	SHIFT_OUT: OUT std_logic_vector(16 downto 0)
);
end PIPE_MULT;

architecture behavioral of PIPE_MULT is

signal a_signed, b_signed: signed(15 downto 0);
signal mult_out_signed, mult_pipe: signed(30 downto 0); -- (2n-1) bit perche' -1<A<1 e -1<B<1

begin

a_signed<=signed(A);
b_signed<=signed(B);
MULT_OUT<=std_logic_vector(mult_out_signed);

out_MULT: process(CLK)
	begin

	if(CLK'event and CLK='1') then
		if(RST='1') then
			mult_pipe<=(others=>'0');
			mult_out_signed<=(others=>'0');
			SHIFT_OUT<=(others=>'0');
		else
			if(MULT_nSHIFT='1') then
				mult_pipe<=resize(a_signed*b_signed,31);
				mult_out_signed<=mult_pipe; -- il tool di sintesi è in grado di ridistribuire autonomamente la rete logica in due parti uguali
			else
				mult_out_signed<=mult_pipe;
				SHIFT_OUT<=A&'0';
			end if;
		end if;
	end if;	

	end process;

end behavioral;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;

ENTITY tb_PIPE_ADDER IS
END tb_PIPE_ADDER;

ARCHITECTURE functional OF tb_PIPE_ADDER IS
	
COMPONENT PIPE_ADDER IS
port(
	CLK,RST,ADD_nDIFF: IN STD_LOGIC;
	A: IN std_logic_vector(32 downto 0);
	B: IN std_logic_vector(32 downto 0);
	SUM: OUT std_logic_vector(32 downto 0) 
);
END COMPONENT;
	
SIGNAL clk_tb,rst_tb,add_ndiff_tb: STD_LOGIC;
SIGNAL a_tb,b_tb: std_logic_vector(32 downto 0);
SIGNAL sum_tb: std_logic_vector(32 downto 0);

-- definisco segnali sfixed per semplificarmi il testing  

SIGNAL a_tb_sfixed, b_tb_sfixed: sfixed(2 downto -30);
SIGNAL sum_tb_sfixed: sfixed(2 downto -30);
		
BEGIN

-- assegno segnali x test in waveform
a_tb_sfixed<=to_sfixed(a_tb,a_tb_sfixed);
b_tb_sfixed<=to_sfixed(b_tb,b_tb_sfixed);

sum_tb_sfixed<=to_sfixed(sum_tb,sum_tb_sfixed);
	
clock: PROCESS
	begin
	clk_tb <= '0', '1' after 5 ns;
    	WAIT FOR 10 ns;
	END PROCESS clock;
		
reset: PROCESS
	BEGIN
	rst_tb<='1','0' after 30 ns;
	WAIT FOR 500 ns;    	
	END PROCESS reset;

op_mode: PROCESS
	BEGIN
	add_ndiff_tb<='1','0' after 500 ns;
	WAIT FOR 1000 ns;
	END PROCESS op_mode;

input:	PROCESS
	BEGIN
	a_tb<=std_logic_vector(to_sfixed(-2.99,a_tb_sfixed)), std_logic_vector(to_sfixed(-0.589,a_tb_sfixed)) after 57 ns, std_logic_vector(to_sfixed(+0.9999,a_tb_sfixed)) after 77 ns;
	b_tb<=std_logic_vector(to_sfixed(-0.99,b_tb_sfixed)), std_logic_vector(to_sfixed(+1.555,b_tb_sfixed)) after 57 ns, std_logic_vector(to_sfixed(+2.4,b_tb_sfixed)) after 77 ns;
	WAIT FOR 500 ns;		
	END PROCESS input;
		
adder_mapping: PIPE_ADDER PORT MAP (clk_tb, rst_tb, add_ndiff_tb, a_tb, b_tb, sum_tb);
	
END functional;


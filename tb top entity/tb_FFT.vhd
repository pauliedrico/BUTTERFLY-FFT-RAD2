library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;

entity tb_FFT is
end entity;

architecture behavioral of tb_FFT is

component FFT is
	port
	(
		clk		: in std_logic;
		X0_R,X0_I,X1_R,X1_I,X2_R,X2_I,X3_R,X3_I,X4_R,X4_I,X5_R,X5_I,X6_R,X6_I,X7_R,X7_I,X8_R,X8_I: in std_logic_vector(15 downto 0);
		X9_R,X9_I,X10_R,X10_I,X11_R,X11_I,X12_R,X12_I,X13_R,X13_I,X14_R,X14_I,X15_R,X15_I: in std_logic_vector(15 downto 0);
		START : in std_logic;
		RST   : in std_logic;
		X0_R_OUT,X0_I_OUT,X1_R_OUT,X1_I_OUT,X2_R_OUT,X2_I_OUT,X3_R_OUT,X3_I_OUT,X4_R_OUT,X4_I_OUT,X5_R_OUT,X5_I_OUT,X6_R_OUT,X6_I_OUT,X7_R_OUT,X7_I_OUT,X8_R_OUT,X8_I_OUT: OUT std_logic_vector(15 downto 0);
		X9_R_OUT,X9_I_OUT,X10_R_OUT,X10_I_OUT,X11_R_OUT,X11_I_OUT,X12_R_OUT,X12_I_OUT,X13_R_OUT,X13_I_OUT,X14_R_OUT,X14_I_OUT,X15_R_OUT,X15_I_OUT: OUT std_logic_vector(15 downto 0);
		DONE:	 OUT std_logic
	);
end component;

signal clk_tb: std_logic;

signal X0_R_tb,X0_I_tb,X1_R_tb,X1_I_tb,X2_R_tb,X2_I_tb,X3_R_tb,X3_I_tb,X4_R_tb,X4_I_tb,X5_R_tb,X5_I_tb,X6_R_tb,X6_I_tb,X7_R_tb,X7_I_tb,X8_R_tb,X8_I_tb: std_logic_vector(15 downto 0);
signal X9_R_tb,X9_I_tb,X10_R_tb,X10_I_tb,X11_R_tb,X11_I_tb,X12_R_tb,X12_I_tb,X13_R_tb,X13_I_tb,X14_R_tb,X14_I_tb,X15_R_tb,X15_I_tb: std_logic_vector(15 downto 0);
signal X0_R_out_tb,X0_I_out_tb,X1_R_out_tb,X1_I_out_tb,X2_R_out_tb,X2_I_out_tb,X3_R_out_tb,X3_I_out_tb,X4_R_out_tb,X4_I_out_tb,X5_R_out_tb,X5_I_out_tb,X6_R_out_tb,X6_I_out_tb,X7_R_out_tb,X7_I_out_tb,X8_R_out_tb,X8_I_out_tb: std_logic_vector(15 downto 0);
signal X9_R_out_tb,X9_I_out_tb,X10_R_out_tb,X10_I_out_tb,X11_R_out_tb,X11_I_out_tb,X12_R_out_tb,X12_I_out_tb,X13_R_out_tb,X13_I_out_tb,X14_R_out_tb,X14_I_out_tb,X15_R_out_tb,X15_I_out_tb: std_logic_vector(15 downto 0);
signal X0_R_sfixed,X0_I_sfixed,X1_R_sfixed,X1_I_sfixed,X2_R_sfixed,X2_I_sfixed,X3_R_sfixed,X3_I_sfixed,X4_R_sfixed,X4_I_sfixed,X5_R_sfixed,X5_I_sfixed,X6_R_sfixed,X6_I_sfixed,X7_R_sfixed,X7_I_sfixed,X8_R_sfixed,X8_I_sfixed: sfixed(0 downto -15);
signal X9_R_sfixed,X9_I_sfixed,X10_R_sfixed,X10_I_sfixed,X11_R_sfixed,X11_I_sfixed,X12_R_sfixed,X12_I_sfixed,X13_R_sfixed,X13_I_sfixed,X14_R_sfixed,X14_I_sfixed,X15_R_sfixed,X15_I_sfixed: sfixed(0 downto -15);
signal X0_R_out_sfixed,X0_I_out_sfixed,X1_R_out_sfixed,X1_I_out_sfixed,X2_R_out_sfixed,X2_I_out_sfixed,X3_R_out_sfixed,X3_I_out_sfixed,X4_R_out_sfixed,X4_I_out_sfixed,X5_R_out_sfixed,X5_I_out_sfixed,X6_R_out_sfixed,X6_I_out_sfixed,X7_R_out_sfixed,X7_I_out_sfixed,X8_R_out_sfixed,X8_I_out_sfixed: sfixed(5 downto -10);
signal X9_R_out_sfixed,X9_I_out_sfixed,X10_R_out_sfixed,X10_I_out_sfixed,X11_R_out_sfixed,X11_I_out_sfixed,X12_R_out_sfixed,X12_I_out_sfixed,X13_R_out_sfixed,X13_I_out_sfixed,X14_R_out_sfixed,X14_I_out_sfixed,X15_R_out_sfixed,X15_I_out_sfixed: sfixed(5 downto -10);
signal START_tb :std_logic;
signal RST_tb  :std_logic;
signal DONE_tb  :std_logic;

begin
X0_R_tb<=to_slv(X0_R_sfixed); X0_I_tb<=to_slv(X0_I_sfixed);
X1_R_tb<=to_slv(X1_R_sfixed); X1_I_tb<=to_slv(X1_I_sfixed);
X2_R_tb<=to_slv(X2_R_sfixed); X2_I_tb<=to_slv(X2_I_sfixed);
X3_R_tb<=to_slv(X3_R_sfixed); X3_I_tb<=to_slv(X3_I_sfixed);
X4_R_tb<=to_slv(X4_R_sfixed); X4_I_tb<=to_slv(X4_I_sfixed);
X5_R_tb<=to_slv(X5_R_sfixed); X5_I_tb<=to_slv(X5_I_sfixed);
X6_R_tb<=to_slv(X6_R_sfixed); X6_I_tb<=to_slv(X6_I_sfixed);
X7_R_tb<=to_slv(X7_R_sfixed); X7_I_tb<=to_slv(X7_I_sfixed);
X8_R_tb<=to_slv(X8_R_sfixed); X8_I_tb<=to_slv(X8_I_sfixed);
X9_R_tb<=to_slv(X9_R_sfixed); X9_I_tb<=to_slv(X9_I_sfixed);
X10_R_tb<=to_slv(X10_R_sfixed); X10_I_tb<=to_slv(X10_I_sfixed);
X11_R_tb<=to_slv(X11_R_sfixed); X11_I_tb<=to_slv(X11_I_sfixed);
X12_R_tb<=to_slv(X12_R_sfixed); X12_I_tb<=to_slv(X12_I_sfixed);
X13_R_tb<=to_slv(X13_R_sfixed); X13_I_tb<=to_slv(X13_I_sfixed);
X14_R_tb<=to_slv(X14_R_sfixed); X14_I_tb<=to_slv(X14_I_sfixed);
X15_R_tb<=to_slv(X15_R_sfixed); X15_I_tb<=to_slv(X15_I_sfixed);
X0_R_out_sfixed<=to_sfixed(X0_R_out_tb,X0_R_out_sfixed); X0_I_out_sfixed<=to_sfixed(X0_I_out_tb,X0_I_out_sfixed);
X1_R_out_sfixed<=to_sfixed(X1_R_out_tb,X1_R_out_sfixed); X1_I_out_sfixed<=to_sfixed(X1_I_out_tb,X1_I_out_sfixed);
X2_R_out_sfixed<=to_sfixed(X2_R_out_tb,X2_R_out_sfixed); X2_I_out_sfixed<=to_sfixed(X2_I_out_tb,X2_I_out_sfixed);
X3_R_out_sfixed<=to_sfixed(X3_R_out_tb,X3_R_out_sfixed); X3_I_out_sfixed<=to_sfixed(X3_I_out_tb,X3_I_out_sfixed);
X4_R_out_sfixed<=to_sfixed(X4_R_out_tb,X4_R_out_sfixed); X4_I_out_sfixed<=to_sfixed(X4_I_out_tb,X4_I_out_sfixed);
X5_R_out_sfixed<=to_sfixed(X5_R_out_tb,X5_R_out_sfixed); X5_I_out_sfixed<=to_sfixed(X5_I_out_tb,X5_I_out_sfixed);
X6_R_out_sfixed<=to_sfixed(X6_R_out_tb,X6_R_out_sfixed); X6_I_out_sfixed<=to_sfixed(X6_I_out_tb,X6_I_out_sfixed);
X7_R_out_sfixed<=to_sfixed(X7_R_out_tb,X7_R_out_sfixed); X7_I_out_sfixed<=to_sfixed(X7_I_out_tb,X7_I_out_sfixed);
X8_R_out_sfixed<=to_sfixed(X8_R_out_tb,X8_R_out_sfixed); X8_I_out_sfixed<=to_sfixed(X8_I_out_tb,X8_I_out_sfixed);
X9_R_out_sfixed<=to_sfixed(X9_R_out_tb,X9_R_out_sfixed); X9_I_out_sfixed<=to_sfixed(X9_I_out_tb,X9_I_out_sfixed);
X10_R_out_sfixed<=to_sfixed(X10_R_out_tb,X10_R_out_sfixed); X10_I_out_sfixed<=to_sfixed(X10_I_out_tb,X10_I_out_sfixed);
X11_R_out_sfixed<=to_sfixed(X11_R_out_tb,X11_R_out_sfixed); X11_I_out_sfixed<=to_sfixed(X11_I_out_tb,X11_I_out_sfixed);
X12_R_out_sfixed<=to_sfixed(X12_R_out_tb,X12_R_out_sfixed); X12_I_out_sfixed<=to_sfixed(X12_I_out_tb,X12_I_out_sfixed);
X13_R_out_sfixed<=to_sfixed(X13_R_out_tb,X13_R_out_sfixed); X13_I_out_sfixed<=to_sfixed(X13_I_out_tb,X13_I_out_sfixed);
X14_R_out_sfixed<=to_sfixed(X14_R_out_tb,X14_R_out_sfixed); X14_I_out_sfixed<=to_sfixed(X14_I_out_tb,X14_I_out_sfixed);
X15_R_out_sfixed<=to_sfixed(X15_R_out_tb,X15_R_out_sfixed); X15_I_out_sfixed<=to_sfixed(X15_I_out_tb,X15_I_out_sfixed);


FFT_prova :FFT
port map(clk_tb,X0_R_tb,X0_I_tb,X1_R_tb,X1_I_tb,X2_R_tb,X2_I_tb,X3_R_tb,X3_I_tb,X4_R_tb,X4_I_tb,X5_R_tb,X5_I_tb,X6_R_tb,X6_I_tb,X7_R_tb,X7_I_tb,X8_R_tb,X8_I_tb,
		 X9_R_tb,X9_I_tb,X10_R_tb,X10_I_tb,X11_R_tb,X11_I_tb,X12_R_tb,X12_I_tb,X13_R_tb,X13_I_tb,X14_R_tb,X14_I_tb,X15_R_tb,X15_I_tb,START_tb,RST_tb,
		 X0_R_out_tb,X0_I_out_tb,X1_R_out_tb,X1_I_out_tb,X2_R_out_tb,X2_I_out_tb,X3_R_out_tb,X3_I_out_tb,X4_R_out_tb,X4_I_out_tb,X5_R_out_tb,X5_I_out_tb,X6_R_out_tb,X6_I_out_tb,X7_R_out_tb,X7_I_out_tb,X8_R_out_tb,X8_I_out_tb,
		 X9_R_out_tb,X9_I_out_tb,X10_R_out_tb,X10_I_out_tb,X11_R_out_tb,X11_I_out_tb,X12_R_out_tb,X12_I_out_tb,X13_R_out_tb,X13_I_out_tb,X14_R_out_tb,X14_I_out_tb,X15_R_out_tb,X15_I_out_tb,DONE_tb
		);


clock: PROCESS
		BEGIN
			clk_tb<='0';
			WAIT FOR 10 ns;
			clk_tb<='1';
			WAIT FOR 10 ns;
		END PROCESS clock;
		
start: process
begin
		START_tb<='0';
		wait for 100 ns;
		START_tb<='1';
		wait for 30 ns;
end process;
		
ciclo: PROCESS
			BEGIN			
				RST_tb<='0';
				wait for 50 ns;
				RST_tb<='1';
				X0_R_sfixed<= to_sfixed(1,X0_R_sfixed); X0_I_sfixed<= to_sfixed(0,X0_I_sfixed);
				X1_R_sfixed<= to_sfixed(1,X1_R_sfixed); X1_I_sfixed<= to_sfixed(0,X1_I_sfixed);
				X2_R_sfixed<= to_sfixed(1,X2_R_sfixed); X2_I_sfixed<= to_sfixed(0,X2_I_sfixed);
				X3_R_sfixed<= to_sfixed(1,X3_R_sfixed); X3_I_sfixed<= to_sfixed(0,X3_I_sfixed);
				X4_R_sfixed<= to_sfixed(1,X4_R_sfixed); X4_I_sfixed<= to_sfixed(0,X4_I_sfixed);
				X5_R_sfixed<= to_sfixed(1,X5_R_sfixed); X5_I_sfixed<= to_sfixed(0,X5_I_sfixed);
				X6_R_sfixed<= to_sfixed(1,X6_R_sfixed); X6_I_sfixed<= to_sfixed(0,X6_I_sfixed);
				X7_R_sfixed<= to_sfixed(1,X7_R_sfixed); X7_I_sfixed<= to_sfixed(0,X7_I_sfixed);
				X8_R_sfixed<= to_sfixed(1,X8_R_sfixed); X8_I_sfixed<= to_sfixed(0,X8_I_sfixed);
				X9_R_sfixed<= to_sfixed(1,X9_R_sfixed); X9_I_sfixed<= to_sfixed(0,X9_I_sfixed);
				X10_R_sfixed<= to_sfixed(1,X10_R_sfixed); X10_I_sfixed<= to_sfixed(0,X10_I_sfixed);
				X11_R_sfixed<= to_sfixed(1,X11_R_sfixed); X11_I_sfixed<= to_sfixed(0,X11_I_sfixed);
				X12_R_sfixed<= to_sfixed(1,X12_R_sfixed); X12_I_sfixed<= to_sfixed(0,X12_I_sfixed);
				X13_R_sfixed<= to_sfixed(1,X13_R_sfixed); X13_I_sfixed<= to_sfixed(0,X13_I_sfixed);
				X14_R_sfixed<= to_sfixed(1,X14_R_sfixed); X14_I_sfixed<= to_sfixed(0,X14_I_sfixed);
				X15_R_sfixed<= to_sfixed(1,X15_R_sfixed); X15_I_sfixed<= to_sfixed(0,X15_I_sfixed);
				wait for 1 ms;

		END PROCESS ciclo;


end architecture;
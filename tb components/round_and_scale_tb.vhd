library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE IEEE.fixed_pkg.all;

entity round_and_scale_tb is
end entity; 


architecture behavioral of round_and_scale_tb is

component round_and_scale is
	port
	(
		clk		: in std_logic;
		block_in	: in std_logic_vector(16 downto 0);
		enable:	 in std_logic;
		SF_2h_1l : in std_logic;
		block_out : out std_logic_vector(15 downto 0)
	);
end component; 


signal 	clk_tb	: std_logic;
signal 	block_in_tb	: std_logic_vector(16 downto 0);
signal block_in_sfixed: sfixed(2 downto -14);
signal	enable_tb: std_logic;
signal	SF_2h_1l_tb : std_logic;
signal	block_out_tb : std_logic_vector(15 downto 0);

SIGNAL block_out_tb_sfixed: sfixed(2 downto -13);
		
BEGIN

-- assegno segnali x test in waveform
block_in_sfixed<=to_sfixed(block_in_tb,block_in_sfixed);
block_out_tb_sfixed<=to_sfixed(block_out_tb,block_out_tb_sfixed);

Round_and_scale_prova:round_and_scale
port map(CLK=>clk_tb,block_in=>block_in_tb,enable=>enable_tb,SF_2h_1l=>SF_2h_1l_tb,block_out=>block_out_tb);

clock: PROCESS
		BEGIN
			clk_tb<='0';
			WAIT FOR 10 ns;
			clk_tb<='1';
			WAIT FOR 10 ns;
		END PROCESS clock;
		
ciclo: PROCESS
			BEGIN
				enable_tb<='1';
				block_in_tb<=std_logic_vector(to_sfixed(2,block_in_sfixed));
				SF_2h_1l_tb<='0';
				WAIT FOR 23 ns;
				block_in_tb<=std_logic_vector(to_sfixed(0.4235452,block_in_sfixed));
				WAIT FOR 20 ns;
				block_in_tb<=std_logic_vector(to_sfixed(-0.234156,block_in_sfixed));
				WAIT FOR 20 ns;
				block_in_tb<=std_logic_vector(to_sfixed(-1.34243546,block_in_sfixed));
				WAIT FOR 20 ns;
		END PROCESS ciclo;

end architecture;

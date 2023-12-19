library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;

entity Butterfly_tb is
end entity;

architecture behavioral of Butterfly_tb is

component Butterfly is
	port
	(
		clk		: in std_logic;
		Ar	: in std_logic_vector(15 downto 0);
		Ai	: in std_logic_vector(15 downto 0);
		Br	: in std_logic_vector(15 downto 0);
		Bi	: in std_logic_vector(15 downto 0);
		Wr	: in std_logic_vector(15 downto 0);
		Wi	: in std_logic_vector(15 downto 0);
		START : in std_logic;
		RST   : in std_logic;
		SF_2h_1l: in std_logic;
		Ar_out : buffer std_logic_vector(15 downto 0);
		Ai_out : buffer std_logic_vector(15 downto 0);
		Br_out : buffer std_logic_vector(15 downto 0);
		Bi_out : buffer std_logic_vector(15 downto 0);
		DONE:	 OUT std_logic
	);
end component;

signal clk_tb: std_logic;
signal Ar_tb	:std_logic_vector(15 downto 0);
signal Ai_tb	:std_logic_vector(15 downto 0);
signal Br_tb	:std_logic_vector(15 downto 0);
signal Bi_tb	:std_logic_vector(15 downto 0);
signal Wr_tb	:std_logic_vector(15 downto 0);
signal Wi_tb	:std_logic_vector(15 downto 0);
signal Ar_tb_sfixed	:sfixed(0 downto -15);
signal Ai_tb_sfixed	:sfixed(0 downto -15);
signal Br_tb_sfixed	:sfixed(0 downto -15);
signal Bi_tb_sfixed	:sfixed(0 downto -15);
signal Wr_tb_sfixed	:sfixed(0 downto -15);
signal Wi_tb_sfixed	:sfixed(0 downto -15);
signal START_tb :std_logic;
signal RST_tb   :std_logic;
signal SF_2h_1l_tb:std_logic;
signal Ar_out_tb :std_logic_vector(15 downto 0);
signal Ai_out_tb :std_logic_vector(15 downto 0);
signal Br_out_tb :std_logic_vector(15 downto 0);
signal Bi_out_tb :std_logic_vector(15 downto 0);
signal Ar_out_tb_sfixed	 :sfixed(2 downto -13);
signal Ai_out_tb_sfixed	 :sfixed(2 downto -13);
signal Br_out_tb_sfixed	 :sfixed(2 downto -13);
signal Bi_out_tb_sfixed	 :sfixed(2 downto -13);
signal DONE_tb   :std_logic;

begin
Butterfly_prova :Butterfly
port map(clk=>clk_tb,Ar=>Ar_tb,Ai=>Ai_tb,Br=>Br_tb,Bi=>Bi_tb,Wr=>Wr_tb,Wi=>Wi_tb,START=>START_tb,RST=>RST_tb,SF_2h_1l=>SF_2h_1l_tb,Ar_out=>Ar_out_tb,Ai_out=>Ai_out_tb,Br_out=>Br_out_tb,Bi_out=>Bi_out_tb,DONE=>DONE_tb);


Ar_tb<=to_slv(Ar_tb_sfixed);
Ai_tb<=to_slv(Ai_tb_sfixed);
Br_tb<=to_slv(Br_tb_sfixed);
Bi_tb<=to_slv(Bi_tb_sfixed);
Wr_tb<=to_slv(Wr_tb_sfixed);
Wi_tb<=to_slv(Wi_tb_sfixed);

Ar_out_tb_sfixed<=to_sfixed(Ar_out_tb,Ar_out_tb_sfixed);
Ai_out_tb_sfixed<=to_sfixed(Ai_out_tb,Ai_out_tb_sfixed);
Br_out_tb_sfixed<=to_sfixed(Br_out_tb,Br_out_tb_sfixed);
Bi_out_tb_sfixed<=to_sfixed(Bi_out_tb,Bi_out_tb_sfixed);

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
		wait for 500 ns;
		START_tb<='1';
		wait for 200 ns;
end process;
		
ciclo: PROCESS
			BEGIN			
				RST_tb<='1';
				SF_2h_1l_tb<='1';
				wait for 50 ns;
				START_tb<='1';
				Ar_tb_sfixed<= (to_sfixed(-0.4242,Ar_tb_sfixed));
				Ai_tb_sfixed<= (to_sfixed(0.53523,Ai_tb_sfixed));
				Br_tb_sfixed<= (to_sfixed(0.3421233,Br_tb_sfixed));
				Bi_tb_sfixed<= (to_sfixed(-0.3243652,Bi_tb_sfixed));
				Wr_tb_sfixed<= (to_sfixed(0.5,Wr_tb_sfixed));
				Wi_tb_sfixed<= (to_sfixed(-0.5,Wi_tb_sfixed));
				wait for 50 ns;
				Ar_tb_sfixed<= (to_sfixed(-0.102222,Ar_tb_sfixed));
				Ai_tb_sfixed<= (to_sfixed(0.342243,Ai_tb_sfixed));
				Br_tb_sfixed<= (to_sfixed(-0.111111,Br_tb_sfixed));
				Bi_tb_sfixed<= (to_sfixed(-0.543332,Bi_tb_sfixed));
				Wr_tb_sfixed<= (to_sfixed(0.234,Wr_tb_sfixed));
				Wi_tb_sfixed<= (to_sfixed(-0.8764,Wi_tb_sfixed));
				wait for 50 ns;

		END PROCESS ciclo;

end architecture;
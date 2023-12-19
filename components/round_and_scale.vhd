library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity round_and_scale is
	port
	(
		clk		: in std_logic;
		block_in	: in std_logic_vector(16 downto 0);
		enable:	 in std_logic;
		SF_2h_1l : in std_logic;
		block_out : out std_logic_vector(15 downto 0)
	);
end entity; 


architecture behavioral of round_and_scale  is

component ROM_ROUND is
	port(
		CLK: in std_logic;
		ADD: in std_logic_vector(3 downto 0);
		EN: in std_logic;
		Q: out std_logic_vector(2 downto 0)
	);
end component;

signal Q_Round	: std_logic_vector(2 downto 0);
signal Round_out: std_logic_vector(15 downto 0);

begin

Rom_prova:ROM_ROUND
port map(CLK=>clk,ADD=>block_in(3 downto 0),EN=>enable,Q=>Q_Round);

assign: process(clk)
begin
	if(rising_edge(clk)) then
		Round_out(15 downto 3)<=block_in(16 downto 4);
	end if;
end process;

Round_out(2 downto 0)<=Q_Round;

scale: process(Round_out,SF_2h_1l)
begin
	if SF_2h_1l='0' then
		block_out<=Round_out(15) & Round_out(15 downto 1);
	else
		block_out<=Round_out(15) & Round_out(15) & Round_out(15 downto 2);		
	end if;
end process; 
end architecture;

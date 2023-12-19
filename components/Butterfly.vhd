library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;

entity Butterfly is
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
end entity;

architecture behavioral of Butterfly  is

component PIPE_MULT is
port(
	CLK, RST, MULT_nSHIFT: IN STD_LOGIC;
	A,B: IN std_logic_vector(15 downto 0);
	MULT_OUT: OUT std_logic_vector(30 downto 0);
	SHIFT_OUT: OUT std_logic_vector(16 downto 0)
);
end component;

component PIPE_ADDER is
port(
	CLK,RST,ADD_nDIFF: IN STD_LOGIC;
	A: IN std_logic_vector(32 downto 0);
	B: IN std_logic_vector(32 downto 0);
	SUM: OUT std_logic_vector(32 downto 0) 
);
end component;

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

component CU is
port(
	CLK: IN STD_LOGIC;
	START: IN STD_LOGIC;
	RST: IN STD_LOGIC;
	MULT_nSHIFT: out std_logic;
	ADD_nDIFF : out std_logic;
	ROUND_EN : out std_logic;
	sel1 : out std_logic;
	sel2 : out std_logic;
	sel3 : out std_logic;
	sel4 : out std_logic;
	sel5 : out std_logic;
	sel6 : out std_logic;
	sel7 : out std_logic;
	DONE:out std_logic;
	RST_B: out std_logic;
	LE_AR_OUT,LE_AI_OUT,LE_BR_OUT,LE_BI_OUT,LE_RF: out std_logic
);
end component;

----------------------------------------------------------------------------------------------------------------------------------
signal MULT_nSHIFT: std_logic;
signal MULT_OUT   : std_logic_vector(30 downto 0);
signal MULT_OUT_sfixed  : sfixed(0 downto -30);
signal SHIFT_OUT : std_logic_vector(16 downto 0);

signal ADD_nDIFF : std_logic;
signal SUM        : std_logic_vector(32 downto 0);

signal round_in   : std_logic_vector(16 downto 0);
signal round_out  : std_logic_vector(15 downto 0);
signal ROUND_EN   : std_logic;
signal scale_select   : std_logic;--S_2H_1L

signal sel1 : std_logic;
signal sel2 : std_logic;
signal sel3 : std_logic;
signal sel4 : std_logic;
signal sel5 : std_logic;
signal sel6 : std_logic;
signal sel7 : std_logic;
signal outmux1: std_logic_vector(15 downto 0);
signal outmux1_sfixed: sfixed(0 downto -15);
signal outmux2: std_logic_vector(15 downto 0);
signal outmux3: std_logic_vector(15 downto 0);
signal outmux4: std_logic_vector(15 downto 0);
signal outmux5: std_logic_vector(32 downto 0);
signal outmux6: std_logic_vector(32 downto 0);
signal outmux7: std_logic_vector(32 downto 0);
signal inmux5: std_logic_vector(32 downto 0);
signal inmux5_sfixed: sfixed(2 downto -30);
signal inmux6: std_logic_vector(32 downto 0);
signal inmux6_sfixed: sfixed(2 downto -30);
signal inmux7: std_logic_vector(32 downto 0);
signal inmux7_sfixed: sfixed(2 downto -30);

signal output_shift_register_sfixed : sfixed(1 downto -15);
signal RST_B:std_logic;
signal A_r,A_i,B_i,B_r,W_r,W_i: std_logic_vector(15 downto 0);
signal LE_AR_OUT,LE_AI_OUT,LE_BR_OUT,LE_BI_OUT,LE_RF: std_logic;

---------------------------------------------------------------------------------------------------------------------------

begin

Moltiplicatore:PIPE_MULT
port map(CLK=>clk,RST=>RST_B,MULT_nSHIFT=>MULT_nSHIFT,A=>outmux3,B=>outmux4,MULT_OUT=>MULT_OUT,SHIFT_OUT=>SHIFT_OUT);

Sommatore:PIPE_ADDER
port map(CLK=>clk,RST=>RST_B,ADD_nDIFF=>ADD_nDIFF,A=>outmux6,B=>outmux7,SUM=>SUM);

Rom_rounding: round_and_scale
port map(CLK=>clk,block_in=>round_in,enable=>ROUND_EN,SF_2h_1l=>scale_select,block_out=>round_out);

MUX1: process(A_r,A_i,sel1)
begin
if(sel1='0') then	
		outmux1<=A_r;
	else
		outmux1<=A_i;
	end if;
end process;

MUX2: process(B_r,B_i,sel2)
begin
if(sel2='0') then	
		outmux2<=B_r;
	else
		outmux2<=B_i;
	end if;
end process;

MUX3: process(outmux2,outmux1,sel3)
begin
if(sel3='0') then	
		outmux3<=outmux2;
	else
		outmux3<=outmux1;
	end if;
end process;

MUX4: process(W_r,W_i,sel4)
begin
if(sel4='0') then	
		outmux4<=W_r;
	else
		outmux4<=W_i;
	end if;
end process;

output_shift_register_sfixed<=to_sfixed(SHIFT_OUT,output_shift_register_sfixed);
inmux5_sfixed<=resize(output_shift_register_sfixed,inmux5_sfixed);
inmux5<=to_std_logic_vector(inmux5_sfixed);

MUX5:process(sum,inmux5,sel5)
begin
if(sel5='0') then	
		outmux5<=sum;
	else
		outmux5<=inmux5;
	end if;
end process;

outmux1_sfixed<=to_sfixed(outmux1,outmux1_sfixed);
inmux6_sfixed<=resize(outmux1_sfixed,inmux6_sfixed);
inmux6<=to_std_logic_vector(inmux6_sfixed);

MUX6:process(outmux5,inmux6,sel6)
begin
if(sel6='0') then	
		outmux6<=outmux5;
	else
		outmux6<=inmux6;
	end if;
end process;

MULT_OUT_sfixed<=to_sfixed(MULT_OUT,MULT_OUT_sfixed);
inmux7_sfixed<=resize(MULT_OUT_sfixed,inmux7_sfixed);
inmux7<=to_std_logic_vector(inmux7_sfixed);

MUX7:process(inmux7,SUM,sel7)
begin
if(sel7='0') then	
		outmux7<=inmux7;
	else
		outmux7<=SUM;
	end if;
end process;
   
round_in<=SUM(32 downto 16);
-------------------------------------------------------------------------------------------------------------------------

Control_Unit:CU
port map(CLK,START,RST,MULT_nSHIFT,ADD_nDIFF,ROUND_EN,sel1,sel2,sel3,sel4,sel5,sel6,sel7,DONE,RST_B,LE_AR_OUT,LE_AI_OUT,LE_BR_OUT,LE_BI_OUT,LE_RF);
-----------------------------------------------------------------------------------------
AR_IN_REG: process(clk)
begin
	if(clk'event and clk='1') then
		if(RST_B='1') then
			A_r<=(others=>'0');
		elsif(LE_RF='1') then
			A_r<=Ar;
		else
			A_r<=A_r;
		end if;
	end if;
end process;

AI_IN_REG: process(clk)
begin
	if(clk'event and clk='1') then
		if(RST_B='1') then
			A_i<=(others=>'0');
		elsif(LE_RF='1') then
			A_i<=Ai;
		else
			A_i<=A_i;
		end if;
	end if;
end process;

BR_IN_REG: process(clk)
begin
	if(clk'event and clk='1') then
		if(RST_B='1') then
			B_r<=(others=>'0');
		elsif(LE_RF='1') then
			B_r<=Br;
		else
			B_r<=B_r;
		end if;
	end if;
end process;

BI_IN_REG: process(clk)
begin
	if(clk'event and clk='1') then
		if(RST_B='1') then
			B_i<=(others=>'0');
		elsif(LE_RF='1') then
			B_i<=Bi;
		else
			B_i<=B_i;
		end if;
	end if;
end process;

WR_IN_REG: process(clk)
begin
	if(clk'event and clk='1') then
		if(RST_B='1') then
			W_r<=(others=>'0');
		elsif(LE_RF='1') then
			W_r<=Wr;
		else
			W_r<=W_r;
		end if;
	end if;
end process;

WI_IN_REG: process(clk)
begin
	if(clk'event and clk='1') then
		if(RST_B='1') then
			W_i<=(others=>'0');
		elsif(LE_RF='1') then
			W_i<=Wi;
		else
			W_i<=W_i;
		end if;
	end if;
end process;

AR_OUT_REG: process(clk)
begin
	if(clk'event and clk='1') then
		if(RST_B='1') then
			AR_OUT<=(others=>'0');
		elsif(LE_AR_OUT='1') then
			AR_OUT<=round_out;
		else
			AR_OUT<=AR_OUT;
		end if;
	end if;
end process;

AI_OUT_REG: process(clk)
begin
	if(clk'event and clk='1') then
		if(RST_B='1') then
			AI_OUT<=(others=>'0');
		elsif(LE_AI_OUT='1') then
			AI_OUT<=round_out;
		else
			AI_OUT<=AI_OUT;
		end if;
	end if;
end process;

BR_OUT_REG: process(clk)
begin
	if(clk'event and clk='1') then
		if(RST_B='1') then
			BR_OUT<=(others=>'0');
		elsif(LE_BR_OUT='1') then
			BR_OUT<=round_out;
		else
			BR_OUT<=BR_OUT;
		end if;
	end if;
end process;

BI_OUT_REG: process(clk)
begin
	if(clk'event and clk='1') then
		if(RST_B='1') then
			BI_OUT<=(others=>'0');
		elsif(LE_BI_OUT='1') then
			BI_OUT<=round_out;
		else
			BI_OUT<=BI_OUT;
		end if;
	end if;
end process;

campiona_S_2h_1l: process(clk)
begin
	if(rising_edge(clk)) then
	if(RST_B='1') then
		scale_select<='0';
	elsif(LE_RF='1') then
		scale_select<=SF_2h_1l;
	end if;
end if;
end process;

end architecture;

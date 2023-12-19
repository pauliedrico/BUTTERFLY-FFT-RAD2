library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CU is
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
end CU;

architecture behavioral of CU is

component Late_Status_PLA is
port(
	Status_START: IN STD_LOGIC;
	CC: IN STD_LOGIC;
	LSB: IN STD_LOGIC;
	CC_Validation: OUT STD_LOGIC;
	Out_LSP: OUT STD_LOGIC
);
end component;

component uAddress_Register is
generic(
	N: integer := 8
);
port(
	CLK,RST: IN STD_LOGIC;
	Input: IN STD_LOGIC_vector(N downto 0);
	Output: OUT STD_LOGIC_vector(N downto 0)
);
end component;

component uInstruction_Register is
generic(
	N: integer := 8
);
port(
	CLK,RST: IN STD_LOGIC;
	Input: IN STD_LOGIC_vector(N downto 0);
	Output: OUT STD_LOGIC_vector(N downto 0)
);
end component;

component uROM is
port(
	ADD: in std_logic_vector(3 downto 0);
	Q: out std_logic_vector(45 downto 0)
);
end component;

-------------------------------
signal CC   : std_logic;
signal LSB   : std_logic;
signal CC_Validation   : std_logic;
signal Out_LSP   : std_logic;

signal out_uAR:std_logic_vector(4 downto 0);
signal next_address:std_logic_vector(3 downto 0);

signal in_uIR:std_logic_vector(22 downto 0);

signal Q: std_logic_vector(45 downto 0);

signal out_MUX_CC :std_logic;
-------------------------------
begin

Status_PLA: Late_Status_PLA
port map(Status_START=>START,CC=>CC,LSB=>LSB,CC_Validation=>CC_Validation,Out_LSP=>Out_LSP);

ROM:uROM
port map(ADD=>out_uAR(4 downto 1),Q=>Q);

uAR: uAddress_Register
generic map(N=>4)
port map(CLK=>CLK,RST=>RST,Input(4 downto 1)=>next_address,Input(0)=>Out_LSP,Output=>out_uAR);

uIR: uInstruction_Register
generic map(N=>22)
port map(CLK=>CLK,RST=>RST,Input=>in_uIR,Output(22)=>CC,Output(21 downto 18)=>next_address,Output(17)=>LSB,Output(16)=>LE_RF,Output(15)=>sel1,Output(14)=>sel2,Output(13)=>sel3,
		 Output(12)=>sel4,Output(11)=>sel5,Output(10)=>sel6,Output(9)=>sel7,Output(8)=>MULT_nSHIFT,Output(7)=>ADD_nDIFF,Output(6)=>ROUND_EN,
		 Output(5)=>LE_AR_OUT,Output(4)=>LE_AI_OUT,Output(3)=>LE_BR_OUT,Output(2)=>LE_BI_OUT,Output(1)=>DONE,Output(0)=>RST_B);

MUX_CC: process(out_uAR(0),Out_LSP,CC_Validation)
begin
	if(CC_Validation='0') then
		out_MUX_CC<=out_uAR(0);
	else
		out_MUX_CC<=Out_LSP;
	end if;
end process;

MUX_uROM: process(Q,out_MUX_CC)
begin
	if(out_MUX_CC='0') then
		in_uIR<=Q(45 downto 23);
	else
		in_uIR<=Q(22 downto 0);
	end if;
end process;

end behavioral;
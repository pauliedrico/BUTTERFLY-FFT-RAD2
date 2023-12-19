library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;

entity FFT is
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
end entity;

architecture behavioral of FFT is

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

signal Wr0,Wr1,Wr2,Wr3,Wr4,Wr5,Wr6,Wr7 	:std_logic_vector(15 downto 0);
signal Wi0,Wi1,Wi2,Wi3,Wi4,Wi5,Wi6,Wi7 	:std_logic_vector(15 downto 0);
signal Wr0_sfixed,Wr1_sfixed,Wr2_sfixed,Wr3_sfixed,Wr4_sfixed,Wr5_sfixed,Wr6_sfixed,Wr7_sfixed :sfixed(0 downto -15);
signal Wi0_sfixed,Wi1_sfixed,Wi2_sfixed,Wi3_sfixed,Wi4_sfixed,Wi5_sfixed,Wi6_sfixed,Wi7_sfixed :sfixed(0 downto -15);
signal Y0_R,Y0_I,Y1_R,Y1_I,Y2_R,Y2_I,Y3_R,Y3_I,Y4_R,Y4_I,Y5_R,Y5_I,Y6_R,Y6_I,Y7_R,Y7_I,Y8_R,Y8_I:  std_logic_vector(15 downto 0);
signal Y9_R,Y9_I,Y10_R,Y10_I,Y11_R,Y11_I,Y12_R,Y12_I,Y13_R,Y13_I,Y14_R,Y14_I,Y15_R,Y15_I: std_logic_vector(15 downto 0);
signal Z0_R,Z0_I,Z1_R,Z1_I,Z2_R,Z2_I,Z3_R,Z3_I,Z4_R,Z4_I,Z5_R,Z5_I,Z6_R,Z6_I,Z7_R,Z7_I,Z8_R,Z8_I:  std_logic_vector(15 downto 0);
signal Z9_R,Z9_I,Z10_R,Z10_I,Z11_R,Z11_I,Z12_R,Z12_I,Z13_R,Z13_I,Z14_R,Z14_I,Z15_R,Z15_I: std_logic_vector(15 downto 0);
signal T0_R,T0_I,T1_R,T1_I,T2_R,T2_I,T3_R,T3_I,T4_R,T4_I,T5_R,T5_I,T6_R,T6_I,T7_R,T7_I,T8_R,T8_I:  std_logic_vector(15 downto 0);
signal T9_R,T9_I,T10_R,T10_I,T11_R,T11_I,T12_R,T12_I,T13_R,T13_I,T14_R,T14_I,T15_R,T15_I: std_logic_vector(15 downto 0);
SIGNAL DONE_STADIO_1, DONE_STADIO_2,DONE_STADIO_3: STD_LOGIC;

begin

Wr0_sfixed<= (to_sfixed(1,Wr0_sfixed));
Wi0_sfixed<= (to_sfixed(0,Wi0_sfixed));
Wr0<=to_slv(Wr0_sfixed);
Wi0<=to_slv(Wi0_sfixed);
Wr1_sfixed<= (to_sfixed(0.923879,Wr1_sfixed));
Wi1_sfixed<= (to_sfixed(-0.382683,Wi1_sfixed));
Wr1<=to_slv(Wr1_sfixed);
Wi1<=to_slv(Wi1_sfixed);
Wr2_sfixed<= (to_sfixed(0.707107,Wr2_sfixed));
Wi2_sfixed<= (to_sfixed(-0.707107,Wi2_sfixed));
Wr2<=to_slv(Wr2_sfixed);
Wi2<=to_slv(Wi2_sfixed);
Wr3_sfixed<= (to_sfixed(0.382683,Wr3_sfixed));
Wi3_sfixed<= (to_sfixed(-0.923879,Wi3_sfixed));
Wr3<=to_slv(Wr3_sfixed);
Wi3<=to_slv(Wi3_sfixed);
Wr4_sfixed<= (to_sfixed(0,Wr4_sfixed));
Wi4_sfixed<= (to_sfixed(-1,Wi4_sfixed));
Wr4<=to_slv(Wr4_sfixed);
Wi4<=to_slv(Wi4_sfixed);
Wr5_sfixed<= (to_sfixed(-0.382683,Wr5_sfixed));
Wi5_sfixed<= (to_sfixed(-0.923879,Wi5_sfixed));
Wr5<=to_slv(Wr5_sfixed);
Wi5<=to_slv(Wi5_sfixed);
Wr6_sfixed<= (to_sfixed(-0.707107,Wr6_sfixed));
Wi6_sfixed<= (to_sfixed(-0.707107,Wi6_sfixed));
Wr6<=to_slv(Wr6_sfixed);
Wi6<=to_slv(Wi6_sfixed);
Wr7_sfixed<= (to_sfixed(-0.923879,Wr7_sfixed));
Wi7_sfixed<= (to_sfixed(-0.382683,Wi7_sfixed));
Wr7<=to_slv(Wr7_sfixed);
Wi7<=to_slv(Wi7_sfixed);

-----Stadio 1
Butterfly_1_0 :Butterfly
port map(clk=>clk,Ar=>X0_R,Ai=>X0_I,Br=>X8_R,Bi=>X8_I,Wr=>Wr0,Wi=>WI0,START=>START,RST=>RST,SF_2h_1l=>'1',Ar_out=>Y0_R,Ai_out=>Y0_I,Br_out=>Y8_R,Bi_out=>Y8_I,DONE=>DONE_STADIO_1);
Butterfly_1_1 :Butterfly
port map(clk=>clk,Ar=>X1_R,Ai=>X1_I,Br=>X9_R,Bi=>X9_I,Wr=>Wr0,Wi=>WI0,START=>START,RST=>RST,SF_2h_1l=>'1',Ar_out=>Y1_R,Ai_out=>Y1_I,Br_out=>Y9_R,Bi_out=>Y9_I,DONE=>DONE_STADIO_1);
Butterfly_1_2 :Butterfly
port map(clk=>clk,Ar=>X2_R,Ai=>X2_I,Br=>X10_R,Bi=>X10_I,Wr=>Wr0,Wi=>WI0,START=>START,RST=>RST,SF_2h_1l=>'1',Ar_out=>Y2_R,Ai_out=>Y2_I,Br_out=>Y10_R,Bi_out=>Y10_I,DONE=>DONE_STADIO_1);
Butterfly_1_3 :Butterfly
port map(clk=>clk,Ar=>X3_R,Ai=>X3_I,Br=>X11_R,Bi=>X11_I,Wr=>Wr0,Wi=>WI0,START=>START,RST=>RST,SF_2h_1l=>'1',Ar_out=>Y3_R,Ai_out=>Y3_I,Br_out=>Y11_R,Bi_out=>Y11_I,DONE=>DONE_STADIO_1);
Butterfly_1_4 :Butterfly
port map(clk=>clk,Ar=>X4_R,Ai=>X4_I,Br=>X12_R,Bi=>X12_I,Wr=>Wr0,Wi=>WI0,START=>START,RST=>RST,SF_2h_1l=>'1',Ar_out=>Y4_R,Ai_out=>Y4_I,Br_out=>Y12_R,Bi_out=>Y12_I,DONE=>DONE_STADIO_1);
Butterfly_1_5 :Butterfly
port map(clk=>clk,Ar=>X5_R,Ai=>X5_I,Br=>X13_R,Bi=>X13_I,Wr=>Wr0,Wi=>WI0,START=>START,RST=>RST,SF_2h_1l=>'1',Ar_out=>Y5_R,Ai_out=>Y5_I,Br_out=>Y13_R,Bi_out=>Y13_I,DONE=>DONE_STADIO_1);
Butterfly_1_6 :Butterfly
port map(clk=>clk,Ar=>X6_R,Ai=>X6_I,Br=>X14_R,Bi=>X14_I,Wr=>Wr0,Wi=>WI0,START=>START,RST=>RST,SF_2h_1l=>'1',Ar_out=>Y6_R,Ai_out=>Y6_I,Br_out=>Y14_R,Bi_out=>Y14_I,DONE=>DONE_STADIO_1);
Butterfly_1_7 :Butterfly
port map(clk=>clk,Ar=>X7_R,Ai=>X7_I,Br=>X15_R,Bi=>X15_I,Wr=>Wr0,Wi=>WI0,START=>START,RST=>RST,SF_2h_1l=>'1',Ar_out=>Y7_R,Ai_out=>Y7_I,Br_out=>Y15_R,Bi_out=>Y15_I,DONE=>DONE_STADIO_1);
------Stadio 2
Butterfly_2_0 :Butterfly
port map(clk=>clk,Ar=>Y0_R,Ai=>Y0_I,Br=>Y4_R,Bi=>Y4_I,Wr=>Wr0,Wi=>WI0,START=>DONE_STADIO_1,RST=>RST,SF_2h_1l=>'0',Ar_out=>Z0_R,Ai_out=>Z0_I,Br_out=>Z4_R,Bi_out=>Z4_I,DONE=>DONE_STADIO_2);
Butterfly_2_1 :Butterfly
port map(clk=>clk,Ar=>Y1_R,Ai=>Y1_I,Br=>Y5_R,Bi=>Y5_I,Wr=>Wr0,Wi=>WI0,START=>DONE_STADIO_1,RST=>RST,SF_2h_1l=>'0',Ar_out=>Z1_R,Ai_out=>Z1_I,Br_out=>Z5_R,Bi_out=>Z5_I,DONE=>DONE_STADIO_2);
Butterfly_2_2 :Butterfly
port map(clk=>clk,Ar=>Y2_R,Ai=>Y2_I,Br=>Y6_R,Bi=>Y6_I,Wr=>Wr0,Wi=>WI0,START=>DONE_STADIO_1,RST=>RST,SF_2h_1l=>'0',Ar_out=>Z2_R,Ai_out=>Z2_I,Br_out=>Z6_R,Bi_out=>Z6_I,DONE=>DONE_STADIO_2);
Butterfly_2_3 :Butterfly
port map(clk=>clk,Ar=>Y3_R,Ai=>Y3_I,Br=>Y7_R,Bi=>Y7_I,Wr=>Wr0,Wi=>WI0,START=>DONE_STADIO_1,RST=>RST,SF_2h_1l=>'0',Ar_out=>Z3_R,Ai_out=>Z3_I,Br_out=>Z7_R,Bi_out=>Z7_I,DONE=>DONE_STADIO_2);
Butterfly_2_4 :Butterfly
port map(clk=>clk,Ar=>Y8_R,Ai=>Y8_I,Br=>Y12_R,Bi=>Y12_I,Wr=>Wr4,Wi=>WI4,START=>DONE_STADIO_1,RST=>RST,SF_2h_1l=>'0',Ar_out=>Z8_R,Ai_out=>Z8_I,Br_out=>Z12_R,Bi_out=>Z12_I,DONE=>DONE_STADIO_2);
Butterfly_2_5 :Butterfly
port map(clk=>clk,Ar=>Y9_R,Ai=>Y9_I,Br=>Y13_R,Bi=>Y13_I,Wr=>Wr4,Wi=>WI4,START=>DONE_STADIO_1,RST=>RST,SF_2h_1l=>'0',Ar_out=>Z9_R,Ai_out=>Z9_I,Br_out=>Z13_R,Bi_out=>Z13_I,DONE=>DONE_STADIO_2);
Butterfly_2_6 :Butterfly
port map(clk=>clk,Ar=>Y10_R,Ai=>Y10_I,Br=>Y14_R,Bi=>Y14_I,Wr=>Wr4,Wi=>WI4,START=>DONE_STADIO_1,RST=>RST,SF_2h_1l=>'0',Ar_out=>Z10_R,Ai_out=>Z10_I,Br_out=>Z14_R,Bi_out=>Z14_I,DONE=>DONE_STADIO_2);
Butterfly_2_7 :Butterfly
port map(clk=>clk,Ar=>Y11_R,Ai=>Y11_I,Br=>Y15_R,Bi=>Y15_I,Wr=>Wr4,Wi=>WI4,START=>DONE_STADIO_1,RST=>RST,SF_2h_1l=>'0',Ar_out=>Z11_R,Ai_out=>Z11_I,Br_out=>Z15_R,Bi_out=>Z15_I,DONE=>DONE_STADIO_2);
-----Stadio 3
Butterfly_3_0: Butterfly
port map(clk=>clk,Ar=>Z0_R,Ai=>Z0_I,Br=>Z2_R,Bi=>Z2_I,Wr=>Wr0,Wi=>WI0,START=>DONE_STADIO_2,RST=>RST,SF_2h_1l=>'0',Ar_out=>T0_R,Ai_out=>T0_I,Br_out=>T2_R,Bi_out=>T2_I,DONE=>DONE_STADIO_3);
Butterfly_3_1: Butterfly
port map(clk=>clk,Ar=>Z1_R,Ai=>Z1_I,Br=>Z3_R,Bi=>Z3_I,Wr=>Wr0,Wi=>WI0,START=>DONE_STADIO_2,RST=>RST,SF_2h_1l=>'0',Ar_out=>T1_R,Ai_out=>T1_I,Br_out=>T3_R,Bi_out=>T3_I,DONE=>DONE_STADIO_3);
Butterfly_3_2: Butterfly
port map(clk=>clk,Ar=>Z4_R,Ai=>Z4_I,Br=>Z6_R,Bi=>Z6_I,Wr=>Wr4,Wi=>WI4,START=>DONE_STADIO_2,RST=>RST,SF_2h_1l=>'0',Ar_out=>T4_R,Ai_out=>T4_I,Br_out=>T6_R,Bi_out=>T6_I,DONE=>DONE_STADIO_3);
Butterfly_3_3: Butterfly
port map(clk=>clk,Ar=>Z5_R,Ai=>Z5_I,Br=>Z7_R,Bi=>Z7_I,Wr=>Wr4,Wi=>WI4,START=>DONE_STADIO_2,RST=>RST,SF_2h_1l=>'0',Ar_out=>T5_R,Ai_out=>T5_I,Br_out=>T7_R,Bi_out=>T7_I,DONE=>DONE_STADIO_3);
Butterfly_3_4: Butterfly
port map(clk=>clk,Ar=>Z8_R,Ai=>Z8_I,Br=>Z10_R,Bi=>Z10_I,Wr=>Wr2,Wi=>WI2,START=>DONE_STADIO_2,RST=>RST,SF_2h_1l=>'0',Ar_out=>T8_R,Ai_out=>T8_I,Br_out=>T10_R,Bi_out=>T10_I,DONE=>DONE_STADIO_3);
Butterfly_3_5: Butterfly
port map(clk=>clk,Ar=>Z9_R,Ai=>Z9_I,Br=>Z11_R,Bi=>Z11_I,Wr=>Wr2,Wi=>WI2,START=>DONE_STADIO_2,RST=>RST,SF_2h_1l=>'0',Ar_out=>T9_R,Ai_out=>T9_I,Br_out=>T11_R,Bi_out=>T11_I,DONE=>DONE_STADIO_3);
Butterfly_3_6: Butterfly
port map(clk=>clk,Ar=>Z12_R,Ai=>Z12_I,Br=>Z14_R,Bi=>Z14_I,Wr=>Wr6,Wi=>WI6,START=>DONE_STADIO_2,RST=>RST,SF_2h_1l=>'0',Ar_out=>T12_R,Ai_out=>T12_I,Br_out=>T14_R,Bi_out=>T14_I,DONE=>DONE_STADIO_3);
Butterfly_3_7: Butterfly
port map(clk=>clk,Ar=>Z13_R,Ai=>Z13_I,Br=>Z15_R,Bi=>Z15_I,Wr=>Wr6,Wi=>WI6,START=>DONE_STADIO_2,RST=>RST,SF_2h_1l=>'0',Ar_out=>T13_R,Ai_out=>T13_I,Br_out=>T15_R,Bi_out=>T15_I,DONE=>DONE_STADIO_3);
-----Stadio 4
Butterfly_4_0: Butterfly
port map(clk=>clk,Ar=>T0_R,Ai=>T0_I,Br=>T1_R,Bi=>T1_I,Wr=>Wr0,Wi=>Wi0,START=>DONE_STADIO_3,RST=>RST,SF_2h_1l=>'0',Ar_out=>X0_R_OUT,Ai_out=>X0_I_OUT,Br_out=>X8_R_OUT,Bi_out=>X8_I_OUT,DONE=>DONE);
Butterfly_4_1: Butterfly
port map(clk=>clk,Ar=>T2_R,Ai=>T2_I,Br=>T3_R,Bi=>T3_I,Wr=>Wr4,Wi=>Wi4,START=>DONE_STADIO_3,RST=>RST,SF_2h_1l=>'0',Ar_out=>X4_R_OUT,Ai_out=>X4_I_OUT,Br_out=>X12_R_OUT,Bi_out=>X12_I_OUT,DONE=>DONE);
Butterfly_4_2: Butterfly
port map(clk=>clk,Ar=>T4_R,Ai=>T4_I,Br=>T5_R,Bi=>T5_I,Wr=>Wr2,Wi=>WI2,START=>DONE_STADIO_3,RST=>RST,SF_2h_1l=>'0',Ar_out=>X2_R_OUT,Ai_out=>X2_I_OUT,Br_out=>X10_R_OUT,Bi_out=>X10_I_OUT,DONE=>DONE);
Butterfly_4_3: Butterfly
port map(clk=>clk,Ar=>T6_R,Ai=>T6_I,Br=>T7_R,Bi=>T7_I,Wr=>Wr6,Wi=>WI6,START=>DONE_STADIO_3,RST=>RST,SF_2h_1l=>'0',Ar_out=>X6_R_OUT,Ai_out=>X6_I_OUT,Br_out=>X14_R_OUT,Bi_out=>X14_I_OUT,DONE=>DONE);
Butterfly_4_4: Butterfly
port map(clk=>clk,Ar=>T8_R,Ai=>T8_I,Br=>T9_R,Bi=>T9_I,Wr=>Wr1,Wi=>WI1,START=>DONE_STADIO_3,RST=>RST,SF_2h_1l=>'0',Ar_out=>X1_R_OUT,Ai_out=>X1_I_OUT,Br_out=>X9_R_OUT,Bi_out=>X9_I_OUT,DONE=>DONE);
Butterfly_4_5: Butterfly
port map(clk=>clk,Ar=>T10_R,Ai=>T10_I,Br=>T11_R,Bi=>T11_I,Wr=>Wr5,Wi=>WI5,START=>DONE_STADIO_3,RST=>RST,SF_2h_1l=>'0',Ar_out=>X5_R_OUT,Ai_out=>X5_I_OUT,Br_out=>X13_R_OUT,Bi_out=>X13_I_OUT,DONE=>DONE);
Butterfly_4_6: Butterfly
port map(clk=>clk,Ar=>T12_R,Ai=>T12_I,Br=>T13_R,Bi=>T13_I,Wr=>Wr3,Wi=>WI3,START=>DONE_STADIO_3,RST=>RST,SF_2h_1l=>'0',Ar_out=>X3_R_OUT,Ai_out=>X3_I_OUT,Br_out=>X11_R_OUT,Bi_out=>X11_I_OUT,DONE=>DONE);
Butterfly_4_7: Butterfly
port map(clk=>clk,Ar=>T14_R,Ai=>T14_I,Br=>T15_R,Bi=>T15_I,Wr=>Wr7,Wi=>WI7,START=>DONE_STADIO_3,RST=>RST,SF_2h_1l=>'0',Ar_out=>X7_R_OUT,Ai_out=>X7_I_OUT,Br_out=>X15_R_OUT,Bi_out=>X15_I_OUT,DONE=>DONE);


end architecture;
--Part 3 Lab 3

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity number_game is
    Port (
         clk : in std_logic; 
         rst : in std_logic;
         input : inout STD_LOGIC_VECTOR (7 downto 0); 
         digit_sel : out STD_LOGIC;
         seg : out STD_LOGIC_VECTOR (6 downto 0)
         );
end number_game;

architecture Behavioral of number_game is
component PmodKYPD is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           kypd : inout STD_LOGIC_VECTOR (7 downto 0); 
           digit_sel : out STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end component;

--component Decoder is
--    port (
--        clk : in STD_LOGIC;
--        Row : in STD_LOGIC_VECTOR (3 downto 0);
--        Col : out STD_LOGIC_VECTOR (3 downto 0);
--        DecodeOut : out STD_LOGIC_VECTOR (3 downto 0));
--end component;

--component DisplayController is
--    Port ( DispVal : in STD_LOGIC_VECTOR (3 downto 0);
--           segOut : out STD_LOGIC_VECTOR (6 downto 0));
--end component;

signal target_number : std_logic;

--port maps
signal decode : STD_LOGIC_VECTOR (3 downto 0);
signal digit_sel_reg : std_logic;
begin
--DO: Decoder port map (clk => clk, Row => kypd(7 downto 4), Col => kypd(3 downto 0), DecodeOut => decode);
--SS1: DisplayController port map(DispVal => decode, segOut => seg);
KYPD: PmodKYPD port map(clk => clk, rst => rst, kypd => input, digit_sel => digit_sel, seg => seg); 






end Behavioral;

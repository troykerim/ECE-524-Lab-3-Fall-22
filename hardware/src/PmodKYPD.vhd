--Part 3 of Lab 3

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PmodKYPD is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           kypd : inout STD_LOGIC_VECTOR (7 downto 0); --Signal going into keypad and out from it
           --digit_sel : out STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);  --Instructs the chip which led to turn on
           an : out std_logic; -- Controls which position of SSD 
           led_r : out std_logic;
           led_g : out sTd_LoGiC;
           led_b : out std_logic;
           stop_btn : in std_logic; --part 3
           show_hidden_num_btn : in std_logic
           );
end PmodKYPD;

architecture Behavioral of PmodKYPD is

component Decoder is            --Gets input from keypad and returns a number
    port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        Row : in STD_LOGIC_VECTOR (3 downto 0);
        Col : out STD_LOGIC_VECTOR (3 downto 0);
        DecodeOut : out STD_LOGIC_VECTOR (3 downto 0)
        );
end component;

component DisplayController is
    Port ( DispVal : in STD_LOGIC_VECTOR (3 downto 0);
           segOut : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component debouncer is
    GENERIC(
        clk_freq    : INTEGER := 50_000_000;  
        stable_time : INTEGER := 10);         
  PORT(
        clk     : IN  STD_LOGIC;  
        reset_n : IN  STD_LOGIC;  
        button  : IN  STD_LOGIC;  
        result  : OUT STD_LOGIC); 
end component;

signal Decode : STD_LOGIC_VECTOR (3 downto 0);
signal disp_sel : std_logic;

signal led_toggle : std_logic;
--constant clk_cnt_bits : integer := 19;
--signal clk_cnt : unsigned(clk_cnt_bits - 1 downto 0);
signal decode_confirm : std_logic_vector(3 downto 0);
--signal digit_sel_reg : std_logic;

signal decode0 : std_logic_vector(3 downto 0);
signal decode1 : std_logic_vector(3 downto 0);
signal seg0 : std_logic_vector(6 downto 0);
signal seg1 : std_logic_vector(6 downto 0);
signal seg2 : std_logic_vector(6 downto 0); -- Part 3

--Part 3 stuff
constant clk_cnt_width : integer := 20;
signal clk_cnt : unsigned(clk_cnt_width-1 downto 0);

signal hidden_num : unsigned(3 downto 0);
signal stop_btn_confirm : std_logic;
signal hidden_num_counter : unsigned(3 downto 0);
signal show_hidden_num_btn_confirm : std_logic;

begin
    DCO: Decoder port map --kypd(7 downto 4) determine the Row)kypd(3 downto 0) determines the column
    (clk => clk, rst => rst, Row => kypd(7 downto 4), Col => kypd(3 downto 0), DecodeOut => Decode);
    SDO: DisplayController port map(DispVal => Decode0, segOut => seg0);
    SD1: DisplayController port map(DispVal => Decode1, segOut => seg1); --Need 2 display controllers
    --Handles showing the hidden number
    SD2: DisplayController port map(DispVal => std_logic_vector(hidden_num), segOut => seg2);
    
    --Debouncers
    DBO: debouncer port map(clk => clk, reset_n => rst, button => Decode(0), result => decode_confirm(0));
    DB1: debouncer port map(clk => clk, reset_n => rst, button => Decode(1), result => decode_confirm(1));
    DB2: debouncer port map(clk => clk, reset_n => rst, button => Decode(2), result => decode_confirm(2));
    DB3: debouncer port map(clk => clk, reset_n => rst, button => Decode(3), result => decode_confirm(3));
    
    DB4: debouncer port map(clk => clk, reset_n => rst, button => stop_btn, result => stop_btn_confirm);
    DB5: debouncer port map(clk => clk, reset_n => rst, button => show_hidden_num_btn, result => show_hidden_num_btn_confirm);
    --an <= disp_sel;

    process(clk, rst)
    begin
        if rst = '1' then --Async Reset
            disp_sel <= '0';
            decode0 <= (others => '0');
            decode1 <= (others => '0');
        elsif rising_edge(clk) then
            if decode /= decode_confirm then
                disp_sel <= NOT disp_sel;
            else
                if disp_sel <= '1' then     
                    decode0 <= decode;
                else
                    decode1 <= decode;
                end if;
            end if;
        end if;
    
end process;


--Counter 
    process(clk, rst)
    begin 
        if rst = '1' then
            clk_cnt <= (others => '0');
        elsif rising_edge(clk) then
            clk_cnt <= clk_cnt + 1;
        end if;
    end process;
    
    --counter for 
    process(clk, rst)
    begin 
        if rst = '1' then
            hidden_num <= (others => '0');
        elsif rising_edge(clk) then
            if stop_btn_confirm = '1' then
                hidden_num <= hidden_num_counter;
            else
                hidden_num <= hidden_num_counter + 1;
            end if;
        end if;
    end process;
    
an <= clk_cnt(clk_cnt'high);
seg <= "1111111" when show_hidden_num_btn_confirm = '1' else 
       seg0 when clk_cnt(clk_cnt'high) = '0' else
       seg1;
led_r <= progress_status(2);
led_g <= progress_status(1);
led_b <= progress_status(0);
end Behavioral;

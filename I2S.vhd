library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity I2S is
    generic( RATIO   : integer := 8;
             data_width : integer := 16);
    port( MCLK,RST : in std_logic;
			 LRCLK,SCLK,SD : out std_logic);
end I2S;

architecture I2S_Arch of I2S is
	type I2S_State is (resetState, waitForReadyState, increaseAddressState, waitForStartState);

   signal currentState : I2S_State    := resetState;

   signal Tx : std_logic_vector(((2 * data_width) - 1) downto 0) := (others => '0');
   signal ROM_Data : std_logic_vector((data_width - 1) downto 0) := (others => '0');
   signal ROM_Address : std_logic_vector(6 downto 0) := (others => '0');

	signal ready : std_logic;
   signal SCLK_temp : std_logic;

	component I2S_Transmitter is
		generic( data_width  : integer := 16);
		port( CLK,RST : in std_logic;
				 Tx : in std_logic_vector(((2 * data_width) - 1) downto 0);
             ready,LRCLK,SCLK,SD : out std_logic);
	end component;

   component SineROM is
       port( address : in std_logic_vector(6 downto 0);
             clock   : in std_logic;
             q : out std_logic_vector(15 downto 0));
   end component;

	begin

		Transmitter : I2S_Transmitter 
			generic map( data_width => data_width)
			port map( CLK => SCLK_temp,
						 RST => RST,
						 ready => ready,
						 Tx => Tx,
						 LRCLK => LRCLK,
						 SCLK => SCLK,
						 SD => SD);

		ROM : SineROM 
			port map( address => ROM_Address,
						 clock => MCLK,
						 q => ROM_Data);

    process
        variable CNT    : INTEGER := 0;
    begin
        wait until rising_edge(MCLK);
        if(CNT < ((RATIO / 2) - 1)) then
            CNT := CNT + 1;
        else
            CNT := 0;
            SCLK_temp <= not SCLK_temp;
        end if;

        if(RST = '0') then
            CNT := 0;
            SCLK_temp <= '0';
        end if;
    end process;

    process
        variable Word_CNT    : INTEGER := 0;
    begin
        wait until rising_edge(MCLK);
        case CurrentState is
            when resetState =>
                Word_CNT := 0;
                CurrentState <= waitForReadyState;
            when waitForReadyState =>
                if(ready = '1') then
                    CurrentState <= waitForStartState;
                else
                    CurrentState <= waitForReadyState;
                end if;
            when waitForStartState =>
                ROM_Address <= std_logic_vector(to_unsigned(Word_CNT, ROM_Address'length)); 
                Tx <= x"0000" & ROM_Data; -- L & R Value
                if(ready = '0') then
                    CurrentState <= increaseAddressState;
                else
                    CurrentState <= waitForStartState;
                end if;
            when increaseAddressState =>
                if(Word_CNT < 100) then
                    Word_CNT := Word_CNT + 1;
                else
                    Word_CNT := 0;
                end if;
                CurrentState <= waitForReadyState;
        end case;
		  
        if(RST = '0') then
            CurrentState <= resetState;
        end if;
		  
    end process;
end I2S_Arch;
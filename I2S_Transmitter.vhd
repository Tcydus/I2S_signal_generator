
library ieee;
use ieee.std_logic_1164.all;

entity I2S_Transmitter is
    generic( data_width  : integer := 16);
    port( CLK,RST : in std_logic;
			 Tx : in std_logic_vector(((2 * data_width) - 1) downto 0);
          ready,LRCLK,SCLK,SD : out std_logic);
end I2S_Transmitter;

architecture I2S_Transmitter_Arch of I2S_Transmitter is
	type transmitState is (resetState, loadWordState, transmitWordState );
	
	signal currentState : transmitState	:= resetState;
	
	signal Tx_temp : std_logic_vector(((2 * data_width) - 1) downto 0) := (others => '0');
	signal ready_temp : std_logic := '0';
	signal LRCLK_temp : std_logic := '1';
	signal SD_temp : std_logic := '0';
	signal ENB	: std_logic := '0';
	
	begin
		process
			variable bitCounter : integer := 0;
		begin
			wait until falling_edge(CLK);
			
			case currentState is
				when resetState =>
				
					ready_temp <= '0';
					LRCLK_temp <= '1';
					ENB <= '1';
					SD_temp <= '0';
					Tx_temp <= (others => '0');
					currentState <= loadWordState;
					
				when loadWordState =>
				
					bitCounter := 0;
					Tx_temp <= Tx;
					LRCLK_temp <= '0';
					currentState <= transmitWordState;
					
				when transmitWordState =>
				
					bitCounter := bitCounter + 1;
					
					if bitCounter > (data_width - 1) then
						LRCLK_temp <= '1';
					end if;
					
					if bitCounter < ((2 * data_width) - 1) then 
						ready_temp <= '0';
					else
						ready_temp <= '1';
						currentState <= loadWordState;
					end if;
					
					Tx_temp <= Tx_temp(((2 * data_width) - 2) downto 0) & "0";
					SD_temp <= Tx_temp((2 * data_width) - 1);
			end case;
		if RST = '0' then
			currentState <= resetState;
		end if;
	end process;
	ready <= ready_temp;
	LRCLK <= LRCLK_temp;
	SCLK <= CLK and ENB;
	SD <= SD_temp;
	
end I2S_Transmitter_Arch;
					
					
					
					
					
					
					
			
	
	
	


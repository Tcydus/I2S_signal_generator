library ieee;
use ieee.std_logic_1164.all;

entity DAC_Input is 
	generic( RATIO : integer := 8;
            data_width : integer := 16;
				T_CNT : integer := 4);
	port(	CLK,RST_BTN : in std_logic;
			XMT,FMT,LCK,DIN,BCK,SCL,DMP,FLT : out std_logic);
end DAC_Input;

architecture DAC_Input_Arch of DAC_Input is 

	component freqDivider is
		generic( T_cnt : integer := 4); -- (10000) 500 Hz
		port(	CLK_IN : in std_logic;
				CLK_OUT : out std_logic);
	end component;
	
	component I2S is
		generic( RATIO   : integer := 8;
               data_width : integer := 16);
		port( MCLK,RST : in std_logic;
			   LRCLK,SCLK,SD : out std_logic);
	end component;
	
	signal SOFT_MUTE 			: std_logic	:= '0';
	signal SOFT_UNMUTE 		: std_logic := '1';
	signal I2S_MODE 			: std_logic := '0';
	signal LEFT_JUSTIFIED 	: std_logic := '1';
	signal DMP_44kHzENB 		: std_logic := '1';
	signal FILTER_NORMDELAY : std_logic := '0';
	signal FILTER_LOWDELAY 	: std_logic := '1';
	
	signal MCLK : std_logic := '0';
	
	begin
	XMT <= SOFT_UNMUTE ;
	FMT <= I2S_MODE;
	DMP <= DMP_44kHzENB;
	FLT <= FILTER_NORMDELAY;
	
	InputClock : FreqDivider 
		port map( CLK_IN => CLK,
					 CLK_OUT =>MCLK); 
					
	I2S_Module : I2S 
		generic map( RATIO => RATIO,
                   data_width => data_width)
      port map( MCLK => MCLK, 
                RST => RST_BTN,
                LRCLK => LCK, -- L R clk
                SCLK => BCK, -- Bit clk
                SD => DIN); -- Data input	
	
	SCL <= MCLK; -- master clk
	
end DAC_Input_Arch;
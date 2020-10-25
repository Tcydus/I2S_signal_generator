library ieee;
use ieee.std_logic_1164.all;

entity freqDivider is
	generic(T_cnt : integer := 4); -- (10000) 500 Hz
	port(	CLK_IN : in std_logic;
			CLK_OUT : out std_logic);
end freqDivider;

architecture freqDivider_arch of freqDivider is
	
	signal duty : integer := T_cnt/2;
	signal cnt : integer range 0 to T_cnt;
	begin
	
	process(CLK_IN)
		begin
		if rising_edge(CLK_IN) then
			if (cnt = T_cnt-1) then
				if (cnt = duty) then
					CLK_OUT <= '0';
				end if;
				cnt <= 0;
			else
				cnt <= cnt + 1;
				if(cnt < duty) then
					CLK_OUT <= '1';		
				elsif (cnt = duty) then
					CLK_OUT <= '0';
				end if;
			end if;		
		end if;
	end process;

end freqDivider_arch;
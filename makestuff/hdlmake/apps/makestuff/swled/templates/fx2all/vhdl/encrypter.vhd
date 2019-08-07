----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:19:03 01/23/2018 
-- Design Name: 
-- Module Name:    decrypter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity encrypter is
    Port ( clock : in  STD_LOGIC;
           K : in  STD_LOGIC_VECTOR (31 downto 0);
           C : out  STD_LOGIC_VECTOR (31 downto 0);
           P : in  STD_LOGIC_VECTOR (31 downto 0);
           reset : in  STD_LOGIC;
			  done : out STD_LOGIC;
           enable : in  STD_LOGIC);
end encrypter;

architecture Behavioral of encrypter is
-- Temporary signal to store C
signal tempC : std_logic_vector (31 downto 0) := "00000000000000000000000000000000";

--Counter for loops
signal cnt : integer range -1 to 33 := -1;

-- coresponds to the symbol 'T' in algorithm
signal tt : std_logic_vector (3 downto 0) :="0000";

-- concatenating tt 8 times
signal T: std_logic_vector (31 downto 0) := "00000000000000000000000000000000";
begin

	-- process to concatenate tt to get T
	init_T : process (tt) 
	begin 
		T <= tt & tt & tt & tt & tt & tt & tt & tt; 
	end process ; 
	
	-- process which encripts the input message
	main : process(clock, reset, enable)
	 begin
	 -- setting the initial values of the signals when reset is set
		if (reset = '1') then
			--if(cnt > -1 ) then
				C <= "00000000000000000000000000000000";
				tempC <= "00000000000000000000000000000000";
				cnt <= -1;
				done <= '0';
			--end if; 
		elsif (clock'event and clock = '1' and enable = '1') then
		-- Initialises tt according to the key
			if(cnt = -1) then 
				tt(0) <= K(0) xor K(4) xor K(8) xor K(12) xor K(16) xor K(20) xor K(24) xor K(28);
				tt(1) <= K(1) xor K(5) xor K(9) xor K(13) xor K(17) xor K(21) xor K(25) xor K(29);
				tt(2) <= K(2) xor K(6) xor K(10) xor K(14) xor K(18) xor K(22) xor K(26) xor K(30);
				tt(3) <= K(3) xor K(7) xor K(11) xor K(15) xor K(19) xor K(23) xor K(27) xor K(31);
				cnt <= cnt+1; 

			-- executes according to the number 1's in the key
			elsif(cnt < 32) then 
				if(K(cnt) = '1' ) then 
					tempC <= tempC xor T; 
					tt <= tt + 1; 
				end if; 
				cnt <= cnt +1 ;

			-- cnt is made 33 after setting the encrypted output to stop the loop
			elsif ( cnt = 32) then 
				C <= tempC xor P; 
				cnt <= cnt +1;
				done <= '1';
			end if;  
		end if;	
			
	 end process;

end Behavioral;
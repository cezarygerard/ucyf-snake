--This is a VHDL testbench.  It is used to stimulate the inputs to 
--file we are testing.  A good design practice is to create a testbench
--for each component you are developing.  Test each component separately
--before combining them.  

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE testbench_arch OF testbench IS

COMPONENT kontroler_klaw

generic(
DZIELNIK	: natural :=6;
DZIELNIK1 : natural :=3
);

port(
	clock : in std_logic; --sygnal zegarowy z oscylatora plytki (50 MHz)
	reset : in std_logic; -- sygnal resetu
	rot_a : in std_logic; -- sygnal informujacy ze galka zostala skrecona w lewo
	rot_b : in std_logic; -- sygnal informujacy ze galka zostala skrecona w prawo
	klaw_out : out std_logic_vector(1 downto 0) -- sygnal informujacy o skrecie 
	--('00' gdy prosto, '01' gdy w lewo, '10' gdy w prawo i '11' gdy jakiœ b³¹d
);

END COMPONENT;

--develop signals to stimulate
SIGNAL clock 	: std_logic := '0';
SIGNAL reset : std_logic := '0';
SIGNAL rot_a : std_logic := '0';
SIGNAL rot_b : std_logic := '0';
SIGNAL klaw_out : std_logic_vector(1 downto 0) := (others => '0');


   constant clka_period : time := 100ns;
	
--UUT means unit under test
BEGIN
UUT : kontroler_klaw

--map signals on right to entitys on the left
PORT MAP (
clock => clock,
reset => reset,
rot_a => rot_a,
rot_b => rot_b,
klaw_out => klaw_out
);
  
signal_A: process
begin
	clock <= '1';
	wait for clka_period/2;
	clock <= '0';
	wait for clka_period/2;	
end process;


signal_B: process
begin
	rot_a <= '1';
	wait for clka_period;
	rot_a <= '0';
	wait for clka_period;	
end process;


--signal_B: process
--begin
--	B <= NOT B;
--	wait for 2 ns;
--end process;
--
--signal_C: process
--begin
--	C <= NOT C;
--	wait for 4 ns;
--end process;
--
--signal_D: process
--begin
--	D <= NOT D;
--	wait for 8 ns;
--end process;

END testbench_arch;


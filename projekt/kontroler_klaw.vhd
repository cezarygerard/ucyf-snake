----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:15:26 05/14/2009 
-- Design Name: 
-- Module Name:    kontroler_klaw - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
--use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity kontroler_klaw is 

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
end kontroler_klaw; 

architecture Behavioral of kontroler_klaw is

constant CNT_WIDTH : natural := 2;

signal clkEnable : std_logic; -- pomniejszony sygnal zegarowy
signal clkLicznik : integer :=0; -- licznik wykorzystywany do naliczania impulsow z clock
signal next_klaw_out : std_logic_vector(1 downto 0); -- pomocniczy sygnal synchronizujacy wyjscia
signal next_klaw_out_reg : std_logic_vector(1 downto 0); -- pomocniczy sygnal synchronizujacy wyjscia
begin

	process (clock, reset) -- proces naliczajacy licznik potrzebny do zmiejszenia zegara sterujacego
	begin
		if reset = '1' then
			clkLicznik <= 0;
		elsif rising_edge(clock) then
			if clkLicznik = DZIELNIK then
				clkLicznik <= 0;
			else
				clkLicznik <= clkLicznik + 1;
			end if;
		end if;
	end process;
	
	process (clock, reset) -- proces tworzacy wolniejszy zegar (clkEnable)
	begin
		if reset = '1' then
			clkEnable <= '0';
		elsif rising_edge(clock) then
			if clkLicznik = DZIELNIK1 then
				clkEnable <= '1';
			else
				clkEnable <= '0';
			end if;
		end if;
	end process;
	
	process (clock, reset) -- proces ktory w zaleznosci od ustawienia galek przygotowuje sygnal next_klaw_out
	begin
		if reset = '1' then
			next_klaw_out <= "00";
		elsif rising_edge(clock) then
			if (rot_a = '0' and rot_b = '0') then
				next_klaw_out <= "00"; -- jedz do przodu
			elsif (rot_a = '1' and rot_b = '0') then
				next_klaw_out <= "01"; -- skrec w lewo
			elsif (rot_a = '0' and rot_b = '1') then
				next_klaw_out <= "10"; -- skrec w prawo
			elsif (rot_a = '1' and rot_b = '1') then
				next_klaw_out <= "11"; -- blad			
			end if;
		end if;
	end process;
	
	process (clock, reset)
	begin
		if reset = '1' then
		next_klaw_out_reg <= "00";
		elsif rising_edge(clock) then
			if clkEnable = '1' then
			next_klaw_out_reg <= next_klaw_out;
			else
			next_klaw_out_reg <= next_klaw_out_reg;
			end if;
		end if;
		
	end process;
	
	klaw_out <= next_klaw_out_reg;

end Behavioral;


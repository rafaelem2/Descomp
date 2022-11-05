library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    -- Biblioteca IEEE para funções aritméticas

entity ULASomaSub is
    generic ( larguraDados : natural := 4 );
    port (
      entradaA, entradaB:  in STD_LOGIC_VECTOR((larguraDados-1) downto 0);
      seletor : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      saida:    out STD_LOGIC_VECTOR((larguraDados-1) downto 0);
		flagZero: out std_logic;
		flagGT: out std_logic
    );
end entity;

architecture comportamento of ULASomaSub is
   signal soma :      STD_LOGIC_VECTOR((larguraDados-1) downto 0);
   signal subtracao : STD_LOGIC_VECTOR((larguraDados-1) downto 0);
    begin
      soma      <= STD_LOGIC_VECTOR(unsigned(entradaA) + unsigned(entradaB));
      subtracao <= STD_LOGIC_VECTOR(unsigned(entradaA) - unsigned(entradaB));
      saida <= soma when (seletor = "01") else
			subtracao when (seletor = "00") else
			entradaB when (seletor = "10") else
			entradaA;
		flagZero <= '1' when unsigned(saida) = 0 else '0';
		flagGT <= '1' WHEN (entradaA > entradaB) ELSE '0';
end architecture;
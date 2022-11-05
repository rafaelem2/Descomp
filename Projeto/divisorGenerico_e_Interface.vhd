LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity divisorGenerico_e_Interface is
   port(clk      :   in std_logic;
      habilitaLeitura : in std_logic;
      limpaLeitura : in std_logic;
		seletor : in std_logic;
      leituraUmSegundo :   out std_logic_vector(7 downto 0)
   );
end entity;

architecture interface of divisorGenerico_e_Interface is
  signal sinalUmSegundo : std_logic;
  signal saidaclk_reg1seg : std_logic;
  signal saidaclk_regRapido: std_logic;
  signal muxToFlipFlop : std_logic;
begin

baseTempo: entity work.divisorGenerico
           generic map (divisor => 25000000)   
           port map (clk => clk, saida_clk => saidaclk_reg1seg);
			  
baseTempoRapido: entity work.divisorGenerico
           generic map (divisor => 250000)   
           port map (clk => clk, saida_clk => saidaclk_regRapido);
			  
MUX_Velocidade :  entity work.mux2x1 
        port map( entradaA_MUX => saidaclk_reg1seg,
                 entradaB_MUX => saidaclk_regRapido,
                 seletor_MUX => seletor,
                 saida_MUX => muxToFlipFlop);

registraUmSegundo: entity work.flipflop
   port map (DIN => '1', DOUT => sinalUmSegundo,
         ENABLE => '1', CLK => muxToFlipFlop,
         RST => limpaLeitura);

-- Faz o tristate de saida:
leituraUmSegundo <= "ZZZZZZZZ" when (habilitaLeitura = '0') else "0000000" & sinalUmSegundo;

end architecture interface;
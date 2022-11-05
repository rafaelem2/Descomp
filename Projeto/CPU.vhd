library ieee;
use ieee.std_logic_1164.all;

entity CPU is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 8;
        larguraEnderecos : natural := 9
        
  );
  port   (
	 CLK : in std_logic;
	 Instruction_IN : in std_logic_vector(15 downto 0);
	 Data_IN : in std_logic_vector(7 downto 0);
	 Data_OUT : out std_logic_vector(7 downto 0);
	 Data_Address : out std_logic_vector(8 downto 0);
	 ROM_Address : out std_logic_vector(8 downto 0);
	 Habilita_R : out std_logic;
	 Habilita_W : out std_logic
	
    
	 
	 
  );
end entity;


architecture arquitetura of CPU is

-- Faltam alguns sinais:

--ULA
  signal bancoToULA : std_logic_vector (larguraDados-1 downto 0); -- entrada A
  signal ULA_B : std_logic_vector (larguraDados-1 downto 0); -- entrada B
  signal Saida_ULA : std_logic_vector (larguraDados-1 downto 0); -- Saida
  signal ulaToFlip : std_logic; --Saida
  signal ulaGT : std_logic; --Saida
  
--Controle
  signal Sinais_Controle : std_logic_vector (13 downto 0);
  
--REGISTRADOR 
  signal Endereco : std_logic_vector (8 downto 0);
  signal proxPC : std_logic_vector (8 downto 0);
  signal mux4ToPc : std_logic_vector (8 downto 0);
  signal decToMux : std_logic_vector (1 downto 0);
  signal regToMux : std_logic_vector (8 downto 0);
  
--Decodificacao
  signal SelMUX : std_logic;
  signal Habilita_A : std_logic;
  signal Operacao_ULA : std_logic_vector(1 downto 0); 
  signal flipToDec : std_logic;
  signal flipGT : std_logic;
  
  
  
  

begin

-- O port map completo do MUX.
MUX1 :  entity work.muxGenerico2x1  generic map (larguraDados => 8)
        port map( entradaA_MUX => Data_IN,
                 entradaB_MUX =>  Instruction_IN(7 DOWNTO 0),
                 seletor_MUX => SelMUX,
                 saida_MUX => ULA_B);
					  
MUX_DE_4 :  entity work.muxGenerico4x1  generic map (larguraDados => 9)
        port map( entradaA_MUX => proxPC,
                 entradaB_MUX =>  Instruction_IN(8 DOWNTO 0),
					  entradaC_MUX => regToMux,
					  entradaD_MUX => "000000000",
                 seletor_MUX => decToMux,
                 saida_MUX => mux4ToPc);


BANCOREG : entity work.bancoRegistradoresArqRegMem   generic map (larguraDados => 8, larguraEndBancoRegs => 3)
          port map ( clk => CLK,
              endereco => Instruction_IN(11 DOWNTO 9),
              dadoEscrita => Saida_ULA,
              habilitaEscrita => Habilita_A,
              saida  => bancoToULA);

REGEND: entity work.registradorGenerico   generic map (larguraDados => 9)
          port map (DIN => proxPC, DOUT => regToMux, ENABLE => Sinais_Controle(11), CLK => CLK);

FF : entity work.flipflop
          port map (DIN => ulaToFlip, DOUT => flipToDec, ENABLE => Sinais_Controle(2), CLK => CLK, RST => '0');

FF2 : entity work.flipflop
          port map (DIN => ulaGT, DOUT => flipGT, ENABLE => Sinais_Controle(13), CLK => CLK, RST => '0');
			 
-- O port map completo do Program Counter.
PC : entity work.registradorGenerico   generic map (larguraDados => 9)
          port map (DIN => mux4ToPc, DOUT => Endereco, ENABLE => '1', CLK => CLK);

incrementaPC :  entity work.somaConstante  generic map (larguraDados => larguraEnderecos, constante => 1)
        port map( entrada => Endereco, saida => proxPC);


-- O port map completo da ULA:
ULA1 : entity work.ULASomaSub  generic map(larguraDados => 8)
          port map (entradaA => bancoToULA, entradaB => ULA_B, saida => Saida_ULA, seletor => Operacao_ULA, flagZero => ulaToFlip, flagGT => ulaGT);


			 
DEC :  entity work.decoderInstru
        port map( opcode => Instruction_IN(15 DOWNTO 12),
						flagEq => flipToDec,
						flagGT => flipGT,
                 saida => Sinais_Controle,
					  flagMux => decToMux
					  );
			 
selMUX <= Sinais_Controle(6);
Habilita_A <= Sinais_Controle(5);
Operacao_ULA <= Sinais_Controle(4 DOWNTO 3);

Habilita_R <= Sinais_Controle(1);
Habilita_W <= Sinais_Controle(0);
Data_OUT <= bancoToULA;
Data_Address <= Instruction_IN(8 DOWNTO 0);
ROM_Address <= Endereco;

end architecture;
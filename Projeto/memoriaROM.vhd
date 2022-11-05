library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 4;
          addrWidth: natural := 3
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoriaROM is
  CONSTANT NOP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  CONSTANT LDA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
  CONSTANT SOMA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
  CONSTANT SUB : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
  CONSTANT LDI : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
  CONSTANT STA : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
  CONSTANT JMP : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
  CONSTANT JEQ : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
  CONSTANT CEQ : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";
  CONSTANT JSR : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001";
  CONSTANT RET : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010";	
  CONSTANT CGT : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1011";	
  CONSTANT JGT : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100";
  CONSTANT ADDI : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1101";
  
  constant R0   : std_logic_vector(2 downto 0) := "000";
  constant R1   : std_logic_vector(2 downto 0) := "001";
  constant R2   : std_logic_vector(2 downto 0) := "010";
  constant R3   : std_logic_vector(2 downto 0) := "011";
  constant R4   : std_logic_vector(2 downto 0) := "100";
  constant R5   : std_logic_vector(2 downto 0) := "101";
  constant R6   : std_logic_vector(2 downto 0) := "110";
  constant R7   : std_logic_vector(2 downto 0) := "111";

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
      -- Palavra de Controle = SelMUX, Habilita_A, Reset_A, Operacao_ULA
      -- Inicializa os endereços:
		
tmp(0) := STA & R0 & "111111110"; --  Limpa key1
tmp(1) := STA & R0 & "111111111"; --  Limpa key0
tmp(2) := LDI & R0 & "000000000"; --  Carrega 0 no R0
tmp(3) := LDI & R1 & "000000000"; --  Carrega 0 no R1
tmp(4) := LDI & R2 & "000000000"; --  Carrega 0 no R2
tmp(5) := LDI & R3 & "000000000"; --  Carrega 0 no R3
tmp(6) := LDI & R4 & "000000000"; --  Carrega 0 no R4
tmp(7) := LDI & R5 & "000000000"; --  Carrega 0 no R5
tmp(8) := LDI & R6 & "000000000"; --  Carrega 0 no R6
tmp(9) := STA & R0 & "100100000"; --  Carrega 0 no hex0
tmp(10) := STA & R0 & "100100001"; --  Carrega 0 no hex1
tmp(11) := STA & R0 & "100100010"; --  Carrega 0 no hex2
tmp(12) := STA & R0 & "100100011"; --  Carrega 0 no hex3
tmp(13) := STA & R0 & "100100100"; --  Carrega 0 no hex4
tmp(14) := STA & R0 & "100100101"; --  Carrega 0 no hex5
tmp(15) := STA & R0 & "100000000"; --  Carrega 0 no LEDR0-7
tmp(16) := STA & R0 & "100000001"; --  Carrega 0 no LEDR8
tmp(17) := STA & R0 & "100000010"; --  Carrega 0 no LEDR9
tmp(18) := STA & R0 & "000000000"; --  Carrega 0 no endereço 0 da RAM
tmp(19) := LDI & R0 & "000000001"; -- Carrega 1 no R0
tmp(20) := STA & R0 & "000000001"; --  Carrega 1 no endereço 1 da RAM
tmp(21) := LDI & R0 & "000000010"; -- Carrega 2 no R0
tmp(22) := STA & R0 & "000000010"; --  Carrega 2 no endereço 2 da RAM
tmp(23) := LDI & R0 & "000000011"; -- Carrega 3 no R0
tmp(24) := STA & R0 & "000000011"; --  Carrega 3 no endereço 3 da RAM
tmp(25) := LDI & R0 & "000000100"; -- Carrega 4 no R0
tmp(26) := STA & R0 & "000000100"; --  Carrega 4 no endereço 4 da RAM
tmp(27) := LDI & R0 & "000000101"; -- Carrega 5 no R0
tmp(28) := STA & R0 & "000000101"; --  Carrega 5 no endereço 5 da RAM
tmp(29) := LDI & R0 & "000000110"; -- Carrega 6 no R0
tmp(30) := STA & R0 & "000000110"; --  Carrega 6 no endereço 6 da RAM
tmp(31) := LDI & R0 & "000001001"; --  Carrega 9 no imediato
tmp(32) := STA & R0 & "000001001"; --  Carrega a posição MEM[9] com o valor 9
tmp(33) := LDI & R0 & "000001010"; --  Carrega 10 no imediato
tmp(34) := STA & R0 & "000001010"; --  Carrega a posição MEM[10] com o valor 10

tmp(36) := LDA & R0 & "000000000"; -- LDA R0, @0
tmp(37) := STA & R0 & "100000010"; -- STA R0, @258
tmp(38) := LDA & R0 & "101100001"; -- LDA R0, @353
tmp(39) := CEQ & R0 & "000000000"; -- CEQ R0, @0
tmp(40) := JEQ & "000000101010"; -- JEQ %CHECKK0 42
tmp(41) := JSR & "000000110000"; -- JSR %LIMITE 48
tmp(42) := LDA & R0 & "101100000"; -- LDA R0, @352
tmp(43) := CEQ & R0 & "000000000"; -- CEQ R0, @0
tmp(44) := JEQ & "000000100100"; -- JEQ %CHECKKEYS 36
tmp(45) := JSR & "000010001101"; -- JSR %CONTADOR 141
tmp(46) := JMP & "000000100100"; -- JMP %CHECKKEYS 36

tmp(48) := STA & R0 & "111111110"; -- STA R0, @510
tmp(49) := LDI & R0 & "000000001"; -- LDI R0, $1
tmp(50) := STA & R0 & "100000010"; -- STA R0, @258
tmp(51) := LDA & R0 & "000000000"; -- LDA R0, @0
tmp(52) := STA & R0 & "100000001"; -- STA R0, @257
tmp(53) := STA & R0 & "100100000"; -- STA R0, @288
tmp(54) := STA & R0 & "100100001"; -- STA R0, @289
tmp(55) := STA & R0 & "100100010"; -- STA R0, @290
tmp(56) := STA & R0 & "100100011"; -- STA R0, @291
tmp(57) := STA & R0 & "100100100"; -- STA R0, @292
tmp(58) := STA & R0 & "100100101"; -- STA R0, @293

tmp(60) := LDI & R0 & "000000001"; -- LDI R0, $1
tmp(61) := STA & R0 & "100000000"; -- STA R0, @256
tmp(62) := LDA & R0 & "101100001"; -- LDA R0, @353
tmp(63) := CEQ & R0 & "000000000"; -- CEQ R0, @0
tmp(64) := JEQ & "000000111100"; -- JEQ %UNI 60
tmp(65) := STA & R0 & "111111110"; -- STA R0, @510
tmp(66) := LDA & R1 & "101000000"; -- LDA R1, @320
tmp(67) := CGT & R1 & "000001001"; -- CGT R1, @9
tmp(68) := JGT & "000000111100"; -- JGT %UNI 60
tmp(69) := STA & R1 & "100100000"; -- STA R1, @288

tmp(71) := LDI & R0 & "000000010"; -- LDI R0, $2
tmp(72) := STA & R0 & "100000000"; -- STA R0, @256
tmp(73) := LDA & R0 & "101100001"; -- LDA R0, @353
tmp(74) := CEQ & R0 & "000000000"; -- CEQ R0, @0
tmp(75) := JEQ & "000001000111"; -- JEQ %DEZ 71
tmp(76) := STA & R0 & "111111110"; -- STA R0, @510
tmp(77) := LDA & R2 & "101000000"; -- LDA R2, @320
tmp(78) := CGT & R2 & "000000101"; -- CGT R2, @5
tmp(79) := JGT & "000001000111"; -- JGT %DEZ 71
tmp(80) := STA & R2 & "100100001"; -- STA R2, @289

tmp(82) := LDI & R0 & "000000100"; -- LDI R0, $4
tmp(83) := STA & R0 & "100000000"; -- STA R0, @256
tmp(84) := LDA & R0 & "101100001"; -- LDA R0, @353
tmp(85) := CEQ & R0 & "000000000"; -- CEQ R0, @0
tmp(86) := JEQ & "000001010010"; -- JEQ %CEN 82
tmp(87) := STA & R0 & "111111110"; -- STA R0, @510
tmp(88) := LDA & R3 & "101000000"; -- LDA R3, @320
tmp(89) := CGT & R3 & "000001001"; -- CGT R3, @9
tmp(90) := JGT & "000001010010"; -- JGT %CEN 82
tmp(91) := STA & R3 & "100100010"; -- STA R3, @290

tmp(93) := LDI & R0 & "000001000"; -- LDI R0, $8
tmp(94) := STA & R0 & "100000000"; -- STA R0, @256
tmp(95) := LDA & R0 & "101100001"; -- LDA R0, @353
tmp(96) := CEQ & R0 & "000000000"; -- CEQ R0, @0
tmp(97) := JEQ & "000001011101"; -- JEQ %UMIL 93
tmp(98) := STA & R0 & "111111110"; -- STA R0, @510
tmp(99) := LDA & R4 & "101000000"; -- LDA R4, @320
tmp(100) := CGT & R4 & "000000101"; -- CGT R4, @5
tmp(101) := JGT & "000001011101"; -- JGT %UMIL 93
tmp(102) := STA & R4 & "100100011"; -- STA R4, @291

tmp(104) := LDI & R0 & "000010000"; -- LDI R0, $16
tmp(105) := STA & R0 & "100000000"; -- STA R0, @256
tmp(106) := LDA & R0 & "101100001"; -- LDA R0, @353
tmp(107) := CEQ & R0 & "000000000"; -- CEQ R0, @0
tmp(108) := JEQ & "000001101000"; -- JEQ %DMIL 104
tmp(109) := STA & R0 & "111111110"; -- STA R0, @510
tmp(110) := LDA & R5 & "101000000"; -- LDA R5, @320
tmp(111) := CGT & R5 & "000001001"; -- CGT R5, @9
tmp(112) := JGT & "000001101000"; -- JGT %DMIL 104
tmp(113) := STA & R5 & "100100100"; -- STA R5, @292
tmp(114) := CGT & R5 & "000000011"; -- CGT R5, @3
tmp(115) := JGT & "000010000001"; -- JGT %MAIORQUE3 129

tmp(117) := LDI & R0 & "000100000"; -- LDI R0, $32
tmp(118) := STA & R0 & "100000000"; -- STA R0, @256
tmp(119) := LDA & R0 & "101100001"; -- LDA R0, @353
tmp(120) := CEQ & R0 & "000000000"; -- CEQ R0, @0
tmp(121) := JEQ & "000001110101"; -- JEQ %CMIL 117
tmp(122) := STA & R0 & "111111110"; -- STA R0, @510
tmp(123) := LDA & R6 & "101000000"; -- LDA R6, @320
tmp(124) := CGT & R6 & "000000010"; -- CGT R6, @2
tmp(125) := JGT & "000001110101"; -- JGT %CMIL 117
tmp(126) := STA & R6 & "100100101"; -- STA R6, @293
tmp(127) := RET & "000000000000"; -- RET

tmp(129) := LDI & R0 & "000100000"; -- LDI R0, $32
tmp(130) := STA & R0 & "100000000"; -- STA R0, @256
tmp(131) := LDA & R0 & "101100001"; -- LDA R0, @353
tmp(132) := CEQ & R0 & "000000000"; -- CEQ R0, @0
tmp(133) := JEQ & "000010000001"; -- JEQ %MAIORQUE3 129
tmp(134) := STA & R0 & "111111110"; -- STA R0, @510
tmp(135) := LDA & R6 & "101000000"; -- LDA R6, @320
tmp(136) := CGT & R6 & "000000001"; -- CGT R6, @1
tmp(137) := JGT & "000010000001"; -- JGT %MAIORQUE3 129
tmp(138) := STA & R6 & "100100101"; -- STA R6, @293
tmp(139) := RET & "000000000000"; -- RET

tmp(141) := LDI & R0 & "000000000"; -- LDI R0, $0
tmp(142) := STA & R0 & "100000000"; -- STA R0, @256
tmp(143) := LDI & R0 & "000000001"; -- LDI R0, $1
tmp(144) := STA & R0 & "100000001"; -- STA R0, @257
tmp(145) := STA & R0 & "111111111"; -- STA R0, @511
tmp(146) := ADDI & R1 & "000000001"; -- ADDI R1, $1
tmp(147) := CEQ & R1 & "000001010"; -- CEQ R1, @10
tmp(148) := JEQ & "000010011000"; -- JEQ %CDEZ 152
tmp(149) := STA & R1 & "100100000"; -- STA R1, @288
tmp(150) := JMP & "000011011000"; -- JMP %EXITCONT 216

tmp(152) := LDI & R0 & "000000000"; -- LDI R0, $0
tmp(153) := STA & R0 & "100100000"; -- STA R0, @288
tmp(154) := LDI & R1 & "000000000"; -- LDI R1, $0
tmp(155) := ADDI & R2 & "000000001"; -- ADDI R2, $1
tmp(156) := CEQ & R2 & "000000110"; -- CEQ R2, @6
tmp(157) := JEQ & "000010100001"; -- JEQ %CCEN 161
tmp(158) := STA & R2 & "100100001"; -- STA R2, @289
tmp(159) := JMP & "000011011000"; -- JMP %EXITCONT1 216

tmp(161) := LDI & R0 & "000000000"; -- LDI R0, $0
tmp(162) := STA & R0 & "100100000"; -- STA R0, @288
tmp(163) := LDI & R1 & "000000000"; -- LDI R1, $0
tmp(164) := STA & R0 & "100100001"; -- STA R0, @289
tmp(165) := LDI & R2 & "000000000"; -- LDI R2, $0
tmp(166) := ADDI & R3 & "000000001"; -- ADDI R3, $1
tmp(167) := CEQ & R3 & "000001010"; -- CEQ R3, @10
tmp(168) := JEQ & "000010101100"; -- JEQ %CUMIL 172
tmp(169) := STA & R3 & "100100010"; -- STA R3, @290
tmp(170) := JMP & "000011011000"; -- JMP %EXITCONT2 216

tmp(172) := LDI & R0 & "000000000"; -- LDI R0, $0
tmp(173) := STA & R0 & "100100000"; -- STA R0, @288
tmp(174) := LDI & R1 & "000000000"; -- LDI R1, $0
tmp(175) := STA & R0 & "100100001"; -- STA R0, @289
tmp(176) := LDI & R2 & "000000000"; -- LDI R2, $0
tmp(177) := STA & R0 & "100100010"; -- STA R0, @290
tmp(178) := LDI & R3 & "000000000"; -- LDI R3, $0
tmp(179) := ADDI & R4 & "000000001"; -- ADDI R4, $1
tmp(180) := CEQ & R4 & "000000110"; -- CEQ R4, @6
tmp(181) := JEQ & "000010111001"; -- JEQ %CDMIL 185
tmp(182) := STA & R4 & "100100011"; -- STA R4, @291
tmp(183) := JMP & "000011011000"; -- JMP %EXITCONT3 216

tmp(185) := LDI & R0 & "000000000"; -- LDI R0, $0
tmp(186) := STA & R0 & "100100000"; -- STA R0, @288
tmp(187) := LDI & R1 & "000000000"; -- LDI R1, $0
tmp(188) := STA & R0 & "100100001"; -- STA R0, @289
tmp(189) := LDI & R2 & "000000000"; -- LDI R2, $0
tmp(190) := STA & R0 & "100100010"; -- STA R0, @290
tmp(191) := LDI & R3 & "000000000"; -- LDI R3, $0
tmp(192) := STA & R0 & "100100011"; -- STA R0, @291
tmp(193) := LDI & R4 & "000000000"; -- LDI R4, $0
tmp(194) := CEQ & R6 & "000000010"; -- CEQ R6, @2
tmp(195) := JEQ & "000011110001"; -- JEQ %VINTEQUATRO 241
tmp(196) := ADDI & R5 & "000000001"; -- ADDI R5, $1
tmp(197) := CEQ & R5 & "000001010"; -- CEQ R5, @10
tmp(198) := JEQ & "000011001010"; -- JEQ %CCMIL 202
tmp(199) := STA & R5 & "100100100"; -- STA R5, @292
tmp(200) := JMP & "000011011000"; -- JMP %EXITCONT4 216

tmp(202) := LDI & R0 & "000000000"; -- LDI R0, $0
tmp(203) := STA & R0 & "100100000"; -- STA R0, @288
tmp(204) := LDI & R1 & "000000000"; -- LDI R1, $0
tmp(205) := STA & R0 & "100100001"; -- STA R0, @289
tmp(206) := LDI & R2 & "000000000"; -- LDI R2, $0
tmp(207) := STA & R0 & "100100010"; -- STA R0, @290
tmp(208) := LDI & R3 & "000000000"; -- LDI R3, $0
tmp(209) := STA & R0 & "100100011"; -- STA R0, @291
tmp(210) := LDI & R4 & "000000000"; -- LDI R4, $0
tmp(211) := STA & R0 & "100100100"; -- STA R0, @292
tmp(212) := LDI & R5 & "000000000"; -- LDI R5, $0
tmp(213) := ADDI & R6 & "000000001"; -- ADDI R6, $1
tmp(214) := STA & R6 & "100100101"; -- STA R6, @293

tmp(216) := RET & "000000000000"; -- RET

tmp(218) := STA & R0 & "111111111"; -- STA R0, @511
tmp(219) := STA & R0 & "111111110"; -- STA R0, @510
tmp(220) := LDI & R0 & "000000000"; -- LDI R0, $0
tmp(221) := LDI & R1 & "000000000"; -- LDI R1, $0
tmp(222) := LDI & R2 & "000000000"; -- LDI R2, $0
tmp(223) := LDI & R3 & "000000000"; -- LDI R3, $0
tmp(224) := LDI & R4 & "000000000"; -- LDI R4, $0
tmp(225) := LDI & R5 & "000000000"; -- LDI R5, $0
tmp(226) := LDI & R6 & "000000000"; -- LDI R6, @0
tmp(227) := STA & R0 & "100000001"; -- STA R0, @257
tmp(228) := STA & R0 & "100000000"; -- STA R0, @256
tmp(229) := STA & R0 & "100000010"; -- STA R0, @258
tmp(230) := STA & R0 & "100100000"; -- STA R0, @288
tmp(231) := STA & R0 & "100100001"; -- STA R0, @289
tmp(232) := STA & R0 & "100100010"; -- STA R0, @290
tmp(233) := STA & R0 & "100100011"; -- STA R0, @291
tmp(234) := STA & R0 & "100100100"; -- STA R0, @292
tmp(235) := STA & R0 & "100100101"; -- STA R0, @293
tmp(236) := LDA & R0 & "101100000"; -- LDA R0, @352
tmp(237) := CEQ & R0 & "000000000"; -- CEQ R0, @0
tmp(238) := JEQ & "000011101100"; -- JEQ %VOLTACONTADOR 236
tmp(239) := RET & "000000000000"; -- RET

tmp(241) := ADDI & R5 & "000000001"; -- ADDI R5, $1
tmp(242) := CEQ & R5 & "000000100"; -- CEQ R5, @4
tmp(243) := JEQ & "000011011010"; -- JEQ %ERRO 218
tmp(244) := STA & R5 & "100100100"; -- STA R5, @292
tmp(245) := JMP & "000011011000"; -- JMP %EXITCONT4 216





































	












































































































	


		
		
--         tmp(0)   := LDI   & "000000000";
--			tmp(1)   := STA   & "000000000";
--			tmp(2)   := STA   & "000000010";
--			tmp(3)   := LDI   & "000000001";
--			tmp(4)   := STA  &  "000000001";
--			tmp(5)   := NOP   & "000000000";
--		   tmp(6)   := LDA   & "101100000";
--			tmp(7)   := STA   & "100100000";
--			tmp(8)   := CEQ   & "000000000";
--			tmp(9)   := JEQ   & "000001011";
--			tmp(10)   := JSR  & "000100000";
--			tmp(11)   := NOP  & "000000000";
--			tmp(12)   := JMP  & "000000101";
--			
--			tmp(32)   := STA  & "111111111";
--			tmp(33)   := LDA  & "000000010";
--			tmp(34)   := SOMA & "000000001";
--			tmp(35)  :=  STA  & "000000010";
--			tmp(36)  :=  STA  & "100000010";
--			tmp(37)  :=  RET  & "000000000";
--		  
		  
    
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;
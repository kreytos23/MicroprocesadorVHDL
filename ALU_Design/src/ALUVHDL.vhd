-------------------------------------------------------------------------------
--
-- Title       : ALUVHDL
-- Design      : ALU_Design
-- Author      : Cesar
--
-------------------------------------------------------------------------------
--
-- File        : c:\My_Designs\ALU\ALU_Design\src\ALUVHDL.vhd
-- Generated   : Fri Aug 20 17:08:01 2021
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;  
use IEEE.std_logic_unsigned.all;

entity ALUVHDL is
	port(	 
		 --Señales que usan la ALU
		 A : in STD_LOGIC_VECTOR(3 downto 0); --Entrada A
		 B : in STD_LOGIC_VECTOR(3 downto 0); --Entrada B
		 op: in STD_LOGIC_VECTOR(2 downto 0); --Seleccionador de Operació de la ALU
		 S : inout STD_LOGIC_VECTOR(3 downto 0); --Salida de la ALU
		 
		 --Flags
		 Z: out STD_LOGIC; -- Zero Flag
		 H: out STD_LOGIC; -- Medium Carry Flag
		 V: out STD_LOGIC; -- Overflow Flag
		 C: out STD_LOGIC; -- Carry Flag
		 N: out STD_LOGIC;  -- Sign Flag
		 
		 --Señales del contador de programa 
		 CIN: in STD_LOGIC; --Señal de incremento del contador	  
		 CLK: in STD_LOGIC;	--Señal de reloj para sincronizacion
		 COUT: inout STD_LOGIC; --Señal de desbordamiento de PC
		 PC: inout STD_LOGIC_VECTOR(3 DOWNTO 0); --Contador de programa
		 
		 
		 --Señales del Stack pointer
		 FE: in STD_LOGIC; --Activador del Stack
		 PUSHPOP: in STD_LOGIC; --Selector de accion en Stack
		 ST: inout STD_LOGIC_VECTOR(3 DOWNTO 0); --Salida del stack
		 
		 --Señales del Multiplexor
		 D : inout STD_LOGIC_VECTOR(3 downto 0); --Señal de entrada extra
		 Y : inout STD_LOGIC_VECTOR(3 downto 0); --Señal de salida del Multiplexor
		 SE : in STD_LOGIC_VECTOR(1 downto 0) --Selector de canal del multiplexor
		 
	     );
end ALUVHDL;


architecture ARQ_ALUVHDL of ALUVHDL is	
signal x: STD_logic_vector(3 downto 0);	--vector auxiliar
signal xm: STD_logic_vector(3 downto 0); --vector auxiliar multi
begin  
	--Operaciones que puede realizar la ALU
	WITH op SELECT 
	x<= A + B WHEN "000",
		A - B WHEN "001",
		B - A WHEN "010",
		A AND B WHEN "011",
		A OR B WHEN "100",
		A XOR B WHEN "101",
		NOT A WHEN "110",
		NOT B WHEN OTHERS;
	S<= x;	 
	
	--Estructura del multiplexor 
	WITH SE SELECT 
			xm<= PC WHEN "00",
				ST WHEN "01",
				S WHEN "10",
				D WHEN OTHERS;
	 		Y<= xm;	

flags: process (x)
begin
	--Esta es la flag Zero: Indica si la salida es igual a cero o no
	if (x = "0000") then 
		Z<= '1';
	else
		Z<= '0';
	end if;	 
	
	--Esta es la Sign Flag: Indica si la salida es negativa o no
	if(x(3) = '1') then
		N<= '1';
	else
		N<= '0';
	end if;			
	
	--Esta es la flag Medium Carry: Indica si en la operacion de la ALU hubo un acarreo medio
	H<=(A(0) AND B(0)) OR (A(1) AND B(1));	 
	
	--Esta es la flag Carry: Indica si en la operacion de la ALU hubo un acarreo final
	C<=(A(3) AND B(3)) OR (A(2) AND B(2)) OR (A(1) AND B(1)) OR (A(0) AND B(0));	
	
	--Esta es la Overflow Flag: Indica si hubo un desbordamiento en el output S
	if (B >= (16 - A)) OR (A >= (16 - B)) THEN 
		V<= '1';
	else
		V<= '0';
	END IF;
	
end process flags;	 

ContaPC: process(CLK,CIN, Y,PC) BEGIN
	IF(CLK 'event AND CLK = '1' ) THEN
		IF (CIN = '1') THEN
			PC<= Y + 1;
		ELSE
			PC<= Y;
		END IF;
	END IF;					 	
	END PROCESS ContaPC;
	
	COUT <= (CIN AND S(0) AND S(1) AND S(2) AND S(3));

StackST: process(FE,CLK,PUSHPOP,Y) BEGIN
	
	if(FE='1') then
		if(CLK'event and CLK='1') then
			if(PUSHPOP = '1')then
				ST <= Y;
			end if;
			if(PUSHPOP = '0') then
				ST<=ST;
			end if;
		end if;
	end if;
	
END PROCESS StackST;  
	
end ARQ_ALUVHDL;

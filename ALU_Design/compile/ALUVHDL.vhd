-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : ALU_Design
-- Author      : Cesar
-- Company     : Nou
--
-------------------------------------------------------------------------------
--
-- File        : C:\My_Designs\ALU\ALU_Design\compile\ALUVHDL.vhd
-- Generated   : Thu Oct 14 22:25:39 2021
-- From        : C:\My_Designs\ALU\ALU_Design\ALUVHDL.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.STD_LOGIC_UNSIGNED.all;

entity ALUVHDL is
  port(
       A : in STD_LOGIC_VECTOR(3 downto 0);
       B : in STD_LOGIC_VECTOR(3 downto 0);
       op : in STD_LOGIC_VECTOR(2 downto 0);
       Z : out STD_LOGIC;
       H : out STD_LOGIC;
       V : out STD_LOGIC;
       C : out STD_LOGIC;
       N : out STD_LOGIC;
       S : inout STD_LOGIC_VECTOR(3 downto 0);
       CIN : in STD_LOGIC;
       CLK : in STD_LOGIC;
       COUT : inout STD_LOGIC;
       PC : inout STD_LOGIC_VECTOR(3 downto 0);
       FE : in STD_LOGIC;
       PUSHPOP : in STD_LOGIC;
       ST : inout STD_LOGIC_VECTOR(3 downto 0);
       D : inout STD_LOGIC_VECTOR(3 downto 0);
       Y : inout STD_LOGIC_VECTOR(3 downto 0);
       SE : in STD_LOGIC_VECTOR(1 downto 0)
  );
end ALUVHDL;

architecture ARQ_ALUVHDL of ALUVHDL is

---- Signal declarations used on the diagram ----

signal x : STD_LOGIC_VECTOR(3 downto 0);
signal xm : STD_LOGIC_VECTOR(3 downto 0);

begin

---- Processes ----

ContaPC : process (CLK,CIN,Y,PC)
                       begin
                         if (CLK'event and CLK = '1') then
                            if (CIN = '1') then
                               PC <= Y + 1;
                            else 
                               PC <= Y;
                            end if;
                         end if;
                       end process;
                      

StackST : process (FE,CLK,PUSHPOP,Y)
                       begin
                         if (FE = '1') then
                            if (CLK'event and CLK = '1') then
                               if (PUSHPOP = '1') then
                                  ST <= Y;
                               end if;
                               if (PUSHPOP = '0') then
                                  ST <= ST;
                               end if;
                            end if;
                         end if;
                       end process;
                      

flags : process (x)
                       begin
                         if (x = "0000") then
                            Z <= '1';
                         else 
                            Z <= '0';
                         end if;
                         if (x(3) = '1') then
                            N <= '1';
                         else 
                            N <= '0';
                         end if;
                         H <= (A(0) and B(0)) or (A(1) and B(1));
                         C <= (A(3) and B(3)) or (A(2) and B(2)) or (A(1) and B(1)) or (A(0) and B(0));
                         if (B >= (16 - A)) or (A >= (16 - B)) then
                            V <= '1';
                         else 
                            V <= '0';
                         end if;
                       end process;
                      

---- User Signal Assignments ----
with op select x <= A + B when "000", A - B when "001", B - A when "010", A and B when "011", A or B when "100", A xor B when "101", not A when "110", not B when others;
S <= x;
with SE select xm <= PC when "00", ST when "01", S when "10", D when others;
Y <= xm;

----  Component instantiations  ----

COUT <= CIN and S(0) and S(1) and S(2) and S(3);


end ARQ_ALUVHDL;

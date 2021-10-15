-------------------------------------------------------------------------------
--
-- Title       : 
-- Design      : ALU_Design
-- Author      : 
-- Company     : 
--
-------------------------------------------------------------------------------
--
-- File        : C:\My_Designs\ALU\ALU_Design\compile\Multi4a1.vhd
-- Generated   : Fri Sep 24 16:51:16 2021
-- From        : C:\My_Designs\ALU\ALU_Design\src\Multi4a1.bde
-- By          : Bde2Vhdl ver. 2.6
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------
-- Design unit header --
library IEEE;
use IEEE.std_logic_1164.all;

entity Multi4a1 is
  port(
       A1 : in STD_LOGIC;
       A2 : in STD_LOGIC;
       A3 : in STD_LOGIC;
       A4 : in STD_LOGIC;
       S1 : in STD_LOGIC;
       S2 : in STD_LOGIC;
       X : out STD_LOGIC
  );
end Multi4a1;

architecture Multi4a1 of Multi4a1 is

---- Signal declarations used on the diagram ----

signal NET718 : STD_LOGIC;
signal NET788 : STD_LOGIC;
signal NET836 : STD_LOGIC;
signal NET844 : STD_LOGIC;
signal NET852 : STD_LOGIC;
signal NET860 : STD_LOGIC;

begin

----  Component instantiations  ----

NET860 <= not(NET788 and NET718 and A4);

NET844 <= not(NET788 and NET718 and A2);

NET836 <= not(NET788 and NET718 and A1);

X <= not(NET860 and NET852 and NET844 and NET836);

NET788 <= not(S1 and S1);

NET718 <= not(S2 and S2);

NET852 <= not(NET788 and NET718 and A3);


end Multi4a1;

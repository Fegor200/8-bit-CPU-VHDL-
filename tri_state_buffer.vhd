----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
-- Create Date: 10/29/2020 07:18:24 PM
-- Module Name: cpu - structural(datapath)
-- Description: CPU_LAB 3 - ECE 410 (2021)
-- Revision:
-- Revision 0.01 - File Created
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Revision 3.01 - File Modified by Antonio Andara (October 31, 2023)
-- Revision 4.01 - File Modified by Oghenefegor Enwa and Shivang Duseja(December 1, 2023)
-- Additional Comments:
-- When the output_enable line is asserted, buffer_output stores the value of buffer_input.
-- the default state of the buffer output when output_enable is low is 'Z'
-- The value stored in the output buffer will the output of this CPU. 
-----------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY tri_state_buffer IS
    PORT( output_enable : IN STD_LOGIC
        ; buffer_input  : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        ; buffer_output : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
END tri_state_buffer;

ARCHITECTURE Behavioral OF tri_state_buffer IS
BEGIN
--*************************************************************************************************
-- write a description that matches the expected behavior of the buffer
-- read the additional comments on the header for details of how the buffer works
--*************************************************************************************************
    with output_enable select
        buffer_output <= buffer_input when '1',
         (others => 'Z') when others;
END Behavioral;

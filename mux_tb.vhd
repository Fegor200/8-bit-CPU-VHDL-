----------------------------------------------------------------------------------
-- Filename : mux_tb.vhdl
-- Author : Antonio Alejandro Andara Lara
-- Date : 31-Oct-2023
-- Design Name: mux_tb
-- Project Name: ECE 410 lab 3 2023
-- Description : testbench for the multiplexer of the simple CPU design
-- Additional Comments:
-- Copyright : University of Alberta, 2023
-- License : CC0 1.0 Universal
----------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux4_tb IS
END mux4_tb;

ARCHITECTURE sim OF mux4_tb IS

    SIGNAL alu_out     : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL RF_out     : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL immediate_data     : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL user_input     : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    SIGNAL mux_sel : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
    SIGNAL mux_out : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    uut : ENTITY WORK.mux4(Dataflow)
        PORT MAP( alu_out     => alu_out
                , RF_out     => RF_out
                , immediate_data     => immediate_data
                , user_input     => user_input
                , mux_sel => mux_sel
                , mux_out => mux_out
                );

    stimulus : PROCESS
    BEGIN
        -- Setup test data
        alu_out     <= "10101010";
        RF_out     <= "11001100";
        immediate_data     <= "11110000";
        user_input     <= "00001111";

        -- Select alu_out
        mux_sel <= "00";
        WAIT FOR 20 ns;

        -- Assertion to check if output matches alu_out
        ASSERT (mux_out = alu_out)
        REPORT "Mismatch for mux_sel = 00!"
        SEVERITY ERROR;

        -- add cases for the rest of the inputs
        -- Select in1
        mux_sel <= "01";
        wait for 20 ns;
        ASSERT (mux_out = RF_out)
        REPORT "Mismatch for mux_sel = 01!"
        SEVERITY ERROR;  
       
             
        -- Select in2
        mux_sel <= "10";
        wait for 20 ns;
        ASSERT (mux_out = immediate_data)
        REPORT "Mismatch for mux_sel = 10!"
        SEVERITY ERROR;  
       
             
        -- Select in3
        mux_sel <= "11";
        wait for 20 ns;
        ASSERT (mux_out = user_input)
        REPORT "Mismatch for mux_sel = 11!"
        SEVERITY ERROR;      
        WAIT;
       
       
    END PROCESS stimulus;

END sim;

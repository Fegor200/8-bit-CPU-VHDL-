----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
-- Create Date: 10/29/2020 07:18:24 PM
-- Design Name: CONTROLLER AND DATAPATH FOR THE CPU
-- Module Name: cpu - structural
-- Description: CPU LAB 3 - ECE 410 (2021)
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.01 - File Modified by Raju Machupalli (October 31, 2021)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Revision 3.01 - File Modified by Antonio Andara (October 31, 2023)
-- Revision 4.01 - File Modified by Oghenefegor Enwa(December 1, 2023)
-- *******************************************************************************
-- Additional Comments:
-- The CPU core integrates the datapath and the controller FSM
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY cpu_core IS
---------------------------------------------------------------------------
-- finish the port declaration with the appropriate types
    PORT( clock         : IN STD_LOGIC
        ; reset         : IN STD_LOGIC
        ; enter         : IN STD_LOGIC
        ; user_input    : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        ; CPU_output    : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
        ; PC_output     : OUT STD_LOGIC_VECTOR (4 DOWNTO 0)
        ; OPCODE_output : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
        ; done          : OUT STD_LOGIC
        );
---------------------------------------------------------------------------
END cpu_core;

ARCHITECTURE Structural OF cpu_core IS
 ---------------------------------------------------------------------------
-- datapath and controller signals
---------------------------------------------------------------------------
signal mux_sel_sig         :STD_LOGIC_VECTOR(1 DOWNTO 0);
signal immediate_data_sig  :STD_LOGIC_VECTOR(7 DOWNTO 0);
signal acc_write_sig       :STD_LOGIC;
signal rf_address_sig      :STD_LOGIC_VECTOR(2 DOWNTO 0);
signal rf_write_sig        :STD_LOGIC;
signal alu_sel_sig         :STD_LOGIC_VECTOR(2 DOWNTO 0);
signal bits_rotate_sig     :STD_LOGIC_VECTOR(1 DOWNTO 0);
signal output_enable_sig   :STD_LOGIC;
signal zero_flag_sig       :STD_LOGIC;
signal positive_flag_sig   :STD_LOGIC;
signal datapath_out_sig    :STD_LOGIC_VECTOR(7 DOWNTO 0);
signal clock_div           :STD_LOGIC;


BEGIN

    -- CPU clock divider, used to slow the processing of instructions
    -- allowing for manual testing. for simulation use freq_out <= 62_500_00
    core_div : ENTITY WORK.clock_divider(Behavioral)
        GENERIC MAP (freq_out => 62_500_00)
        PORT MAP( clock => clock
                , clock_div => clock_div
                );

    controller : entity work.controller(behavioral)
                 port map(clock => clock, reset => reset, enter => enter, zero_flag => zero_flag_sig, positive_flag => positive_flag_sig,
                          PC_out => PC_output, OPCODE_output => OPCODE_output, done => done, mux_sel => mux_sel_sig,
                          immediate_data => immediate_data_sig, acc_write => acc_write_sig,
                           rf_address => rf_address_sig, rf_write => rf_write_sig, alu_sel => alu_sel_sig, bits_rotate => bits_rotate_sig,
                           output_enable => output_enable_sig );

    datapath : entity work.datapath(structural)
                port map( clock => clock, user_input => user_input, reset => reset,
                           mux_sel => mux_sel_sig, immediate_data => immediate_data_sig, acc_write => acc_write_sig,
                           rf_address => rf_address_sig, rf_write => rf_write_sig, alu_sel => alu_sel_sig, bits_rotate => bits_rotate_sig,
                           output_enable => output_enable_sig, zero_flag => zero_flag_sig, positive_flag => positive_flag_sig,
                           datapath_out => CPU_output);

END Structural;

----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
-- Create Date: 10/29/2020 07:18:24 PM
-- Design Name: DATAPATH FOR THE CPU
-- Module Name: cpu - structural(datapath)
-- Description: CPU_PART 1 OF LAB 3 - ECE 410 (2021)
-- Revision:
-- Revision 0.01 - File Created
-- Revision 1.01 - File Modified by Raju Machupalli (October 31, 2021)
-- Revision 2.01 - File Modified by Shyama Gandhi (November 2, 2021)
-- Revision 3.01 - File Modified by Antonio Andara (October 31, 2023)
-- Revision 4.01 - File Modified by Oghenefegor Enwa and Shivang Duseja  (December 1, 2023)
-- Additional Comments:
--*********************************************************************************
-- datapath module that maps all the components used... 
-----------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_misc.ALL;
USE ieee.numeric_std.ALL;

ENTITY datapath IS
    PORT( clock          : IN STD_LOGIC
        ; reset          : IN STD_LOGIC
        ; mux_sel        : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
        ; immediate_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        ; user_input     : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        ; acc_write      : IN STD_LOGIC
        ; rf_address     : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
        ; rf_write       : IN STD_LOGIC 
        ; alu_sel        : IN STD_LOGIC_VECTOR(2 DOWNTO 0)
        ; bits_rotate    : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
        ; output_enable  : IN STD_LOGIC
        ; zero_flag      : OUT STD_LOGIC
        ; positive_flag  : OUT STD_LOGIC
        ; datapath_out   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
END datapath;

ARCHITECTURE Structural OF datapath IS

SIGNAL alu_out1 : std_logic_vector (7 downto 0) := (others => '0');
SIGNAL rf_out1 : std_logic_vector (7 downto 0) := (others => '0');
SIGNAL muxout_accin: std_logic_vector (7 downto 0) := (others => '0');
SIGNAL accout_rfIn: std_logic_vector (7 downto 0) := (others => '0');
---------------------------------------------------------------------------
-- declare any necessary signals if any
---------------------------------------------------------------------------
BEGIN

    multiplexer: entity work.mux4(Dataflow)
                    PORT MAP(mux_sel => mux_sel, 
                             immediate_data => immediate_data,
                             user_input => user_input,
                             alu_out => alu_out1, 
                             rf_out => rf_out1,
                             mux_out => muxout_accin);

    accumulator: entity work.accumulator(Behavioral) 
                   PORT MAP(clock => clock,
                            reset => reset,
                            acc_write => acc_write, 
                            acc_in => muxout_accin,
                            acc_out =>accout_rfin); 

    register_file: entity work.register_file(Behavioral)
                    PORT MAP(clock => clock,
                             rf_write => rf_write,
                             rf_address => rf_address, 
                             rf_in => accout_rfin,
                             rf_out => rf_out1);

    alu: entity work.alu(Dataflow)
            PORT MAP(alu_sel => alu_sel,
                     input_b => rf_out1,
                     input_a => accout_rfin, 
                     bits_rotate => bits_rotate,
                     alu_out => alu_out1);

    tri_state_buffer: entity work.tri_state_buffer(Behavioral)
                   PORT MAP(buffer_input => accout_rfin,
                             output_enable => output_enable,
                             buffer_output => datapath_out); 

    -- add logic for calculating the zero_flag and positive_flag values
     positive_flag <= not(muxout_accin(7));
     zero_flag     <= not(muxout_accin(7) or muxout_accin(6) or muxout_accin(5) or muxout_accin(4) or muxout_accin(3) or muxout_accin(2) or muxout_accin(1) or muxout_accin(0));
END Structural;

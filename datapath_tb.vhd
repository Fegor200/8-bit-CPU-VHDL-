----------------------------------------------------------------------------------
-- Company: Department of Electrical and Computer Engineering, University of Alberta
-- Engineer: Shyama Gandhi and Bruce Cockburn
-- Create Date: 11/26/2023 07:18:24 PM
-- Description: CPU LAB 3 - ECE 410 (2023)
-- Module Name: datapath_tb - Behavioral
-- Additional Comments: Shows the movemnt of data between the interconnected devices
--                      Performs a constant addition process betweeen Accumulator and register
--                      values.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datapath_tb is
end datapath_tb;

architecture sim of datapath_tb is
    SIGNAL         clock          : STD_LOGIC;
    SIGNAL         reset          : STD_LOGIC;
    SIGNAL         mux_sel        : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL         immediate_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL         user_input     : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL         acc_write      : STD_LOGIC;
    SIGNAL         rf_address     : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL         rf_write       : STD_LOGIC ;
    SIGNAL         alu_sel        : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL         bits_rotate    : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL         output_enable  : STD_LOGIC;
    SIGNAL         zero_flag      : STD_LOGIC;
    SIGNAL         positive_flag  : STD_LOGIC;
    SIGNAL         datapath_out   : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL         CPU_output     : STD_LOGIC_VECTOR(7 DOWNTO 0);
        -- Clock period definitions
    CONSTANT clock_period : TIME := 8 ns;
begin

 datapath : entity work.datapath(structural)
             port map( clock => clock, user_input => user_input, reset => reset,
                           mux_sel => mux_sel, immediate_data => immediate_data, 
                           acc_write => acc_write, rf_address => rf_address, 
                           rf_write => rf_write, alu_sel => alu_sel, 
                           bits_rotate => bits_rotate,
                           output_enable => output_enable, zero_flag => zero_flag,
                           positive_flag => positive_flag,
                           datapath_out => CPU_output);
                           
    -- Clock process definition
    clock_process : PROCESS
    BEGIN
        clock <= '0';
        WAIT FOR clock_period/2;
        clock <= '1';
        WAIT FOR clock_period/2;
    END PROCESS;                         

testing: process
begin                          
        
        immediate_data <= "10010001";
        wait for 10 ns;
        user_input    <= "01100111";
        wait for 10 ns;
        -- Select Immediate Data
        mux_sel <= "10";
        wait for 20 ns;
        
        
--      Reset the accumulator
        reset <= '1';
        WAIT FOR 20 ns;
        reset <= '0';
        
 -- load immediate data into accumulator
        acc_write <= '1';
        WAIT FOR 20 ns;


        
--       write to the first register address
         rf_address <= "000";
         WAIT FOR 20 ns;
         
         
--       store accumulator value in register 
         rf_write <= '1';
         WAIT FOR 20 ns;
         rf_write <= '0';
         
--      select user input
         mux_sel <= "11";
         wait for 20 ns;
         
--     load user input into accumulator
        acc_write <= '1';
        WAIT FOR 20 ns;       
        
--      perform addition f Accumulator and Register values       
        alu_sel  <= "100";
        wait for 20 ns;

--      select ALU output      
        mux_sel <= "00";
        wait for 20 ns;

--      write the value into the accumulator
        acc_write <= '1';
        wait for 20 ns;
        
        
--      diaplay result
        output_enable <= '1';
        wait for 20 ns;
        wait;
        
end process;
end sim;
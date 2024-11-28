-- Entity: byte_selector
-- Architecture: structural

library IEEE;
use IEEE.std_logic_1164.all;

entity byte_selector is
    port (
        vdd : in std_logic;
        gnd : in std_logic;
        shift_register_data : in std_logic_vector(7 downto 0);
        cpu_byte : in std_logic_vector(1 downto 0);
        mem_data_read_enable : in std_logic;
        byte_offset : out std_logic_vector(1 downto 0)
    );
end entity byte_selector;

architecture structural of byte_selector is
    component mux_2x1_2bit is
        port (
            A : in std_logic_vector(1 downto 0);
            B : in std_logic_vector(1 downto 0);
            sel : in std_logic;
            output : out std_logic_vector(1 downto 0)
        );
    end component mux_2x1_2bit;

    component or_2x1 is
        port (
            A : in std_logic;
            B : in std_logic;
            output : out std_logic
        );
    end component or_2x1;


    signal or1_out, or2_out, or3_out, or4_out : std_logic;
    signal s1, s2, s3, s4 : std_logic_vector(1 downto 0);
    signal mux1_out, mux2_out, mux3_out, mux4_out : std_logic_vector(1 downto 0);
    signal or_out : std_logic_vector(1 downto 0);
    signal mux_out : std_logic_vector(1 downto 0);

    begin
        s1 <= gnd & gnd;
        s2 <= gnd & vdd;
        s3 <= vdd & gnd;
        s4 <= vdd & vdd;

        or1: or_2x1 port map(
            A => shift_register_data(0),
            B => shift_register_data(1),
            output => or1_out
        );

        or2: or_2x1 port map(
            A => shift_register_data(2),
            B => shift_register_data(3),
            output => or2_out
        );

        or3: or_2x1 port map(
            A => shift_register_data(4),
            B => shift_register_data(5),
            output => or3_out
        );

        or4: or_2x1 port map(
            A => shift_register_data(6),
            B => shift_register_data(7),
            output => or4_out
        );

        mux1: mux_2x1_2bit port map(
            A => s1,
            B => s1,
            sel => or1_out,
            output => mux1_out
        );

        mux2: mux_2x1_2bit port map(
            A => s1,
            B => s2,
            sel => or2_out,
            output => mux2_out
        );

        mux3: mux_2x1_2bit port map(
            A => s1,
            B => s3,
            sel => or3_out,
            output => mux3_out
        );

        mux4: mux_2x1_2bit port map(
            A => s1,
            B => s4,
            sel => or4_out,
            output => mux4_out
        );

        or_gate: entity work.or_4x1_2bit(Structural) port map(
            A => mux1_out,
            B => mux2_out,
            C => mux3_out,
            D => mux4_out,
            output => or_out
        );
        
        mux: entity work.mux_2x1_2bit(Structural) port map(
            A => cpu_byte,
            B => or_out,
            sel => mem_data_read_enable,
            output => mux_out
        );

        byte_offset <= mux_out;
end architecture structural;
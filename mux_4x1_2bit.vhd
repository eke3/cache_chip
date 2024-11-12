-- Entity: mux_4x1_2bit
-- Architecture: structural
-- Author:

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_4x1_2bit is
    Port (
        read_data0 : in STD_LOGIC_VECTOR(1 downto 0);    -- 2-bit input 0
        read_data1 : in STD_LOGIC_VECTOR(1 downto 0);    -- 2-bit input 1
        read_data2 : in STD_LOGIC_VECTOR(1 downto 0);    -- 2-bit input 2
        read_data3 : in STD_LOGIC_VECTOR(1 downto 0);    -- 2-bit input 3
        sel     : in STD_LOGIC_VECTOR(1 downto 0);    -- 2-bit sel signal
        F          : out STD_LOGIC_VECTOR(1 downto 0)    -- 2-bit output of the multiplexer
    );
end mux_4x1_2bit;

architecture Structural of mux_4x1_2bit is
    -- Declare the mux_4x1 component
    component mux_4x1
        Port (
            read_data0 : in STD_LOGIC;
            read_data1 : in STD_LOGIC;
            read_data2 : in STD_LOGIC;
            read_data3 : in STD_LOGIC;
            sel     : in STD_LOGIC_VECTOR(1 downto 0);
            F          : out STD_LOGIC
        );
    end component;

    -- Intermediate signals for the outputs of the two mux_4x1 instances
    signal F_bit0, F_bit1 : STD_LOGIC;

begin
    -- Instantiate the first mux_4x1 for the lower bit (bit 0)
    mux_bit0: mux_4x1 port map (
        read_data0 => read_data0(0),
        read_data1 => read_data1(0),
        read_data2 => read_data2(0),
        read_data3 => read_data3(0),
        sel     => sel,
        F          => F_bit0
    );

    -- Instantiate the second mux_4x1 for the higher bit (bit 1)
    mux_bit1: mux_4x1 port map (
        read_data0 => read_data0(1),
        read_data1 => read_data1(1),
        read_data2 => read_data2(1),
        read_data3 => read_data3(1),
        sel     => sel,
        F          => F_bit1
    );

    -- Explicitly assign the individual bits of the 2-bit output F
    F(0) <= F_bit0;
    F(1) <= F_bit1;

end Structural;
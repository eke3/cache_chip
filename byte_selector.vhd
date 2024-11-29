-- Entity: byte_selector
-- Architecture: Structural

library IEEE;
use IEEE.std_logic_1164.all;

entity byte_selector is
    port (
        vdd                 : in  std_logic;
        gnd                 : in  std_logic;
        shift_register_data : in  std_logic_vector(7 downto 0);
        byte_offset         : out std_logic_vector(1 downto 0)
    );
end entity byte_selector;

architecture Structural of byte_selector is
    component mux_2x1_2bit is
        port (
            A      : in  std_logic_vector(1 downto 0);
            B      : in  std_logic_vector(1 downto 0);
            sel    : in  std_logic;
            output : out std_logic_vector(1 downto 0)
        );
    end component mux_2x1_2bit;

    component or_2x1 is
        port (
            A      : in  std_logic;
            B      : in  std_logic;
            output : out std_logic
        );
    end component or_2x1;

    component or_4x1_2bit is
        port (
            A      : in  std_logic_vector(1 downto 0);
            B      : in  std_logic_vector(1 downto 0);
            C      : in  std_logic_vector(1 downto 0);
            D      : in  std_logic_vector(1 downto 0);
            output : out std_logic_vector(1 downto 0)
        );
    end component or_4x1_2bit;

    signal or1_out, or2_out, or3_out, or4_out     : std_logic;
    signal s1, s2, s3, s4                         : std_logic_vector(1 downto 0); -- bytes to transmit
    signal mux1_out, mux2_out, mux3_out, mux4_out : std_logic_vector(1 downto 0);
    signal or_out                                 : std_logic_vector(1 downto 0);

begin

    s1          <= (gnd, gnd);                                                    -- 00
    s2          <= (gnd, vdd);                                                    -- 01
    s3          <= (vdd, gnd);                                                    -- 10
    s4          <= (vdd, vdd);                                                    -- 11

    or1: entity work.or_2x1(Structural)
    port map (
        A      => shift_register_data(0),
        B      => shift_register_data(1),
        output => or1_out
    );

    or2: entity work.or_2x1(Structural)
    port map (
        A      => shift_register_data(2),
        B      => shift_register_data(3),
        output => or2_out
    );

    or3: entity work.or_2x1(Structural)
    port map (
        A      => shift_register_data(4),
        B      => shift_register_data(5),
        output => or3_out
    );

    or4: entity work.or_2x1(Structural)
    port map (
        A      => shift_register_data(6),
        B      => shift_register_data(7),
        output => or4_out
    );

    mux1: entity work.mux_2x1_2bit(Structural)
    port map (
        A      => s1,
        B      => s1,
        sel    => or1_out,
        output => mux1_out
    );

    mux2: entity work.mux_2x1_2bit(Structural)
    port map (
        A      => s1,
        B      => s2,
        sel    => or2_out,
        output => mux2_out
    );

    mux3: entity work.mux_2x1_2bit(Structural)
    port map (
        A      => s1,
        B      => s3,
        sel    => or3_out,
        output => mux3_out
    );

    mux4: entity work.mux_2x1_2bit(Structural)
    port map (
        A      => s1,
        B      => s4,
        sel    => or4_out,
        output => mux4_out
    );

    or_gate: entity work.or_4x1_2bit(Structural)
    port map (
        A      => mux1_out,
        B      => mux2_out,
        C      => mux3_out,
        D      => mux4_out,
        output => or_out
    );

    byte_offset <= or_out;

end architecture Structural;

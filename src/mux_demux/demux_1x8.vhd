-- Entity: demux_1x8
-- Architecture: Structural
-- Author:

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity demux_1x8 is
    port (
        data_in    : in  STD_LOGIC; -- 1-bit input data
        sel        : in  STD_LOGIC_VECTOR(2 downto 0); -- 3-bit selector
        data_out_0 : out STD_LOGIC; -- Output for selection "000"
        data_out_1 : out STD_LOGIC; -- Output for selection "001"
        data_out_2 : out STD_LOGIC; -- Output for selection "010"
        data_out_3 : out STD_LOGIC; -- Output for selection "011"
        data_out_4 : out STD_LOGIC; -- Output for selection "100"
        data_out_5 : out STD_LOGIC; -- Output for selection "101"
        data_out_6 : out STD_LOGIC; -- Output for selection "110"
        data_out_7 : out STD_LOGIC -- Output for selection "111"
    );
end entity demux_1x8;

architecture Structural of demux_1x8 is
    -- Component declarations
    component and_4x1 is
        port (
            A      : in  STD_LOGIC;
            B      : in  STD_LOGIC;
            C      : in  STD_LOGIC;
            D      : in  STD_LOGIC;
            output : out STD_LOGIC
        );
    end component and_4x1;

    component inverter is
        port (
            input  : in  STD_LOGIC;
            output : out STD_LOGIC
        );
    end component inverter;

    -- Intermediate signals for the inverted select bits
    signal sel_not : STD_LOGIC_VECTOR(2 downto 0);

begin
    -- Instantiate inverters for each bit of the selector `sel`
    gen_inv: for i in 0 to 2 generate
        inv: entity work.inverter(Structural)
        port map (
            input  => sel(i),
            output => sel_not(i)
        );
    end generate;

    -- Instantiate 8 instances of and_4x1 to control each output
    and0: entity work.and_4x1(Structural)
    port map (
        A          => data_in,
        B          => sel_not(2),
        C          => sel_not(1),
        D          => sel_not(0),
        output     => data_out_0
    );

    and1: entity work.and_4x1(Structural)
    port map (
        A          => data_in,
        B          => sel_not(2),
        C          => sel_not(1),
        D          => sel(0),
        output     => data_out_1
    );

    and2: entity work.and_4x1(Structural)
    port map (
        A          => data_in,
        B          => sel_not(2),
        C          => sel(1),
        D          => sel_not(0),
        output     => data_out_2
    );

    and3: entity work.and_4x1(Structural)
    port map (
        A          => data_in,
        B          => sel_not(2),
        C          => sel(1),
        D          => sel(0),
        output     => data_out_3
    );

    and4: entity work.and_4x1(Structural)
    port map (
        A          => data_in,
        B          => sel(2),
        C          => sel_not(1),
        D          => sel_not(0),
        output     => data_out_4
    );

    and5: entity work.and_4x1(Structural)
    port map (
        A          => data_in,
        B          => sel(2),
        C          => sel_not(1),
        D          => sel(0),
        output     => data_out_5
    );

    and6: entity work.and_4x1(Structural)
    port map (
        A          => data_in,
        B          => sel(2),
        C          => sel(1),
        D          => sel_not(0),
        output     => data_out_6
    );

    and7: entity work.and_4x1(Structural)
    port map (
        A          => data_in,
        B          => sel(2),
        C          => sel(1),
        D          => sel(0),
        output     => data_out_7
    );

end architecture Structural;
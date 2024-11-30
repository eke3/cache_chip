-- tag_comparator_2x1.vhd
-- 2-bit comparator using Structural design with valid_comparator_2x1 components

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity tag_comparator_2x1 is
    port (
        A      : in  STD_LOGIC_VECTOR(1 downto 0); -- 2-bit input A
        B      : in  STD_LOGIC_VECTOR(1 downto 0); -- 2-bit input B
        output : out STD_LOGIC -- 1 if A = B, 0 otherwise
    );
end entity tag_comparator_2x1;

architecture Structural of tag_comparator_2x1 is

    -- Component declarations
    component xnor_2x1 is
        port (
            A      : in  STD_LOGIC;
            B      : in  STD_LOGIC;
            output : out STD_LOGIC
        );
    end component xnor_2x1;

    component and_2x1 is
        port (
            A      : in  STD_LOGIC;
            B      : in  STD_LOGIC;
            output : out STD_LOGIC
        );
    end component and_2x1;

    -- Signal for intermediate XNOR results
    signal bit_equal : STD_LOGIC_VECTOR(1 downto 0);

begin
    -- Compare each bit of A and B
    gen_bit_compare: for i in 0 to 1 generate
        U: entity work.xnor_2x1(Structural)
        port map (
            A      => A(i),
            B      => B(i),
            output => bit_equal(i)
        );
    end generate;

    -- AND the results to check if both bits are equal
    U3: entity work.and_2x1(Structural)
    port map (
        A          => bit_equal(1),
        B          => bit_equal(0),
        output     => output
    );

end architecture Structural;
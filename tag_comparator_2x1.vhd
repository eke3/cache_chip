-- tag_comparator_2x1.vhd
-- 2-bit comparator using structural design with valid_comparator_2x1 components

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tag_comparator_2x1 is
    Port (
        A      : in  STD_LOGIC_VECTOR (1 downto 0);  -- 2-bit input A
        B      : in  STD_LOGIC_VECTOR (1 downto 0);  -- 2-bit input B
        output : out STD_LOGIC                        -- 1 if A = B, 0 otherwise
    );
end tag_comparator_2x1;

architecture Structural of tag_comparator_2x1 is
    -- Signals for intermediate XNOR results
    signal bit1_equal : STD_LOGIC;
    signal bit0_equal : STD_LOGIC;

    -- Component declarations
    component valid_comparator_2x1
        Port (
            A      : in  STD_LOGIC;
            B      : in  STD_LOGIC;
            output : out STD_LOGIC
        );
    end component;

    component and_2x1
        Port (
            A      : in  STD_LOGIC;
            B      : in  STD_LOGIC;
            output : out STD_LOGIC
        );
    end component;

begin
    -- Compare the most significant bit (A(1) and B(1))
    U1: valid_comparator_2x1 Port map (
        A      => A(1),
        B      => B(1),
        output => bit1_equal
    );

    -- Compare the least significant bit (A(0) and B(0))
    U2: valid_comparator_2x1 Port map (
        A      => A(0),
        B      => B(0),
        output => bit0_equal
    );

    -- AND the results to check if both bits are equal
    U3: and_2x1 Port map (
        A      => bit1_equal,
        B      => bit0_equal,
        output => output
    );

end Structural;
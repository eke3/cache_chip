-- or_4x1.vhd

library IEEE;
library STD;
use IEEE.STD_LOGIC_1164.all;

entity or_4x1 is
    port (
        A      : in  STD_LOGIC;
        B      : in  STD_LOGIC;
        C      : in  STD_LOGIC;
        D      : in  STD_LOGIC;
        output : out STD_LOGIC
    );
end entity or_4x1;

architecture Structural of or_4x1 is

begin
    output <= A or B or C or D;

end architecture Structural;

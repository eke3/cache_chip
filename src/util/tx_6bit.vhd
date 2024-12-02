-- Entity: tx_6bit
-- Architecture: Structural
-- Author:

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity tx_6bit is
    port (
        sel    : in  std_logic; -- Selector signal
        selnot : in  std_logic; -- Inverted selector signal
        input  : in  std_logic_vector(5 downto 0); -- 6-bit input data
        output : out std_logic_vector(5 downto 0) -- 6-bit output data
    );
end tx_6bit;

architecture Structural of tx_6bit is

    component tx
        port (
            sel    : in  std_logic; -- Selector signal
            selnot : in  std_logic; -- Inverted selector signal
            input  : in  std_logic; -- 1-bit input data
            output : out std_logic  -- 1-bit output data
        );
    end component;

    for all: tx use entity work.tx(Structural);

begin

    gen_tx: for i in 0 to 5 generate
        tx_instance: tx
        port map (
            sel    => sel,
            selnot => selnot,
            input  => input(i),
            output => output(i)
        );
    end generate;

end Structural;

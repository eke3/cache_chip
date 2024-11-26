library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tx_8bit is
    port (
        sel    : in  std_logic;                      -- Selector signal
        selnot : in  std_logic;                      -- Inverted selector signal
        input  : in  std_logic_vector(7 downto 0);   -- 8-bit input data
        output : out std_logic_vector(7 downto 0)    -- 8-bit output data
    );
end entity tx_8bit;

architecture structural of tx_8bit is

begin

    gen_tx: for i in 0 to 7 generate
        tx_instance: entity work.tx(structural)
        port map (
            sel    => sel,
            selnot => selnot,
            input  => input(i),
            output => output(i)
        );
    end generate gen_tx;

end architecture structural;
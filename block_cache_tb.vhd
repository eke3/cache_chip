library IEEE;
use IEEE.std_logic_1164.all;

entity block_cache_tb is
end entity block_cache_tb;

architecture Test of block_cache_tb is

    -- Test signals
    signal mem_data     : std_logic_vector(7 downto 0);
    signal hit_miss     : std_logic;
    signal R_W          : std_logic;
    signal byte_offset  : std_logic_vector(3 downto 0);
    signal block_offset : std_logic_vector(3 downto 0);
    signal cpu_data     : std_logic_vector(7 downto 0);
    signal read_data    : std_logic_vector(7 downto 0);

begin

    uut: entity work.block_cache
    port map (
        mem_data     => mem_data,
        hit_miss     => hit_miss,
        R_W          => R_W,
        byte_offset  => byte_offset,
        block_offset => block_offset,
        cpu_data     => cpu_data,
        read_data    => read_data
    );

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize signals
        mem_data     <= "10000000";
        cpu_data     <= "00000001";
        hit_miss     <= '1'; -- hit
        R_W          <= '0'; -- Write operation
        byte_offset  <= "1000";
        block_offset <= "1000";

        -- Wait for a while and then change inputs to simulate different scenarios
        wait for 20 ns;

        -- read hit
        hit_miss     <= '1';
        R_W          <= '1';
        mem_data     <= "00010000";
        cpu_data     <= "00001100";
        wait for 20 ns;

        cpu_data     <= "00000001";

        -- read miss
        hit_miss     <= '0'; -- Miss scenario
        R_W          <= '1'; -- Read operation

        wait for 20 ns;

        -- read hit
        hit_miss     <= '1'; -- Miss scenario
        R_W          <= '1'; -- Read operation
        wait for 1 ps;
        mem_data     <= "00000000";
        cpu_data     <= "00000001";


        -- Wait and finish the simulation
        wait for 20 ns;
        assert false report "Test completed" severity failure;
    end process stim_proc;

end architecture Test;

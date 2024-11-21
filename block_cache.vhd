-- Entity: block_cache
-- Architecture: structural
-- Author:

library IEEE;
use IEEE.std_logic_1164.all;

entity block_cache is
    port(   mem_data    : in std_logic_vector(7 downto 0);
--            mem_addr    : out std_logic_vector(5 downto 0);
            hit_miss    : in std_logic;
            R_W         : in std_logic;
            byte_offset : in std_logic_vector(3 downto 0);
            block_offset: in std_logic_vector(3 downto 0);
            cpu_data    : in std_logic_vector(7 downto 0);
            read_data   : out std_logic_vector(7 downto 0));
end block_cache;

architecture structural of block_cache is

    component readmiss_writehit 
    port(
        hit_miss: in std_logic;
        R_W: in std_logic;
        enable_cache_write: out std_logic
    );
    end component;
    
    component cache_cell_8bit
        port(
            write_data      : in std_logic_vector(7 downto 0);
            chip_enable    : in std_logic;
            RW              : in std_logic;
            read_data       : out std_logic_vector(7 downto 0));
    end component;

    component demux_1x16_8bit
    port (
        data_in     : in  STD_LOGIC_VECTOR(7 downto 0); -- 8-bit input data
        sel         : in  STD_LOGIC_VECTOR(3 downto 0); -- 4-bit selector (S3, S2, S1, S0)
        data_out_0  : out STD_LOGIC_VECTOR(7 downto 0); -- Output for selection "0000"
        data_out_1  : out STD_LOGIC_VECTOR(7 downto 0); -- Output for selection "0001"
        data_out_2  : out STD_LOGIC_VECTOR(7 downto 0); -- Output for selection "0010"
        data_out_3  : out STD_LOGIC_VECTOR(7 downto 0); -- Output for selection "0011"
        data_out_4  : out STD_LOGIC_VECTOR(7 downto 0); -- Output for selection "0100"
        data_out_5  : out STD_LOGIC_VECTOR(7 downto 0); -- Output for selection "0101"
        data_out_6  : out STD_LOGIC_VECTOR(7 downto 0); -- Output for selection "0110"
        data_out_7  : out STD_LOGIC_VECTOR(7 downto 0); -- Output for selection "0111"
        data_out_8  : out STD_LOGIC_VECTOR(7 downto 0); -- Output for selection "1000"
        data_out_9  : out STD_LOGIC_VECTOR(7 downto 0); -- Output for selection "1001"
        data_out_10 : out STD_LOGIC_VECTOR(7 downto 0); -- Output for selection "1010"
        data_out_11 : out STD_LOGIC_VECTOR(7 downto 0); -- Output for selection "1011"
        data_out_12 : out STD_LOGIC_VECTOR(7 downto 0); -- Output for selection "1100"
        data_out_13 : out STD_LOGIC_VECTOR(7 downto 0); -- Output for selection "1101"
        data_out_14 : out STD_LOGIC_VECTOR(7 downto 0); -- Output for selection "1110"
        data_out_15 : out STD_LOGIC_VECTOR(7 downto 0) -- Output for selection "1111"
    );
    end component;

    component data_input_selector
        port(
            cpu_data: in std_logic_vector(7 downto 0);
            mem_data: in std_logic_vector(7 downto 0);
            hit_miss: in std_logic;
            R_W:      in std_logic;
            out_data: out std_logic_vector(7 downto 0)
        );
    end component;

    component mux_16x1_8bit
        port (
            inputs : in  STD_LOGIC_VECTOR(127 downto 0);  -- 16 inputs, each 8-bit wide
            sel    : in  STD_LOGIC_VECTOR(15 downto 0);   -- 16-bit 1-hot select signal
            sel_4bit: in std_logic_vector(3 downto 0);
            output : out STD_LOGIC_VECTOR(7 downto 0)     -- 8-bit output
        );
    end component;

    component concatenator
        port(
            input_a : in std_logic_vector(1 downto 0);  -- First 2-bit input
            input_b : in std_logic_vector(1 downto 0);  -- Second 2-bit input
            output  : out std_logic_vector(3 downto 0)  -- Concatenated 4-bit output
        );
    end component;
    
    component and_2x1
        port(
            A      : in  STD_LOGIC;
            B      : in  STD_LOGIC;
            output : out STD_LOGIC
        );
    end component;
    
    component one_hot_to_binary
        port(
            one_hot : in  STD_LOGIC_VECTOR(3 downto 0); -- One-hot encoded input
            binary  : out STD_LOGIC_VECTOR(1 downto 0)  -- 2-bit binary output
        );
    end component;

    --for block_0000, block_0001, block_0010, block_0011, block_0100, block_0101, block_0110, block_0111, block_1000, block_1001, 
    --block_1010, block_1011, block_1100, block_1101, block_1110, block_1111: cache_cell_8bit use entity work.cache_cell_8bit(structural);

    for demux: demux_1x16_8bit use entity work.demux_1x16_8bit(structural);

    for data_input_selector_1: data_input_selector use entity work.data_input_selector(structural);

    for concatenator_1: concatenator use entity work.concatenator(structural);

    for convert_1, convert_2: one_hot_to_binary use entity work.one_hot_to_binary(structural);

    for enable_cache_write: readmiss_writehit use entity work.readmiss_writehit(structural);

    --signal block_off_0, block_off_1, byte_off_0, byte_off_1, sel_0, sel_1, sel_2, sel_3, sel_4, sel_5, sel_6, sel_7, sel_8, 
    --sel_9, sel_10, sel_11, sel_12, sel_13, sel_14, sel_15 : std_logic;

    signal out_data: std_logic_vector(7 downto 0);

    signal CE: std_logic_vector (15 downto 0);

    signal demux_out: std_logic_vector(127 downto 0);

    --type logic_array is array (0 to 4) of std_logic_vector(7 downto 0);
    signal read_array: std_logic_vector(127 downto 0);

    signal comb_addr: std_logic_vector(3 downto 0);

    signal block_off_bin, byte_off_bin: std_logic_vector (1 downto 0);
    
    signal cache_RW: std_logic;

begin

    gen_cell_1: for i in 0 to 3 generate
            and_1: entity work.and_2x1
                port map (
                    block_offset(0),
                    byte_offset(i),
                    CE(15-(i*1))
                );
    end generate gen_cell_1;

    gen_cell_2: for i in 0 to 3 generate
            and_2: entity work.and_2x1
                port map (
                    block_offset(1),
                    byte_offset(i),
                    CE(11-(i*1))
                );
    end generate gen_cell_2;

    gen_cell_3: for i in 0 to 3 generate
            and_3: entity work.and_2x1
                port map (
                    block_offset(2),
                    byte_offset(i),
                    CE(7-(i*1))
                );
    end generate gen_cell_3;

    gen_cell_4: for i in 0 to 3 generate
            and_4: entity work.and_2x1
                port map (
                    block_offset(3),
                    byte_offset(i),
                    CE(3-(i*1))
                );
    end generate gen_cell_4;
    
    enable_cache_write: entity work.readmiss_writehit
        port map(
            hit_miss => hit_miss,
            R_W => R_W,
            enable_cache_write => cache_RW
        );
    
    

    gen_cell_5: for i in 0 to 3 generate
        block_cell_1: entity work.cache_cell_8bit
            port map (
                demux_out(127-(8*i) downto 127-(8*i)-7),
                CE(15-((i)*1)), --15
                cache_RW,
                read_array(127-(8*i) downto 127-(8*i)-7)
            );
    end generate gen_cell_5;

    gen_cell_6: for i in 0 to 3 generate
        block_cell_2: entity work.cache_cell_8bit
            port map (
                demux_out(95-(8*i) downto 95-(8*i)-7),
                CE(11-((i)*1)), --11
                cache_RW,
                read_array(95-(8*i) downto 95-(8*i)-7)
            );
    end generate gen_cell_6;

    gen_cell_7: for i in 0 to 3 generate
        block_cell_3: entity work.cache_cell_8bit
            port map (
                demux_out(63-(8*i) downto 63-(8*i)-7),
                CE(7-((i)*1)), --7
                cache_RW,
                read_array(63-(8*i) downto 63-(8*i)-7)
            );
    end generate gen_cell_7;

    gen_cell_8: for i in 0 to 3 generate
        block_cell_4: entity work.cache_cell_8bit
            port map (
                demux_out(31-(8*i) downto 31-(8*i)-7),
                CE(3-((i)*1)), --3
                cache_RW,
                read_array(31-(8*i) downto 31-(8*i)-7)
            );
    end generate gen_cell_8;

    demux: entity work.demux_1x16_8bit port map(
        out_data,
        comb_addr,
        demux_out(127 downto 120),
        demux_out(119 downto 112),
        demux_out(111 downto 104),
        demux_out(103 downto 96),
        demux_out(95 downto 88),
        demux_out(87 downto 80),
        demux_out(79 downto 72),
        demux_out(71 downto 64),
        demux_out(63 downto 56),
        demux_out(55 downto 48),
        demux_out(47 downto 40),
        demux_out(39 downto 32),
        demux_out(31 downto 24),
        demux_out(23 downto 16),
        demux_out(15 downto 8),
        demux_out(7 downto 0)   
    );

    data_input_selector_1: entity work.data_input_selector port map(
        cpu_data,
        mem_data,
        hit_miss,
        R_W,
        out_data
    );

    mux: entity work.mux_16x1_8bit port map(
        read_array, -- 16 inputs, each 8-bit wide
        CE,   -- 4-bit select signal
        comb_addr,
        read_data     -- 8-bit output
    );

    convert_1: entity work.one_hot_to_binary port map(
        block_offset,
        block_off_bin
    );

    convert_2: entity work.one_hot_to_binary port map(
        byte_offset,
        byte_off_bin
    );

    concatenator_1: entity work.concatenator port map(
        block_off_bin,
        byte_off_bin,
        comb_addr
    );

end architecture structural;


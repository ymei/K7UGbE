--------------------------------------------------------------------------------
--! @file pattern_over_fifo.vhd
--! @brief Generate test pattern and drive through a FIFO
--! @author Yuan Mei
--!
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
LIBRARY UNISIM;
USE UNISIM.VComponents.ALL;

LIBRARY UNIMACRO;
USE UNIMACRO.VComponents.ALL;

ENTITY pattern_over_fifo IS
  GENERIC (
    FIFO_DEVICE : string  := "7SERIES";  --! target device for FIFO: "VIRTEX5", "VIRTEX6", "7SERIES"
    DATA_WIDTH  : integer := 32
  );
  PORT (
    RESET           : IN  std_logic;
    CLK             : IN  std_logic;
    START           : IN  std_logic;    --! start signal: a pulse that can be
                                        --! of any length longer than 1 CLK cycle.
                                        --! Also resets the internal counter to 0.
    FIFO_FULL_LATCH : OUT std_logic;    --! latches at '1' when FIFO is full,
                                        --! unlatches only when reset.
    FIFO_DOUT       : OUT std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
    FIFO_EMPTY      : OUT std_logic;
    FIFO_RDEN       : IN  std_logic;
    FIFO_RDCLK      : IN  std_logic
  );
END pattern_over_fifo;

ARCHITECTURE Behavioral OF pattern_over_fifo IS

  COMPONENT edge_sync IS
    GENERIC (
      EDGE : std_logic := '1'  --! '1'  :  rising edge,  '0' falling edge
    );
    PORT (
      RESET : IN  std_logic;
      CLK   : IN  std_logic;
      EI    : IN  std_logic;
      SO    : OUT std_logic
    );
  END COMPONENT;
  COMPONENT fifo36x512
    PORT (
      rst    : IN  std_logic;
      wr_clk : IN  std_logic;
      rd_clk : IN  std_logic;
      din    : IN  std_logic_vector(35 DOWNTO 0);
      wr_en  : IN  std_logic;
      rd_en  : IN  std_logic;
      dout   : OUT std_logic_vector(35 DOWNTO 0);
      full   : OUT std_logic;
      empty  : OUT std_logic
    );
  END COMPONENT;
  --
  SIGNAL fifo_din     : std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
  SIGNAL fifo36_din   : std_logic_vector(35 DOWNTO 0);
  SIGNAL fifo36_dout  : std_logic_vector(35 DOWNTO 0);
  SIGNAL fifo_wrclk   : std_logic;
  SIGNAL fifo_wren    : std_logic;
  SIGNAL fifo_full    : std_logic;
  SIGNAL fifo_reset   : std_logic;
  SIGNAL fifo_reset1  : std_logic;
  SIGNAL fifo_rdcount : std_logic_vector(8 DOWNTO 0);
  SIGNAL fifo_wrcount : std_logic_vector(8 DOWNTO 0);
  SIGNAL start_pulse  : std_logic;
  --
  SIGNAL prev         : std_logic;
  SIGNAL prev1        : std_logic;

BEGIN

  --!!!
  --!!! FIFO MACRO doesn't work on Kintex-7 Ultrascale!
  --!!!
  -- FIFO_DUALCLOCK_MACRO: Dual-Clock First-In, First-Out (FIFO) RAM Buffer
  --                       Kintex-7
  -- Xilinx HDL Language Template, version 2015.4
  -- Note -  This Unimacro model assumes the port directions to be "downto". 
  --         Simulation of this model with "to" in the port directions
  --         could lead to erroneous results.
  -----------------------------------------------------------------
  -- DATA_WIDTH | FIFO_SIZE | FIFO Depth | RDCOUNT/WRCOUNT Width --
  -- ===========|===========|============|=======================--
  --   37-72    |  "36Kb"   |     512    |         9-bit         --
  --   19-36    |  "36Kb"   |    1024    |        10-bit         --
  --   19-36    |  "18Kb"   |     512    |         9-bit         --
  --   10-18    |  "36Kb"   |    2048    |        11-bit         --
  --   10-18    |  "18Kb"   |    1024    |        10-bit         --
  --    5-9     |  "36Kb"   |    4096    |        12-bit         --
  --    5-9     |  "18Kb"   |    2048    |        11-bit         --
  --    1-4     |  "36Kb"   |    8192    |        13-bit         --
  --    1-4     |  "18Kb"   |    4096    |        12-bit         --
  -----------------------------------------------------------------
  -- FIFO_DUALCLOCK_MACRO_inst : FIFO_DUALCLOCK_MACRO
  --   GENERIC MAP (
  --     DEVICE                  => FIFO_DEVICE,  -- Target Device: "VIRTEX5", "VIRTEX6", "7SERIES"
  --     ALMOST_FULL_OFFSET      => X"0080",  -- Sets almost full threshold
  --     ALMOST_EMPTY_OFFSET     => X"0080",  -- Sets the almost empty threshold
  --     DATA_WIDTH              => DATA_WIDTH,  -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
  --     FIFO_SIZE               => "18Kb",   -- Target BRAM, "18Kb" or "36Kb" 
  --     FIRST_WORD_FALL_THROUGH => true   -- Sets the FIFO FWFT to TRUE or FALSE
  --   )
  --   PORT MAP (
  --     ALMOSTEMPTY => OPEN,              -- 1-bit output almost empty
  --     ALMOSTFULL  => OPEN,              -- 1-bit output almost full
  --     DO          => FIFO_DOUT,  -- Output data, width defined by DATA_WIDTH parameter
  --     EMPTY       => FIFO_EMPTY,        -- 1-bit output empty
  --     FULL        => fifo_full,         -- 1-bit output full
  --     RDCOUNT     => fifo_rdcount,      -- Output read count, width determined by FIFO depth
  --     RDERR       => OPEN,              -- 1-bit output read error
  --     WRCOUNT     => fifo_wrcount,      -- Output write count, width determined by FIFO depth
  --     WRERR       => OPEN,              -- 1-bit output write error
  --     DI          => fifo_din,  -- Input data, width defined by DATA_WIDTH parameter
  --     RDCLK       => FIFO_RDCLK,        -- 1-bit input read clock
  --     RDEN        => FIFO_RDEN,         -- 1-bit input read enable
  --     RST         => fifo_reset,        -- 1-bit input reset
  --     WRCLK       => fifo_wrclk,        -- 1-bit input write clock
  --     WREN        => fifo_wren          -- 1-bit input write enable
  --   );

  fifo_inst : fifo36x512
    PORT MAP (
      rst    => fifo_reset,
      wr_clk => fifo_wrclk,
      rd_clk => FIFO_RDCLK,
      din    => fifo36_din,
      wr_en  => fifo_wren,
      rd_en  => FIFO_RDEN,
      dout   => fifo36_dout,
      full   => fifo_full,
      empty  => FIFO_EMPTY
    );
  fifo36_din <= x"0" & fifo_din;
  FIFO_DOUT  <= fifo36_dout(DATA_WIDTH-1 DOWNTO 0);

  start_edge_sync_inst : edge_sync
    PORT MAP (
      RESET => RESET,
      CLK   => CLK,
      EI    => START,
      SO    => start_pulse
    );

  -- write pattern into fifo
  fifo_wrclk <= CLK;
  PROCESS (fifo_wrclk, RESET) IS
    VARIABLE cnt  : unsigned(DATA_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    VARIABLE fcnt : unsigned(2 DOWNTO 0) := (OTHERS => '0');
    VARIABLE frst : std_logic;
  BEGIN  -- PROCESS
    IF RESET = '1' THEN
      cnt         := (OTHERS => '0');
      fcnt        := (OTHERS => '0');
      frst        := '0';
      fifo_wren   <= '0';
      fifo_reset1 <= '0';
    ELSIF rising_edge(fifo_wrclk) THEN
      fifo_wren <= '0';
      IF start_pulse = '1' THEN
        cnt         := (OTHERS => '0');
        fcnt        := (OTHERS => '0');
        frst        := '1';
        fifo_reset1 <= '1';
      END IF;
      fifo_din <= std_logic_vector(cnt);
      IF fifo_full = '0' AND frst = '0' THEN
        fifo_wren <= '1';
        cnt       := cnt + 1;
      END IF;
      IF frst = '1' THEN
        fcnt      := fcnt + 1;
        fifo_wren <= '0';
      END IF;
      IF fcnt = "110" THEN
        fifo_reset1 <= '0';
      END IF;
      IF fcnt = "111" THEN
        frst := '0';
      END IF;
    END IF;
  END PROCESS;
  fifo_reset <= fifo_reset1 OR RESET;

  -- latch on fifo_full
  PROCESS (fifo_wrclk, RESET, start_pulse) IS
  BEGIN
    IF RESET = '1' OR start_pulse = '1' THEN
      prev            <= '0';
      prev1           <= '0';
      FIFO_FULL_LATCH <= '0';
    ELSIF rising_edge(fifo_wrclk) THEN
      prev  <= fifo_full;
      prev1 <= prev;
      IF prev1 = '0' AND prev = '1' THEN
        FIFO_FULL_LATCH <= '1';
      END IF;
    END IF;
  END PROCESS;

END Behavioral;

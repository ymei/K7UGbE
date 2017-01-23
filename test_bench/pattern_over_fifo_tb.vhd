--------------------------------------------------------------------------------
--! @file pattern_over_fifo_tb.vhd
--! @brief Testbench for pattern_over_fifo
--! @author Yuan Mei
--!
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
LIBRARY UNISIM;
USE UNISIM.VComponents.ALL;

ENTITY pattern_over_fifo_tb IS
END pattern_over_fifo_tb;

ARCHITECTURE Behavioral OF pattern_over_fifo_tb IS

  COMPONENT pattern_over_fifo IS
    GENERIC (
      FIFO_DEVICE : string  := "7SERIES";  --! target device for FIFO: "VIRTEX5", "VIRTEX6", "7SERIES"
      DATA_WIDTH  : integer := 32
    );
    PORT (
      RESET           : IN  std_logic;
      CLK             : IN  std_logic;
      START           : IN  std_logic;  --! start SIGNAL: a pulse that can be
                                        --! of any length longer than 1 CLK cycle.
                                        --! Also resets the internal counter TO 0.
      FIFO_FULL_LATCH : OUT std_logic;  --! latches at '1' when FIFO is full,
                                        --! unlatches only when reset.
      FIFO_DOUT       : OUT std_logic_vector(DATA_WIDTH-1 DOWNTO 0);
      FIFO_EMPTY      : OUT std_logic;
      FIFO_RDEN       : IN  std_logic;
      FIFO_RDCLK      : IN  std_logic
    );
  END COMPONENT;

  SIGNAL CLK                : std_logic := '0';
  SIGNAL RESET              : std_logic := '0';
  --
  SIGNAL START              : std_logic := '0';
  SIGNAL FIFO_FULL_LATCH    : std_logic;
  SIGNAL FIFO_DOUT          : std_logic_vector(31 DOWNTO 0);
  SIGNAL FIFO_RDCLK         : std_logic;
  SIGNAL FIFO_EMPTY         : std_logic;
  SIGNAL FIFO_RDEN          : std_logic := '0';

  -- Clock period definitions
  CONSTANT CLK_period               : time := 10 ns;
  CONSTANT FIFO_RDCLK_period        : time := 5 ns;

BEGIN
  -- Instantiate the Unit Under Test (UUT)
  uut : pattern_over_fifo
    PORT MAP (
      RESET           => RESET,
      CLK             => CLK,
      START           => START,
      FIFO_FULL_LATCH => FIFO_FULL_LATCH,
      FIFO_DOUT       => FIFO_DOUT,
      FIFO_EMPTY      => FIFO_EMPTY,
      FIFO_RDEN       => FIFO_RDEN,
      FIFO_RDCLK      => FIFO_RDCLK
    );

  -- Clock process definitions
  CLK_process : PROCESS
  BEGIN
    CLK <= '0';
    WAIT FOR CLK_period/2;
    CLK <= '1';
    WAIT FOR CLK_period/2;
  END PROCESS;

  CLKOUT_process : PROCESS
  BEGIN
    FIFO_RDCLK <= '0';
    WAIT FOR FIFO_RDCLK_period/2;
    FIFO_RDCLK <= '1';
    WAIT FOR FIFO_RDCLK_period/2;
  END PROCESS;

  -- Stimulus process
  stim_proc : PROCESS
  BEGIN
    -- hold reset state
    RESET      <= '0';
    WAIT FOR 1 ns;
    RESET      <= '1';
    WAIT FOR CLK_period*2;
    RESET      <= '0';
    WAIT FOR CLK_period*3;
    --
    START <= '1';
    WAIT FOR CLK_period*3;
    START <= '0';
    --
    WAIT FOR CLK_period*521;
    FIFO_RDEN <= '1';
    WAIT FOR CLK_period*1;
    FIFO_RDEN <= '0';
    --
    WAIT FOR CLK_period*10;
    START <= '1';
    WAIT FOR CLK_period*1;
    START <= '0';    
    WAIT;
  END PROCESS;

END Behavioral;

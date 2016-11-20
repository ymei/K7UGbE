
# 300MHz onboard diff clock
create_clock -name system_clock -period 3.3333333333333 [get_ports {SYS_CLK_P}]
# 156.25MHz
create_clock -name user_clock   -period 6.4 [get_ports {USER_CLK_P}]
# 125MHz
create_clock -name sys125_clock -period 8.0 [get_ports {SYS125_CLK_P}]

# SYS_CLK has external 100Ohm TERM
# IO_L12P_T1U_N10_GC_45_AK17
set_property PACKAGE_PIN AK17 [get_ports {SYS_CLK_P}]
set_property IOSTANDARD LVDS [get_ports {SYS_CLK_P}]
# IO_L12N_T1U_N11_GC_45_AK16
set_property PACKAGE_PIN AK16 [get_ports {SYS_CLK_N}]
set_property IOSTANDARD LVDS [get_ports {SYS_CLK_N}]

# DIFF_TERM="TRUE"
set_property PACKAGE_PIN G10 [get_ports {SYS125_CLK_P}]
set_property IOSTANDARD LVDS [get_ports {SYS125_CLK_P}]
set_property PACKAGE_PIN F10 [get_ports {SYS125_CLK_N}]
set_property IOSTANDARD LVDS [get_ports {SYS125_CLK_N}]

# DIFF_TERM="TRUE"
set_property PACKAGE_PIN M25 [get_ports {USER_CLK_P}]
set_property IOSTANDARD LVDS_25 [get_ports {USER_CLK_P}]
set_property PACKAGE_PIN M26 [get_ports {USER_CLK_N}]
set_property IOSTANDARD LVDS_25 [get_ports {USER_CLK_N}]

#<-- LEDs, buttons and switches --<
# SW5 CPU_RESET
# set_property VCCAUX_IO DONTCARE [get_ports {SYS_RST}]
set_property SLEW SLOW [get_ports {SYS_RST}]
set_property IOSTANDARD LVCMOS18 [get_ports {SYS_RST}]
set_property LOC AN8 [get_ports {SYS_RST}]

# LED:
# Bank: - GPIO_LED_0_LS
set_property DRIVE 12 [get_ports {LED8Bit[0]}]
set_property SLEW SLOW [get_ports {LED8Bit[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED8Bit[0]}]
set_property LOC AP8 [get_ports {LED8Bit[0]}]

# Bank: - GPIO_LED_1_LS
set_property DRIVE 12 [get_ports {LED8Bit[1]}]
set_property SLEW SLOW [get_ports {LED8Bit[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED8Bit[1]}]
set_property LOC H23 [get_ports {LED8Bit[1]}]

# Bank: - GPIO_LED_2_LS
set_property DRIVE 12 [get_ports {LED8Bit[2]}]
set_property SLEW SLOW [get_ports {LED8Bit[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED8Bit[2]}]
set_property LOC P20 [get_ports {LED8Bit[2]}]

# Bank: - GPIO_LED_3_LS
set_property DRIVE 12 [get_ports {LED8Bit[3]}]
set_property SLEW SLOW [get_ports {LED8Bit[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED8Bit[3]}]
set_property LOC P21 [get_ports {LED8Bit[3]}]

# Bank: - GPIO_LED_4_LS
set_property DRIVE 12 [get_ports {LED8Bit[4]}]
set_property SLEW SLOW [get_ports {LED8Bit[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED8Bit[4]}]
set_property LOC N22 [get_ports {LED8Bit[4]}]

# Bank: - GPIO_LED_5_LS
set_property DRIVE 12 [get_ports {LED8Bit[5]}]
set_property SLEW SLOW [get_ports {LED8Bit[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED8Bit[5]}]
set_property LOC M22 [get_ports {LED8Bit[5]}]

# Bank: - GPIO_LED_6_LS
set_property DRIVE 12 [get_ports {LED8Bit[6]}]
set_property SLEW SLOW [get_ports {LED8Bit[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED8Bit[6]}]
set_property LOC R23 [get_ports {LED8Bit[6]}]

# Bank: - GPIO_LED_7_LS
set_property DRIVE 12 [get_ports {LED8Bit[7]}]
set_property SLEW SLOW [get_ports {LED8Bit[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {LED8Bit[7]}]
set_property LOC P23 [get_ports {LED8Bit[7]}]

# GPIO_DIP_SW0
set_property SLEW SLOW [get_ports {DIPSw4Bit[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {DIPSw4Bit[0]}]
set_property LOC AN16 [get_ports {DIPSw4Bit[0]}]

# GPIO_DIP_SW1
set_property SLEW SLOW [get_ports {DIPSw4Bit[1]}]
set_property IOSTANDARD LVCMOS12 [get_ports {DIPSw4Bit[1]}]
set_property LOC AN19 [get_ports {DIPSw4Bit[1]}]

# GPIO_DIP_SW2
set_property SLEW SLOW [get_ports {DIPSw4Bit[2]}]
set_property IOSTANDARD LVCMOS12 [get_ports {DIPSw4Bit[2]}]
set_property LOC AP18 [get_ports {DIPSw4Bit[2]}]

# GPIO_DIP_SW3
set_property SLEW SLOW [get_ports {DIPSw4Bit[3]}]
set_property IOSTANDARD LVCMOS12 [get_ports {DIPSw4Bit[3]}]
set_property LOC AN14 [get_ports {DIPSw4Bit[3]}]

# GPIO_SW_N : SW10
set_property SLEW SLOW [get_ports {BTN5Bit[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {BTN5Bit[0]}]
set_property LOC AD10 [get_ports {BTN5Bit[0]}]

# GPIO_SW_E : SW9
set_property SLEW SLOW [get_ports {BTN5Bit[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {BTN5Bit[1]}]
set_property LOC AE8 [get_ports {BTN5Bit[1]}]

# GPIO_SW_S : SW8
set_property SLEW SLOW [get_ports {BTN5Bit[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {BTN5Bit[2]}]
set_property LOC AF8 [get_ports {BTN5Bit[2]}]

# GPIO_SW_C : SW7
set_property SLEW SLOW [get_ports {BTN5Bit[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {BTN5Bit[3]}]
set_property LOC AE10 [get_ports {BTN5Bit[3]}]

# GPIO_SW_W : SW6
set_property SLEW SLOW [get_ports {BTN5Bit[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {BTN5Bit[4]}]
set_property LOC AF9 [get_ports {BTN5Bit[4]}]

#>-- LEDs, buttons and switches -->

#<-- UART --<

set_property PACKAGE_PIN G25 [get_ports {USB_RX}]
set_property IOSTANDARD LVCMOS18 [get_ports {USB_RX}]
#
set_property PACKAGE_PIN K26 [get_ports {USB_TX}]
set_property IOSTANDARD LVCMOS18 [get_ports {USB_TX}]
#
set_property PACKAGE_PIN K27 [get_ports {USB_RTS}]
set_property IOSTANDARD LVCMOS18 [get_ports {USB_RTS}]
#
set_property PACKAGE_PIN L23 [get_ports {USB_CTS}]
set_property IOSTANDARD LVCMOS18 [get_ports {USB_CTS}]

#>-- UART -->

#<-- gigabit eth interface --<

set_property PACKAGE_PIN J23      [get_ports PHY_RESET_N]
set_property IOSTANDARD  LVCMOS18 [get_ports PHY_RESET_N]
set_property PACKAGE_PIN H26      [get_ports MDIO]
set_property IOSTANDARD  LVCMOS18 [get_ports MDIO]
set_property PACKAGE_PIN L25      [get_ports MDC]
set_property IOSTANDARD  LVCMOS18 [get_ports MDC]

set_property PACKAGE_PIN P26      [get_ports SGMII_CLK_P]
set_property IOSTANDARD  LVDS_25  [get_ports SGMII_CLK_P]
set_property PACKAGE_PIN N26      [get_ports SGMII_CLK_N]
set_property IOSTANDARD  LVDS_25  [get_ports SGMII_CLK_N]

set_property PACKAGE_PIN P24      [get_ports SGMII_RX_P]
set_property IOSTANDARD  DIFF_HSTL_I_18 [get_ports SGMII_RX_P]
set_property PACKAGE_PIN P25      [get_ports SGMII_RX_N]
set_property IOSTANDARD  DIFF_HSTL_I_18 [get_ports SGMII_RX_N]

set_property PACKAGE_PIN N24      [get_ports SGMII_TX_P]
set_property IOSTANDARD  DIFF_HSTL_I_18 [get_ports SGMII_TX_P]
set_property PACKAGE_PIN M24      [get_ports SGMII_TX_N]
set_property IOSTANDARD  DIFF_HSTL_I_18 [get_ports SGMII_TX_N]

#>-- gigabit eth interface -->

# Local Variables:
# mode: tcl
# End:

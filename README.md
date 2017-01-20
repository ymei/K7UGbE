# KCU105 based control and data acquisition

## gig_ethernet_pcs_pma_0 (V15.1)

* Clear Board Parameters
* Data Rate 1G
* Standard SGMII
* Core Functiionality
** LVDS Serial
** Ref Clk 625MHz
* Management Options
** NO MDIO
** Yes Auto Negotiation
* NO SGMII PHY Mode
* Include Shared Logic in Core

## tri_mode_ethernet_mac_0 (V9.0)

* Clear Board Parameters
* Data Rate 1G
* Interface
** PHY Interface: internal
** MAC Speed: 1000Mbps
** Management Type: AXI4-Lite, Frequency 125.00MHz
** YES MDIO and IO Buffers
* Features
** Check Statistics (and Reset) only

## Generate the project after git clone:
Make sure there are following lines in config/project.tcl:
```
    # Create project
    create_project top ./
```
then
``` 
    mkdir top; cd top/
    vivado -mode tcl -source ../config/project.tcl
# open GUI
    start_gui
# start synthesis
    launch_runs synth_1 -jobs 8
# start implementation
    launch_runs -jobs 8 impl_1 -to_step write_bitstream
# or do everything in tcl terminal
    open_project /path/to/example.xpr
    launch_runs -jobs 8 impl_1 -to_step write_bitstream
    wait_on_run impl_1
    exit
```

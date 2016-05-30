source ./pt_cmds.tcl
#########################################################
### add design information here
set power_enable_analysis TRUE
set power_analysis_mode averaged

set design  pci_bridge32

set timing_remove_clock_reconvergence_pessimism true

set search_path ". "
set link_path [list * /home/linux/ieng6/ee260b/public/data/libraries/lib/contest.db]

read_verilog ./${design}.v
current_design $design 
link_design $design 
read_sdc ./${design}.sdc
set_propagated_clock clk 
read_parasitics ./${design}.spef

set report_default_significant_digits 6
set timing_save_pin_arrival_and_slack true
set timing_report_always_use_valid_start_end_points false

check_timing

source size4.tcl

exit

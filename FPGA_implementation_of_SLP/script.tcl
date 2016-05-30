############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 2015 Xilinx Inc. All rights reserved.
############################################################
open_project slp_func
set_top slp_func
add_files slp_func.h
add_files slp_func.cpp
add_files -tb train-labels.idx1-ubyte
add_files -tb train-images.idx3-ubyte
add_files -tb slp_test.cpp
open_solution "solution1"
set_part {xc7z020clg484-1}
create_clock -period 10 -name default
source "./slp_func/solution1/directives.tcl"
csim_design
csynth_design
cosim_design
export_design -format ip_catalog

#Assemble the Design Source files
read_verilog [glob src/*.v]
#read_vhdl [glob ../src/*.vhd]
#read_edif ../netlist/black_blox.edf
#read_xdc ../constraint/top.xdc


#Run Synthesis and Implementation
synth_design -top data_align -part xc7a100tfgg484-2
write_checkpoint -force post_synth.dcp
opt_design
place_design
write_checkpoint -force post_place.dcp
route_design
write_checkpoint -force post_route.dcp


#Generate Reports
report_utilization -hierarchical -verbose  -file utilization_summary.rpt
report_timing_summary -file timing_summary.rpt

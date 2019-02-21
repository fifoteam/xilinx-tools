
# set basic info

if {[info exists LOOP]} {
	puts	"add_ip.tcl top has been defined******"
} else {
	set top addr_buffer_w36d512_pe64_pf506
	open_project ./managed_ip_project/managed_ip_project.xpr
}




# add ip file
add_files -norecurse ./$top/$top.xci

# export ip status
#export_ip_user_files -of_objects  [get_files  ./$top/$top.xci] -lib_map_path [list {modelsim=./managed_ip_project/managed_ip_project.cache/compile_simlib/modelsim} {questa=./managed_ip_project/managed_ip_project.cache/compile_simlib/questa} {riviera=./managed_ip_project/managed_ip_project.cache/compile_simlib/riviera} {activehdl=./managed_ip_project/managed_ip_project.cache/compile_simlib/activehdl}] -force -quiet

if {[info exists LOOP]} {
	puts	"add_ip.tcl top has been defined******"
} else {
	close_project
}





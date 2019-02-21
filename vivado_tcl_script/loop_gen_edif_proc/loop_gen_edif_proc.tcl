
proc	add_ip {top} {
	add_files -norecurse ./$top/$top.xci
}


proc	gen_ip {top} {
	generate_target all [get_files  ./$top/$top.xci]
	catch { config_ip_cache -export [get_ips -all $top] }
	export_ip_user_files -of_objects [get_files ./$top/$top.xci] -no_script -sync -force -quiet
	create_ip_run [get_files -of_objects [get_fileset sources_1] ./$top/$top.xci]
	export_simulation -of_objects [get_files ./$top/$top.xci] -directory ./ip_user_files/sim_scripts -ip_user_files_dir ./ip_user_files -ipstatic_source_dir ./ip_user_files/ipstatic -lib_map_path [list {modelsim=./managed_ip_project.cache/compile_simlib/modelsim} {questa=./managed_ip_project.cache/compile_simlib/questa} {riviera=./A7_IP/managed_ip_project.cache/compile_simlib/riviera} {activehdl=./managed_ip_project.cache/compile_simlib/activehdl}] -use_ip_compiled_libs -force -quiet
}

proc	gen_edif {top} {
	# define output dir
	set outputdir ./$top
	file mkdir $outputdir
	# read ip files to memory
	read_ip [glob -nocomplain ./$top/$top.xci]
	# Synth_design
	synth_design -rtl -name rtl_1 -top $top
	write_edif $outputdir/$top.edn
}



##-------------------------------------------------------------------------------------------------
##
##  -- 模块描述     : loop.tcl完成两个任务
##              1)  : loop.tcl依次调用gen_edif.tcl，循环产生每个edif
##
##              2)  :
##
##-------------------------------------------------------------------------------------------------




##	===============================================================================================
##	请修改以下信息
##	===============================================================================================

##	-------------------------------------------------------------------------------------
##	在设置 top 数组之前，先取消数组，避免重复设置
##	-------------------------------------------------------------------------------------
if {[info exists top_array]} {
	unset top_array
}

##	-------------------------------------------------------------------------------------
##	定义 top 数组
##	-------------------------------------------------------------------------------------

set top_array(00)  resend_fifo_narrow
set top_array(01)  resend_fifo_narrow_bram


set part xc7a100tfgg484-2




##	===============================================================================================
##	以下不要修改
##	===============================================================================================
##	-------------------------------------------------------------------------------------
##	设置LOOP为1，表示在LOOP模式下启动
##	-------------------------------------------------------------------------------------
set LOOP	1




###	-------------------------------------------------------------------------------------
###	清空 managed_ip_project 文件夹
###	重新拿一个新的manageip的文件夹
###	-------------------------------------------------------------------------------------
#file delete -force managed_ip_project
#file copy f:/kuaipan/kuaipan/FifoTeam/bat-tools/template_bat/vivado_ip_template/xc7a100tfgg484-2/managed_ip_project 	./


file delete -force managed_ip_project
file mkdir managed_ip_project
create_project managed_ip_project ./managed_ip_project -part $part -ip
close_project


##	-------------------------------------------------------------------------------------
##	循环遍历每个 top_name
##	产生ip流程为  step1  添加ip 到vivado中；step2  生成ip；step3  生成edif
##	-------------------------------------------------------------------------------------
foreach top_name [array names top_array] {
	set top	$top_array($top_name)
	set timeval [clock format [clock seconds] -format %Y-%m-%d_%H:%M:%S]
	puts	"loop_gen_edif.tcl $top_array($top_name) start.The time is $timeval******"

	open_project ./managed_ip_project/managed_ip_project.xpr
	add_ip $top
	gen_ip $top
	close_project
	gen_edif $top

	set timeval [clock format [clock seconds] -format %Y-%m-%d_%H:%M:%S]
	puts	"loop_gen_edif.tcl $top_array($top_name) end.The time is $timeval******"
}


##	-------------------------------------------------------------------------------------
##	取消两个变量，如果单独调用flow.do，不需要这两个变量
##	-------------------------------------------------------------------------------------
unset LOOP


















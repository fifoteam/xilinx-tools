##	===============================================================================================
##	存在如下问题
##	1.ip没有生产 _stub.v 模块，这个模块用来包含edif文件，如果不生成，手动改，比较麻烦
##	===============================================================================================

##	===============================================================================================
##	请修改以下信息
##	===============================================================================================

##	-------------------------------------------------------------------------------------
##	定义FPGA型号
##	-------------------------------------------------------------------------------------
set part xc7a100tfgg484-2

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
##	子函数
##	1.添加ip到工程之中
##	2.生成ip
##	3.生成edif
##	-------------------------------------------------------------------------------------
proc	add_ip {top} {
	add_files -norecurse ./$top/$top.xci
}

proc	gen_ip {top} {
	set top_synth	$top
	append top_synth "_synth_1"

	generate_target all [get_files  ./$top/$top.xci]
	catch { config_ip_cache -export [get_ips -all $top] }
	export_ip_user_files -of_objects [get_files ./$top/$top.xci] -no_script -sync -force -quiet
	create_ip_run [get_files -of_objects [get_fileset sources_1] ./$top/$top.xci]
#	reset_run $top_synth
#	launch_runs -jobs 8 $top_synth
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
##	取消LOOP变量
##	-------------------------------------------------------------------------------------
unset LOOP



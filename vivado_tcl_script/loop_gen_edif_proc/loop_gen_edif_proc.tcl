##	===============================================================================================
##	������������
##	1.ipû������ _stub.v ģ�飬���ģ����������edif�ļ�����������ɣ��ֶ��ģ��Ƚ��鷳
##	===============================================================================================

##	===============================================================================================
##	���޸�������Ϣ
##	===============================================================================================

##	-------------------------------------------------------------------------------------
##	����FPGA�ͺ�
##	-------------------------------------------------------------------------------------
set part xc7a100tfgg484-2

##	-------------------------------------------------------------------------------------
##	������ top ����֮ǰ����ȡ�����飬�����ظ�����
##	-------------------------------------------------------------------------------------
if {[info exists top_array]} {
	unset top_array
}

##	-------------------------------------------------------------------------------------
##	���� top ����
##	-------------------------------------------------------------------------------------
set top_array(00)  resend_fifo_narrow
set top_array(01)  resend_fifo_narrow_bram


##	===============================================================================================
##	���²�Ҫ�޸�
##	===============================================================================================
##	-------------------------------------------------------------------------------------
##	����LOOPΪ1����ʾ��LOOPģʽ������
##	-------------------------------------------------------------------------------------
set LOOP	1

###	-------------------------------------------------------------------------------------
###	��� managed_ip_project �ļ���
###	������һ���µ�manageip���ļ���
###	-------------------------------------------------------------------------------------
#file delete -force managed_ip_project
#file copy f:/kuaipan/kuaipan/FifoTeam/bat-tools/template_bat/vivado_ip_template/xc7a100tfgg484-2/managed_ip_project 	./
file delete -force managed_ip_project
file mkdir managed_ip_project
create_project managed_ip_project ./managed_ip_project -part $part -ip
close_project

##	-------------------------------------------------------------------------------------
##	�Ӻ���
##	1.���ip������֮��
##	2.����ip
##	3.����edif
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
##	ѭ������ÿ�� top_name
##	����ip����Ϊ  step1  ���ip ��vivado�У�step2  ����ip��step3  ����edif
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
##	ȡ��LOOP����
##	-------------------------------------------------------------------------------------
unset LOOP



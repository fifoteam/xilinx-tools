# set basic info

if {[info exists LOOP]} {
	puts	"gen_edif.tcl top has been defined******"
} else {
	set top resend_mult
}



set part xc7a100tfgg484-2



# define output dir
set outputdir ./$top
file mkdir $outputdir



# read ip files to memory
read_ip [glob -nocomplain ./$top/$top.xci]

# Synth_design
synth_design -rtl -name rtl_1 -top $top
write_edif $outputdir/$top.edn

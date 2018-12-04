# define output dir
set outputdir ./resend_mult
file mkdir $outputdir

# set basic info
set top resend_mult
set part xc7a100tfgg484-2

# read ip files to memory
read_ip [glob -nocomplain ./resend_mult/resend_mult.xci]

# Synth_design
synth_design -rtl -name rtl_1 -top $top
write_edif $outputdir/$top.edn

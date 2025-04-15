vlib work

vcom -93 -work work ../../src/filter_delay_block.vhd
vcom -93 -work work ../../src/mult_ip.vhd
vcom -93 -work work ../../src/high_pass_filter.vhd
vcom -93 -work work ../src/hpf_tb.vhd

vsim -voptargs=+acc -msgmode both hpf_tb
do wave.do
run 300 us
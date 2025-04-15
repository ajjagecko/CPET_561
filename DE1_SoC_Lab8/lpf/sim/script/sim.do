vlib work

vcom -93 -work work ../../src/filter_delay_block.vhd
vcom -93 -work work ../../src/mult_ip.vhd
vcom -93 -work work ../../src/low_pass_filter.vhd
vcom -93 -work work ../src/lpf_tb.vhd

vsim -voptargs=+acc -msgmode both lpf_tb
do wave.do
run 300 us
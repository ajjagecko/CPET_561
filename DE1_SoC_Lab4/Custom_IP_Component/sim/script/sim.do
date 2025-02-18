vlib work
vcom -93 -work work ../../src/state_machine_core.vhd
vcom -93 -work work ../../src/generic_counter.vhd
vcom -93 -work work ../../src/angle_counter.vhd
vcom -93 -work work ../../src/vhdl_servo_controller.vhd
vcom -93 -work work ../src/vhdl_servo_controller_tb.vhd

vsim -voptargs=+acc -msgmode both vhdl_servo_controller_tb
do wave.do
run 3000 ns
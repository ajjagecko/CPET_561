# Dr. Kaputa
# Quartus II compile script for DE1-SoC board

# 1] name your project here
set project_name "vhdl_servo_controller"

file delete -force project
file delete -force output_files
file mkdir project
cd project
load_package flow
project_new $project_name
set_global_assignment -name FAMILY Cyclone
set_global_assignment -name DEVICE 5CSEMA5F31C6 
set_global_assignment -name TOP_LEVEL_ENTITY vhdl_servo_controller
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY ../output_files

# 2] include your relative path files here
set_global_assignment -name VHDL_FILE ../../src/state_machine_core.vhd
set_global_assignment -name VHDL_FILE ../../src/generic_counter.vhd
set_global_assignment -name VHDL_FILE ../../src/angle_counter.vhd
set_global_assignment -name VHDL_FILE ../../src/vhdl_servo_controller.vhd

set_location_assignment PIN_AF14 -to clk
set_location_assignment PIN_AA14 -to reset

set_location_assignment PIN_V16  -to led_o[0]
set_location_assignment PIN_W16  -to led_o[1]
set_location_assignment PIN_V17  -to led_o[2]
set_location_assignment PIN_V18  -to led_o[3]
set_location_assignment PIN_W17  -to led_o[3]

set_location_assignment PIN_AB12 -to switch_i[0]
set_location_assignment PIN_AC12 -to switch_i[1]
set_location_assignment PIN_AF9  -to switch_i[2]
set_location_assignment PIN_AF10 -to switch_i[3]
set_location_assignment PIN_AD11 -to switch_i[4]
set_location_assignment PIN_AD12 -to switch_i[5]
set_location_assignment PIN_AE11 -to switch_i[6]
set_location_assignment PIN_AC9  -to switch_i[7]

set_location_assignment PIN_AD10 -to op_sel_i[0]
set_location_assignment PIN_AE12 -to op_sel_i[1]

set_location_assignment PIN_AE26 -to bcd_one_o[0]
set_location_assignment PIN_AE27 -to bcd_one_o[1]
set_location_assignment PIN_AE28 -to bcd_one_o[2]
set_location_assignment PIN_AG27 -to bcd_one_o[3]
set_location_assignment PIN_AF28 -to bcd_one_o[4]
set_location_assignment PIN_AG28 -to bcd_one_o[5]
set_location_assignment PIN_AH28 -to bcd_one_o[6]

set_location_assignment PIN_AJ29 -to bcd_ten_o[0]
set_location_assignment PIN_AH29 -to bcd_ten_o[1]
set_location_assignment PIN_AH30 -to bcd_ten_o[2]
set_location_assignment PIN_AG30 -to bcd_ten_o[3]
set_location_assignment PIN_AF29 -to bcd_ten_o[4]
set_location_assignment PIN_AF30 -to bcd_ten_o[5]
set_location_assignment PIN_AD27 -to bcd_ten_o[6]

set_location_assignment PIN_AB23 -to bcd_hun_o[0]
set_location_assignment PIN_AE29 -to bcd_hun_o[1]
set_location_assignment PIN_AD29 -to bcd_hun_o[2]
set_location_assignment PIN_AC28 -to bcd_hun_o[3]
set_location_assignment PIN_AD30 -to bcd_hun_o[4]
set_location_assignment PIN_AC29 -to bcd_hun_o[5]
set_location_assignment PIN_AC30 -to bcd_hun_o[6]

# set_location_assignment PIN_AD26 -to bcd_3[0]
# set_location_assignment PIN_AC27 -to bcd_3[1]
# set_location_assignment PIN_AD25 -to bcd_3[2]
# set_location_assignment PIN_AC25 -to bcd_3[3]
# set_location_assignment PIN_AB28 -to bcd_3[4]
# set_location_assignment PIN_AB25 -to bcd_3[5]
# set_location_assignment PIN_AB22 -to bcd_3[6]

# set_location_assignment PIN_AA24 -to bcd_4[0]
# set_location_assignment PIN_Y23  -to bcd_4[1]
# set_location_assignment PIN_Y24  -to bcd_4[2]
# set_location_assignment PIN_W22  -to bcd_4[3]
# set_location_assignment PIN_W24  -to bcd_4[4]
# set_location_assignment PIN_V23  -to bcd_4[5]
# set_location_assignment PIN_W25  -to bcd_4[6]

# set_location_assignment PIN_V25  -to bcd_5[0]
# set_location_assignment PIN_AA28 -to bcd_5[1]
# set_location_assignment PIN_Y27  -to bcd_5[2]
# set_location_assignment PIN_AB27 -to bcd_5[3]
# set_location_assignment PIN_AB26 -to bcd_5[4]
# set_location_assignment PIN_AA26 -to bcd_5[5]
# set_location_assignment PIN_AA25 -to bcd_5[6]

execute_flow -compile
project_close
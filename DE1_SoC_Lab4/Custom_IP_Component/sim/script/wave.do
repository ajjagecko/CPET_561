onerror {resume}
radix define States {
    "7'b1000000" "0" -color "red",
    "7'b1111001" "1" -color "red",
    "7'b0100100" "2" -color "red",
    "7'b0110000" "3" -color "red",
    "7'b0011001" "4" -color "red",
    "7'b0010010" "5" -color "red",
    "7'b0000010" "6" -color "red",
    "7'b1111000" "7" -color "red",
    "7'b0000000" "8" -color "red",
    "7'b0011000" "9" -color "red",
    "7'b0001000" "a" -color "red",
    "7'b0000011" "b" -color "red",
    "7'b0100111" "c" -color "red",
    "7'b0100001" "d" -color "red",
    "7'b0000110" "e" -color "red",
    "7'b0001110" "f" -color "red",
    -default default
}
quietly WaveActivateNextPane {} 0

add wave -noupdate /vhdl_servo_controller_tb/dut/clk         
add wave -noupdate /vhdl_servo_controller_tb/dut/reset_i     
add wave -noupdate /vhdl_servo_controller_tb/dut/addr_i      
add wave -noupdate /vhdl_servo_controller_tb/dut/write_en_i
add wave -noupdate /vhdl_servo_controller_tb/dut/write_data_i
add wave -noupdate /vhdl_servo_controller_tb/dut/angle_max_reg_s
add wave -noupdate /vhdl_servo_controller_tb/dut/angle_min_reg_s  
add wave -noupdate /vhdl_servo_controller_tb/dut/state_pres_s
add wave -noupdate /vhdl_servo_controller_tb/dut/angle_s  
add wave -noupdate /vhdl_servo_controller_tb/dut/pwm_o
add wave -noupdate /vhdl_servo_controller_tb/dut/angle_flag_s
add wave -noupdate /vhdl_servo_controller_tb/dut/period_flag_s       
add wave -noupdate /vhdl_servo_controller_tb/dut/period_count_s
add wave -noupdate /vhdl_servo_controller_tb/dut/irq_o



TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {400250 ps} {505250 ps}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_comp_reset_gen/u0/PULSE_LEN
add wave -noupdate /tb_comp_reset_gen/u0/PULSE_DELAY
add wave -noupdate /tb_comp_reset_gen/u0/st_idle
add wave -noupdate /tb_comp_reset_gen/u0/st_delay
add wave -noupdate /tb_comp_reset_gen/u0/st_active
add wave -noupdate /tb_comp_reset_gen/u0/reset
add wave -noupdate /tb_comp_reset_gen/u0/ref_clk
add wave -noupdate /tb_comp_reset_gen/u0/comp_out
add wave -noupdate /tb_comp_reset_gen/u0/rst_driver
add wave -noupdate /tb_comp_reset_gen/u0/cnt
add wave -noupdate -radix hexadecimal /tb_comp_reset_gen/u0/state
add wave -noupdate -radix hexadecimal /tb_comp_reset_gen/u0/next_state
add wave -noupdate /tb_comp_reset_gen/u0/driver_reset
add wave -noupdate /tb_comp_reset_gen/u0/driver_set
add wave -noupdate /tb_comp_reset_gen/u0/driver
add wave -noupdate /tb_comp_reset_gen/u0/comp_resync
add wave -noupdate /tb_comp_reset_gen/u0/start
add wave -noupdate /tb_comp_reset_gen/u0/start_pulse
add wave -noupdate /tb_comp_reset_gen/u0/stop
add wave -noupdate /tb_comp_reset_gen/u0/cntr_en
add wave -noupdate /tb_comp_reset_gen/u0/cntr_rst
add wave -noupdate /tb_comp_reset_gen/u0/u0/pulse_in
add wave -noupdate /tb_comp_reset_gen/u0/u0/clk_out
add wave -noupdate /tb_comp_reset_gen/u0/u0/pulse_out
add wave -noupdate /tb_comp_reset_gen/u0/u0/reset
add wave -noupdate /tb_comp_reset_gen/u0/u0/driver
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {691300 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 315
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {281100 ps} {806600 ps}

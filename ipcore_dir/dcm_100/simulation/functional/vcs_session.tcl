gui_open_window Wave
gui_sg_create dcm_100_group
gui_list_add_group -id Wave.1 {dcm_100_group}
gui_sg_addsignal -group dcm_100_group {dcm_100_tb.test_phase}
gui_set_radix -radix {ascii} -signals {dcm_100_tb.test_phase}
gui_sg_addsignal -group dcm_100_group {{Input_clocks}} -divider
gui_sg_addsignal -group dcm_100_group {dcm_100_tb.CLK_IN1}
gui_sg_addsignal -group dcm_100_group {{Output_clocks}} -divider
gui_sg_addsignal -group dcm_100_group {dcm_100_tb.dut.clk}
gui_list_expand -id Wave.1 dcm_100_tb.dut.clk
gui_sg_addsignal -group dcm_100_group {{Status_control}} -divider
gui_sg_addsignal -group dcm_100_group {dcm_100_tb.RESET}
gui_sg_addsignal -group dcm_100_group {dcm_100_tb.LOCKED}
gui_sg_addsignal -group dcm_100_group {{Counters}} -divider
gui_sg_addsignal -group dcm_100_group {dcm_100_tb.COUNT}
gui_sg_addsignal -group dcm_100_group {dcm_100_tb.dut.counter}
gui_list_expand -id Wave.1 dcm_100_tb.dut.counter
gui_zoom -window Wave.1 -full

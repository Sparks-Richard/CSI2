set_property OFFCHIP_TERM NONE [get_ports SCK]
set_property OFFCHIP_TERM NONE [get_ports SDI]
current_instance vio_u
create_waiver -type CDC -id {CDC-4} -user "vio" -desc "The path has combinational circuit. But from hardware prospective the design works perfectly and the signals crossing happen after a very long time from the source has the value." -tags "1050886" -scope -internal -from [get_pins -filter REF_PIN_NAME=~C -of_objects [get_cells -hierarchical -filter {NAME =~ "*probe_in_reg_reg*"}]] -to [get_pins -filter REF_PIN_NAME=~D -of_objects [get_cells -hierarchical -filter {NAME =~ "*data_int_sync1_reg*"}]] -timestamp "Mon Sep  1 11:39:30 GMT 2025"
create_waiver -type CDC -id {CDC-1} -user "vio" -desc "The path has combinational circuit. But from hardware prospective the design works perfectly and the signals crossing happen after a very long time from the source has the value." -tags "1050886" -scope -internal -from [get_pins -filter REF_PIN_NAME=~C -of_objects [get_cells -hierarchical -filter { NAME =~  "*Hold_probe_in*" &&  IS_SEQUENTIAL }]] -to [get_pins -filter REF_PIN_NAME=~CE -of_objects [get_cells -hierarchical -filter { NAME =~  "*PROBE_IN_INST/probe_in_reg*" && IS_SEQUENTIAL}]] -timestamp "Mon Sep  1 11:39:30 GMT 2025"
current_instance -quiet
current_instance ila_u/inst
create_waiver -type CDC -id {CDC-1} -user "xsdbm" -desc "CDC is handled through handshake process" -tags "1037291" -scope -internal -from [get_pins -filter REF_PIN_NAME=~CLK -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/U_CDONE/I_YESLUT6.U_SRL32_*"}]] -to [get_pins -filter REF_PIN_NAME=~D -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/U_CDONE/I_YESLUT6.I_YES_OREG.O_reg_reg*"}]] -timestamp "Mon Sep  1 11:39:30 GMT 2025"
create_waiver -type CDC -id {CDC-1} -user "xsdbm" -desc "CDC is handled through handshake process" -tags "1037291" -scope -internal -from [get_pins -filter REF_PIN_NAME=~CLK -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/U_NS1/I_YESLUT6.U_SRL32_*"}]] -to [get_pins -filter REF_PIN_NAME=~D -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/U_NS1/I_YESLUT6.I_YES_OREG.O_reg_reg*"}]] -timestamp "Mon Sep  1 11:39:30 GMT 2025"
create_waiver -type CDC -id {CDC-1} -user "xsdbm" -desc "CDC is handled through handshake process" -tags "1037291" -scope -internal -from [get_pins -filter REF_PIN_NAME=~CLK -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/U_NS0/I_YESLUT6.U_SRL32_*"}]] -to [get_pins -filter REF_PIN_NAME=~D -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/U_NS0/I_YESLUT6.I_YES_OREG.O_reg_reg*"}]] -timestamp "Mon Sep  1 11:39:30 GMT 2025"
create_waiver -type CDC -id {CDC-1} -user "xsdbm" -desc "CDC is handled through handshake process" -tags "1037291" -scope -internal -from [get_pins -filter REF_PIN_NAME=~CLK -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/u_cap_addrgen/u_cap_window_counter/U_WCE/I_YESLUT6.U_SRLC16E*"}]] -to [get_pins -filter REF_PIN_NAME=~CE -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/u_cap_addrgen/u_cap_window_counter/iwcnt_reg[*]*"}]] -timestamp "Mon Sep  1 11:39:30 GMT 2025"
create_waiver -type CDC -id {CDC-1} -user "xsdbm" -desc "CDC is handled through handshake process" -tags "1037291" -scope -internal -from [get_pins -filter REF_PIN_NAME=~CLK -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/u_cap_addrgen/u_cap_sample_counter/U_SCE/I_YESLUT6.U_SRLC16E*"}]] -to [get_pins -filter REF_PIN_NAME=~CE -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/u_cap_addrgen/u_cap_sample_counter/iscnt_reg[*]*"}]] -timestamp "Mon Sep  1 11:39:30 GMT 2025"
create_waiver -type CDC -id {CDC-1} -user "xsdbm" -desc "CDC is handled through handshake process" -tags "1037291" -scope -internal -from [get_pins -filter REF_PIN_NAME=~CLK -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/u_cap_addrgen/u_cap_sample_counter/U_SCMPCE/I_YESLUT6.U_SRL32*"}]] -to [get_pins -filter REF_PIN_NAME=~CE -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/u_cap_addrgen/u_cap_sample_counter/u_scnt_cmp_q*"}]] -timestamp "Mon Sep  1 11:39:30 GMT 2025"
create_waiver -type CDC -id {CDC-1} -user "xsdbm" -desc "CDC is handled through handshake process" -tags "1037291" -scope -internal -from [get_pins -filter REF_PIN_NAME=~CLK -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/u_cap_addrgen/u_cap_window_counter/U_WHCMPCE/I_YESLUT6.U_SRL32*"}]] -to [get_pins -filter REF_PIN_NAME=~CE -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/u_cap_addrgen/u_cap_window_counter/u_wcnt_hcmp_q*"}]] -timestamp "Mon Sep  1 11:39:30 GMT 2025"
create_waiver -type CDC -id {CDC-1} -user "xsdbm" -desc "CDC is handled through handshake process" -tags "1037291" -scope -internal -from [get_pins -filter REF_PIN_NAME=~CLK -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/u_cap_addrgen/u_cap_window_counter/U_WLCMPCE/I_YESLUT6.U_SRL32*"}]] -to [get_pins -filter REF_PIN_NAME=~CE -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/u_cap_addrgen/u_cap_window_counter/u_wcnt_lcmp_q*"}]] -timestamp "Mon Sep  1 11:39:30 GMT 2025"
create_waiver -type CDC -id {CDC-10} -user "xsdbm" -desc "CDC is handled through handshake process" -tags "1037291" -scope -internal -from [get_pins -filter REF_PIN_NAME=~CLK -of_objects [get_cells -hierarchical -filter {NAME =~ "*allx_typeA_match_detection.ltlib_v1_0_2_allx_typeA_inst/DUT/I_WHOLE_SLICE.G_SLICE_IDX[*].U_ALL_SRL_SLICE/u_srl*/S*"}]] -to [get_pins -filter REF_PIN_NAME=~D -of_objects [get_cells -hierarchical -filter {NAME =~ "*allx_typeA_match_detection.ltlib_v1_0_2_allx_typeA_inst/DUT/I_WHOLE_SLICE.G_SLICE_IDX[*].U_ALL_SRL_SLICE/I_IS_TERMINATION_SLICE_W_OUTPUT_REG.DOUT_O_reg*"}]] -timestamp "Mon Sep  1 11:39:30 GMT 2025"
create_waiver -type CDC -id {CDC-10} -user "xsdbm" -desc "CDC is handled through handshake process" -tags "1037291" -scope -internal -from [get_pins -filter REF_PIN_NAME=~CLK -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/u_cap_addrgen/u_cap_sample_counter/U_SCE/I_YESLUT6.U_SRLC16E*"}]] -to [get_pins -filter REF_PIN_NAME=~D -of_objects [get_cells -hierarchical -filter {NAME =~ "*u_ila_cap_ctrl/u_cap_addrgen/icap_wr_en_reg*"}]] -timestamp "Mon Sep  1 11:39:30 GMT 2025"
create_waiver -type CDC -id {CDC-10} -user "system_ila" -desc "CDC-10 waiver for DDR Calibration logic" -tags "1196835" -scope -internal -from [get_pins -quiet -filter REF_PIN_NAME=~*CLK -of_objects [get_cells -hierarchical -filter {NAME =~*u_trig/N_DDR_TC.N_DDR_TC_INST[*].U_TC/allx_typeA_match_detection.ltlib_v1_0_2_allx_typeA_inst/DUT/u_srl_drive}]] -to [get_pins -quiet -filter REF_PIN_NAME=~*D -of_objects [get_cells -hierarchical -filter {NAME =~*u_trig/N_DDR_TC.N_DDR_TC_INST[*].U_TC/allx_typeA_match_detection.ltlib_v1_0_2_allx_typeA_inst/DUT/I_WHOLE_SLICE.G_SLICE_IDX[*].U_ALL_SRL_SLICE/I_IS_TERMINATION_SLICE_W_OUTPUT_REG.DOUT_O_reg}]] -timestamp "Mon Sep  1 11:39:30 GMT 2025"
current_instance -quiet
set_property PACKAGE_PIN AA27 [get_ports SCK]
set_property PACKAGE_PIN AA28 [get_ports SDI]
set_property PACKAGE_PIN D9 [get_ports sysclk_p]
set_property PACKAGE_PIN D8 [get_ports sysclk_n]
set_property PACKAGE_PIN Y26 [get_ports cam_rst]
set_property PACKAGE_PIN AC28 [get_ports cam_clk_p]
set_property PACKAGE_PIN AD28 [get_ports cam_clk_n]
set_property PACKAGE_PIN Y30 [get_ports cam_in0_p]
set_property PACKAGE_PIN AA30 [get_ports cam_in0_n]
set_property PACKAGE_PIN Y27 [get_ports cam_clk]
set_property DIRECTION OUT [get_ports SCK]
set_property IOSTANDARD LVCMOS25 [get_ports SCK]
set_property DRIVE 12 [get_ports SCK]
set_property SLEW SLOW [get_ports SCK]
set_property PULLTYPE PULLUP [get_ports SCK]
set_property DIRECTION INOUT [get_ports SDI]
set_property IOSTANDARD LVCMOS25 [get_ports SDI]
set_property DRIVE 12 [get_ports SDI]
set_property SLEW SLOW [get_ports SDI]
set_property PULLTYPE PULLUP [get_ports SDI]
set_property DIRECTION OUT [get_ports cam_clk]
set_property IOSTANDARD LVCMOS25 [get_ports cam_clk]
set_property DRIVE 12 [get_ports cam_clk]
set_property SLEW SLOW [get_ports cam_clk]
set_property DIRECTION IN [get_ports cam_clk_n]
set_property IOSTANDARD LVDS_25 [get_ports cam_clk_n]
set_property DIFF_TERM TRUE [get_ports cam_clk_n]
set_property DIRECTION IN [get_ports cam_clk_p]
set_property IOSTANDARD LVDS_25 [get_ports cam_clk_p]
set_property DIFF_TERM TRUE [get_ports cam_clk_p]
set_property DIRECTION IN [get_ports cam_in0_n]
set_property IOSTANDARD LVDS_25 [get_ports cam_in0_n]
set_property DIFF_TERM TRUE [get_ports cam_in0_n]
set_property DIRECTION IN [get_ports cam_in0_p]
set_property IOSTANDARD LVDS_25 [get_ports cam_in0_p]
set_property DIFF_TERM TRUE [get_ports cam_in0_p]
set_property DIRECTION OUT [get_ports cam_rst]
set_property IOSTANDARD LVCMOS25 [get_ports cam_rst]
set_property DRIVE 12 [get_ports cam_rst]
set_property SLEW SLOW [get_ports cam_rst]
set_property DIRECTION IN [get_ports sysclk_n]
set_property IOSTANDARD DIFF_SSTL135 [get_ports sysclk_n]
set_property DIFF_TERM FALSE [get_ports sysclk_n]
set_property DIRECTION IN [get_ports sysclk_p]
set_property IOSTANDARD DIFF_SSTL135 [get_ports sysclk_p]
set_property DIFF_TERM FALSE [get_ports sysclk_p]
#revert back to original instance
current_instance -quiet

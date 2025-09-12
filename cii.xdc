# I²C 时钟 (SCL)
set_property PACKAGE_PIN AA27 [get_ports SCK]
set_property IOSTANDARD LVCMOS18 [get_ports SCK]
set_property PULLTYPE PULLUP [get_ports SCK]

# I²C 数据 (SDA)
set_property PACKAGE_PIN AA28 [get_ports SDI]
set_property IOSTANDARD LVCMOS18 [get_ports SDI]
set_property PULLTYPE PULLUP [get_ports SDI]

# 摄像头复位
set_property PACKAGE_PIN Y26 [get_ports cam_rst]
set_property IOSTANDARD LVCMOS18 [get_ports cam_rst]

# 24MHz 时钟输出
set_property PACKAGE_PIN Y27 [get_ports clk_24m]
set_property IOSTANDARD LVCMOS18 [get_ports clk_24m]

# 系统差分时钟
set_property PACKAGE_PIN D9 [get_ports sysclk_p]
set_property IOSTANDARD DIFF_SSTL135 [get_ports sysclk_p]


set_property PACKAGE_PIN AC28 [get_ports cam_clk_p]
set_property PACKAGE_PIN AD28 [get_ports cam_clk_n]
set_property PACKAGE_PIN Y28 [get_ports cam_in0_p]
set_property PACKAGE_PIN AA29 [get_ports cam_in0_n]

set_property IOSTANDARD DIFF_SSTL18_II [get_ports cam_in0_p]
set_property IOSTANDARD DIFF_SSTL18_II [get_ports cam_in0_n]
set_property IOSTANDARD DIFF_SSTL18_II [get_ports cam_clk_p]
set_property IOSTANDARD DIFF_SSTL18_II [get_ports cam_clk_n]


set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_8m]

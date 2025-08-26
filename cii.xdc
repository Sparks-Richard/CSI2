# MLK_H3  zynq7100
set_property IOSTANDARD LVCMOS18 [get_ports SCK]
set_property PACKAGE_PIN AA27 [get_ports SCK]
set_property PACKAGE_PIN AA28 [get_ports SDI]
set_property IOSTANDARD LVCMOS18 [get_ports SDI]

set_property PACKAGE_PIN D9 [get_ports sysclk_p]
set_property IOSTANDARD DIFF_SSTL135 [get_ports sysclk_p]


set_property IOSTANDARD LVCMOS18 [get_ports clk_24m]
set_property PACKAGE_PIN Y27 [get_ports clk_24m]

set_property SLEW SLOW [get_ports clk_24m]

set_property PULLTYPE PULLUP [get_ports SCK]
set_property PULLTYPE PULLUP [get_ports SDI]

set_property OFFCHIP_TERM NONE [get_ports SCK]
set_property OFFCHIP_TERM NONE [get_ports SDI]
set_property OFFCHIP_TERM NONE [get_ports clk_24m]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_8m]
# 复位信号约束
set_property PACKAGE_PIN Y26 [get_ports cam_rst]  ;# 假设复位信号端口名为cam_rst
set_property IOSTANDARD LVCMOS18 [get_ports cam_rst]
# 在约束文件中启用内部上拉
set_property PULLUP true [get_ports SDI]
set_property PULLUP true [get_ports SCK]

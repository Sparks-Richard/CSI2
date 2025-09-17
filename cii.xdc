###############################################################################
# CSI-2 (MIPI) 摄像头接口约束文件
# 重要说明：
# 1. 本文件基于示例设计的电压标准（LVDS_25/HSUL_12/LVCMOS18）
# 2. 完全保留用户原始引脚分配（仅修改电平标准）
# 3. 所有未使用信号已标注"预留"，当前设计可不连接
# 4. 每个信号段包含：功能说明/电压标准/连接要求三部分注释
###############################################################################

########################################
### 第一部分：I²C 控制接口（必需连接） ###
########################################
# 功能：用于配置摄像头参数（分辨率/帧率等）
# 电压：LVCMOS18 (1.8V)
# 硬件要求：必须外接4.7kΩ上拉电阻

# I²C时钟线（SCL）
# 引脚位置：AA27
# 信号特性：开漏输出，需上拉
set_property PACKAGE_PIN AA27 [get_ports SCK]
set_property IOSTANDARD LVCMOS18 [get_ports SCK]
#set_property PULLTYPE PULLUP [get_ports SCK]  # 临时启用内部上拉（建议用外部电阻）

# I²C数据线（SDA）
# 引脚位置：AA28
# 信号特性：开漏输出，需上拉
set_property PACKAGE_PIN AA28 [get_ports SDI]
set_property IOSTANDARD LVCMOS18 [get_ports SDI]
#set_property PULLTYPE PULLUP [get_ports SDI]

########################################
### 第二部分：摄像头基础控制信号（必需）###
########################################
# 功能：提供摄像头工作所需的基本控制信号
# 电压：LVCMOS18 (1.8V)

# 摄像头硬件复位信号（低电平有效）
# 引脚位置：Y26
# 使用说明：默认保持高电平，初始化时拉低至少1ms
set_property PACKAGE_PIN Y26 [get_ports cam_rst]
set_property IOSTANDARD LVCMOS18 [get_ports cam_rst]

set_property PACKAGE_PIN D9 [get_ports sysclk_p]
set_property PACKAGE_PIN D8 [get_ports sysclk_n]
set_property IOSTANDARD DIFF_SSTL135 [get_ports sysclk_p]

# 24MHz摄像头主时钟输出
# 引脚位置：Y27
# 注意：需确保时钟抖动<100ps
set_property PACKAGE_PIN Y27 [get_ports clk_24m]
set_property IOSTANDARD LVCMOS18 [get_ports clk_24m]

##############################################
### 第三部分：CSI-2 高速模式信号（当前使用）###
##############################################
# 功能：传输摄像头图像数据（差分信号）
# 电压：LVDS_25 (2.5V)
# 布线要求：差分对长度误差<50mil

set_property -dict {PACKAGE_PIN AD25 IOSTANDARD HSUL_12} [get_ports cam_clk_lp_p]
set_property -dict {PACKAGE_PIN AE26 IOSTANDARD HSUL_12} [get_ports cam_clk_lp_n]

set_property -dict {PACKAGE_PIN Y30 IOSTANDARD HSUL_12} [get_ports {cam_in_lp_p[0]}]
set_property -dict {PACKAGE_PIN AA30 IOSTANDARD HSUL_12} [get_ports {cam_in_lp_n[0]}]
set_property -dict {PACKAGE_PIN AE27 IOSTANDARD HSUL_12} [get_ports {cam_in_lp_p[1]}]
set_property -dict {PACKAGE_PIN AF27 IOSTANDARD HSUL_12} [get_ports {cam_in_lp_n[1]}]


set_property -dict {PACKAGE_PIN AC28 IOSTANDARD LVDS_25} [get_ports cam_clk_hs_p]
set_property -dict {PACKAGE_PIN AD28 IOSTANDARD LVDS_25} [get_ports cam_clk_hs_n]

set_property -dict {PACKAGE_PIN Y28 IOSTANDARD LVDS_25} [get_ports {cam_in_hs_p[0]}]
set_property -dict {PACKAGE_PIN AA29 IOSTANDARD LVDS_25} [get_ports {cam_in_hs_n[0]}]
set_property -dict {PACKAGE_PIN AC26 IOSTANDARD LVDS_25} [get_ports {cam_in_hs_p[1]}]
set_property -dict {PACKAGE_PIN AD26 IOSTANDARD LVDS_25} [get_ports {cam_in_hs_n[1]}]

########################################
### 第六部分：系统级关键配置 ###
########################################

# Bank12电压参考（MIPI接收器必需）
# 重要：必须设置为0.6V，否则无法正确接收数据
set_property INTERNAL_VREF 0.6 [get_iobanks 12]

# 比特流压缩配置（推荐启用）
# 作用：减小生成的bit文件体积（约节省30%空间）
set_property BITSTREAM.GENERAL.COMPRESS true [current_design]


set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_24m_OBUF]

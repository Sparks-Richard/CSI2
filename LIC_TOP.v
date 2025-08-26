///////////////////////////////////////////////////////////////////////////////
// git config --global user.name
// git config --global user.email
//、
// git remote -v
//
// # 删除origin
// git remote remove origin
//
// # 删除github
// git remote remove github
//
// # 删除gitee
// git remote remove gitee
// # 添加新的origin
// git remote add origin https://新的仓库地址.git
//
// # 添加github
// git remote add github https://github.com/Sparks-Richard/仓库名.git
//
// # 添加gitee
// git remote add gitee https://gitee.com/Sparks-Richard/仓库名.git
//
// git push github main && git push gitee main
//
// # 推送到 github
// git push github main --force
// # 推送到 gitee
// git push gitee main --force
//
//git push github main --force && git push gitee main --force
////////////////////////////////////////////////////////////////////////////////
// by Sparks-Richard    this is just a  start 
// my life will be full of challenges and opportunities
// I will embrace them all
// JiaTu_Li  2025_08_22_11:13 in jinan
///////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////
// I2C 顶层模块
// 功能：集成 I2C 驱动、时钟管理和 VIO 控制
///////////////////////////////////////////////////////////////////////////////
module IIC_Top(
    inout               SDI,        // I2C 数据线 (双向)
    output              SCK,        // I2C 时钟线
    input               sysclk_p,   // 差分时钟输入+
    input               sysclk_n,   // 差分时钟输入-
    output              clk_24m,    // 24MHz 时钟输出 (供摄像头使用)
    output              cam_rst     // 摄像头复位信号
);

// 内部信号声明
reg     [3:0]   count_reg;       // 时钟分频计数器
reg             clk_i;           // I2C 控制时钟 (0.8MHz)
reg     [1:0]   IIC_en_tri_r;    // I2C 使能信号寄存器
wire            IIC_config_busy; // I2C 配置忙信号
wire    [7:0]   i2c_device_addr; // I2C 设备地址
wire    [15:0]  register;        // 寄存器地址
wire    [7:0]   data_byte;       // 写入数据
wire    [7:0]   rd_data;         // 读取数据
wire            busy;            // 忙信号
wire            err;             // 错误信号
wire            start_en;        // 启动使能
wire            wr_rd_flag;      // 读写标志
wire            IIC_START;       // I2C 启动信号
wire    [7:0]   nstate;          // 下一状态
wire    [15:0]  Rec_count;       // 状态计数器
wire            TESTSDI;         // SDA 测试信号

// SDA 三态控制信号
wire sda_i, sda_o, sda_t;

// 时钟和复位信号
wire clk_8m, rst_n, clk_50m;

///////////////////////////////////////////////////////////////////////////////
// SDA 三态控制
// 功能：控制 SDA 线的输出状态
///////////////////////////////////////////////////////////////////////////////
assign SDI = sda_t ? 1'bz : sda_o;  // 三态控制: 1=高阻(输入), 0=输出
assign sda_i = SDI;                 // 监控 SDA 线输入状态
assign TESTSDI = sda_i;             // 连接输入信号到测试端口

///////////////////////////////////////////////////////////////////////////////
// I2C 启动信号生成
// 功能：检测 I2C 使能信号的上升沿
///////////////////////////////////////////////////////////////////////////////
assign IIC_START = IIC_en_tri_r[1] & (~IIC_en_tri_r[0]);

///////////////////////////////////////////////////////////////////////////////
// I2C 控制时钟生成
// 功能：从 8MHz 时钟分频生成 0.8MHz 时钟
///////////////////////////////////////////////////////////////////////////////
always @(posedge clk_8m or negedge rst_n) begin
    if(!rst_n) begin
        clk_i <= 1'b0;
        count_reg <= 4'd0;
    end
    else begin
        if(count_reg == 4'd39) begin 
            count_reg <= 4'd0;
            clk_i <= ~clk_i;
        end
        else begin
            count_reg <= count_reg + 1'b1;
        end
    end
end

///////////////////////////////////////////////////////////////////////////////
// I2C 使能信号同步
// 功能：同步异步输入信号，防止亚稳态
///////////////////////////////////////////////////////////////////////////////
always @(posedge clk_i) begin
    IIC_en_tri_r <= {IIC_en_tri_r[0], IIC_en_tri};
end

///////////////////////////////////////////////////////////////////////////////
// I2C 驱动模块实例化
// 功能：实现 I2C 协议的核心控制
///////////////////////////////////////////////////////////////////////////////
iic_drive iic_drive_r(
    .clk_8m(clk_8m),
    .clk_i(clk_i),
    .rst_n(rst_n),
    .wr_rd_flag(wr_rd_flag),
    .start_en(IIC_START),
    .i2c_device_addr(i2c_device_addr),
    .register(register),
    .data_byte(data_byte),
    .scl(SCK),
    .sda(SDI),
    .busy(busy),
    .err(err),
    .rd_data(rd_data),
    .sda_o(sda_o),
    .sda_t(sda_t),
    .sda_i(sda_i),
    .Rec_count(Rec_count),
    .nstate(nstate)
);

///////////////////////////////////////////////////////////////////////////////
// 时钟管理模块
// 功能：生成系统所需的各种时钟
///////////////////////////////////////////////////////////////////////////////
clk_wiz_0 clk_wiz_u (
    .clk_out1(clk_8m),    // 8MHz 时钟
    .clk_out2(clk_24m),   // 24MHz 时钟
    .clk_out3(clk_50m),   // 50MHz 时钟
    .locked(rst_n),       // 锁定信号作为复位
    .clk_in1_p(sysclk_p), // 差分时钟+
    .clk_in1_n(sysclk_n)  // 差分时钟-
);

///////////////////////////////////////////////////////////////////////////////
// VIO 控制接口
// 功能：提供虚拟输入输出控制
///////////////////////////////////////////////////////////////////////////////
vio_0 vio_u (
    .clk(clk_8m),               // 采样时钟（8MHz）
    .probe_in0(busy),           // 输入：忙信号
    .probe_out0(wr_rd_flag),    // 输出：读写标志
    .probe_out1(IIC_en_tri),    // 输出：I2C使能
    .probe_out2(i2c_device_addr), // 输出：设备地址
    .probe_out3(register),      // 输出：寄存器地址
    .probe_out4(data_byte)      // 输出：写入数据
);

///////////////////////////////////////////////////////////////////////////////
// ILA 调试接口
// 功能：提供片上逻辑分析仪功能
///////////////////////////////////////////////////////////////////////////////
ila_0 ila_u (
    .clk(clk_8m),           // 采样时钟
    .probe0(sda_o),         // SDA 输出值
    .probe1(SCK),           // SCL 时钟
    .probe2(busy),          // 忙信号
    .probe3(TESTSDI),       // SDA 实际值
    .probe4(rd_data),       // 读取数据
    .probe5(sda_t),         // SDA 三态控制
    .probe6(nstate),        // 下一状态
    .probe7(clk_i),         // I2C 控制时钟
    .probe8(Rec_count),     // 状态计数器
    .probe9(err),           // 错误信号
    .probe10(cam_rst),      // 摄像头复位
    .probe11(clk_24m)       // 24MHz 时钟
);

///////////////////////////////////////////////////////////////////////////////
// 摄像头复位模块
// 功能：生成摄像头复位信号
///////////////////////////////////////////////////////////////////////////////
cam_reset_min reset_min(
    .clk_50m(clk_50m),
    .cam_rst(cam_rst)
);



endmodule



// iic_reg_init iic_reg_init_r(
// 	.clk_i				(clk_i				), 
// 	.rst_n				(rst_n				),
// 	.wr_rd_flag			(wr_rd_flag			),	//0 wr -- 1 rd
// 	.start_en			(start_en			),
// 	.i2c_device_addr	(i2c_device_addr	),
// 	.register			(register			),
// 	.data_byte			(data_byte			),
// 	.busy				(busy				),
// 	.err                (err                ),
// 	.IIC_START			(IIC_START			),
// 	.IIC_config_busy	(IIC_config_busy	)
// );	


// .clk_8m				(clk_8m				),
// .clk_i				(clk_i				),
// .rst_n				(rst_n				),
// .wr_rd_flag			(wr_rd_flag			),
// .start_en			(start_en			),
// .i2c_device_addr	(i2c_device_addr	),
// .register			(register			),
// .data_byte			(data_byte			),
// .scl				(scl				),
// .sda				(sda				),
// .busy				(busy				),
// .err				(err				),
// .rd_data			(rd_data			)			


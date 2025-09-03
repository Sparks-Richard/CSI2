//////////////////////////////////////////////////////////////////////////////////
// 关于保存ila
// open_hw_manager
// # 注意：不要执行 connect_hw_server 和 open_hw_target！
// # 方式1：使用绝对路径
// read_hw_ila_data /home/lijiatu/VERILOGDAIMA/I2C/I2C.srcs/sources_1/new/zhua-head-first-try.ila
//////////////////////////////////////////////////////////////////////////////////
// git config --global user.name
// git config --global user.email
//
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
//
// # 确保你在正确的项目目录下
// cd ~/VERILOGDAIMA/CSI_2/CSI_2.srcs/sources_1/new
//
// # 初始化 Git 仓库
// git init
//
// # 添加新的origin
// git remote add origin https://新的仓库地址.git
//
// # 添加github
// git remote add github https://github.com/Sparks-Richard/仓库名.git
//
// # 添加gitee
// git remote add gitee https://gitee.com/Sparks-Richard/仓库名.git
//
// git push github && git push gitee 
// git push github main && git push gitee main
//
// # 推送到 github
// git push github main --force
// # 推送到 gitee
// git push gitee main --force
//
// git push github main --force && git push gitee main --force
//
// # 查看 github 远程仓库的 main 分支状态
// git log github/main --oneline -5
//
// # 查看 gitee 远程仓库的 main 分支状态
// git log gitee/main --oneline -5
//
// # 查看你本地的 main 分支状态
// git log --oneline -5
//
// # 检查状态，这会告诉你是否有已暂存但未提交的更改
// git status
//
// # 第1步：添加所有修改（每次必做）
// git add .
//
// # 第2步：提交到本地（每次必做）
// git commit -m "这里写你改了什么东西"
//
// # 第3步：推送到两个网站（每次必做）
// git push github main && git push gitee main
//////////////////////////////////////////////////////////////////////////////////
// by Sparks-Richard    this is just a  start 
// my life will be full of challenges and opportunities
// I will embrace them all
// JiaTu_Li  2025_08_22_11:13 in jinan
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2025 07:12:50 PM
// Design Name: 
// Module Name: RAW8
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

         
module RAW(
    input               rst_n        ,

    input               Lane_Change  ,
    input               cam_in0_p    ,   
    input               cam_in0_n    ,//2 lane 

    input               cam_clk_p    ,
    input               cam_clk_n    ,
    input               clk_i        ,// 24MHz clock//EXTCLK
    output              lane0_data   ,
    output reg          head_true    ,
    output wire [7:0]   head_count_r ,
    output reg  [7:0]   data_reg_n   ,
    output wire         cam_clk      ,
    input               clk_24m

    // input               clk_i       ,
    // input               cam_in1_p   ,   
    // input               cam_in1_n   ,//2 lane ，另外的摄像头的
    );
        
    reg [ 7:0] cstate     ;
    reg [ 7:0] nstate     ;
  
    reg [ 7:0] DI_i_0     ; //这是两根线，如果使用的话
    reg [ 7:0] DI_i_1     ; 

    reg [15:0] WC_i       ; //寄存器，为了对应的包头包尾
    reg [ 7:0] VCXECC_i   ;
    reg [ 7:0] PF_i       ;
    
    reg [15:0] count_reg  ; 
    reg        start_en   ;
    reg        start_turn ;
    reg        short_pac  ; //判断是否为长短包



// 状态定义 (使用独热码编码)
localparam  idle         = 8'b1111_1110; // FE 
localparam  HEAD_DI      = 8'b1111_1101; // FD 
localparam  HEAD_WC      = 8'b1111_1011; // FB 
localparam  HEAD_VCX_ECC = 8'b1111_0111; // F7 
localparam  END_PF       = 8'b1110_1111; // EF 
localparam  DATA_IN      = 8'b1101_1111; // DF 
// localparam  ****** = 8'b1011_1111; // BF 
// localparam  ****** = 8'b0111_1111; // 7F 
// localparam  ****** = 8'b0111_1110; // 7E 
// localparam  ****** = 8'b1011_1101; // BD 

always @(*) begin
    case (cstate)
        idle:           nstate = (start_en)   ? HEAD_DI      : idle    ;
        HEAD_DI:        nstate = (start_turn) ? HEAD_WC      : HEAD_DI ;
        HEAD_WC:        nstate = (start_turn) ? HEAD_VCX_ECC : HEAD_WC ;

        HEAD_VCX_ECC:   nstate = (start_turn) ? ((short_pac) ? END_PF : DATA_IN) : HEAD_VCX_ECC;

        DATA_IN:        nstate = (start_turn) ? END_PF : DATA_IN ;
        END_PF:         nstate = (start_turn) ? idle   : END_PF  ;

        default: nstate = idle;
    endcase
end

// 差分时钟输入缓冲
wire cam_clk_ibuf;

IBUFDS #(
    .DIFF_TERM("TRUE"),      // 开启差分终端电阻（如果硬件支持）
    .IBUF_LOW_PWR("FALSE"),  // 关闭低功耗模式，保证信号完整性
    .IOSTANDARD("LVDS")      // MIPI 输出的是 LVDS，注意不要写 LVDS_25
) IBUFDS_cam_clk (
    .I (cam_clk_p),  // 摄像头时钟差分正端
    .IB(cam_clk_n),  // 摄像头时钟差分负端
    .O (cam_clk_ibuf) // 单端时钟输出
);

// 全局时钟缓冲
//wire cam_clk;

BUFG BUFG_cam_clk (
    .I(cam_clk_ibuf),
    .O(cam_clk)      // 送给 RAW、ILA 的全局时钟
);






    //reg [ 7:0] head_count ;
    reg [ 7:0] data_reg   ;
   // reg [ 7:0] data_reg_n ;
    //wire       lane0_data ;
    //reg        head_true  ;
    //wire       lane1_data  ;

// 实例化 IBUFDS 原语将差分信号转换为单端信号
IBUFDS #(
    .DIFF_TERM("TRUE"),
    .IBUF_LOW_PWR("FALSE"),
    .IOSTANDARD("LVDS")   // ← 这是 1.8V LVDS，不要写 LVDS_25
) ibufds_lane0_inst (
    .O(lane0_data),
    .I(cam_in0_p),
    .IB(cam_in0_n)
);


always @(posedge cam_clk or negedge rst_n) begin
    if (!rst_n) begin
        data_reg_n <= 8'b0;
    end else begin
        data_reg_n <= data_reg;
    end
end

always @(posedge cam_clk or negedge rst_n) begin
    if(!rst_n) begin
        data_reg <= 8'b00;
    end 

    else if(head_count < 8'd8)begin
        data_reg <= {data_reg[6:0], lane0_data} ;
    end
end

reg [7:0] head_count;   // 内部寄存器

    assign head_count_r = head_count; // 驱动输出口

always @(posedge cam_clk or negedge rst_n) begin
    if (!rst_n) begin
        head_count <= 8'b0;
    end else if (head_count == 8'd07) begin
        head_count <= 8'b0;
    end else if (head_count < 8'd07) begin
        head_count <= head_count + 1'b1;
    end
end

always @(posedge cam_clk or negedge rst_n) begin
    if (!rst_n) begin
        head_true <= 1'b0;
    end else if (data_reg_n == 8'h00||data_reg_n == 8'h01||data_reg_n == 8'h02||data_reg_n == 8'h03||data_reg_n == 8'h2A||data_reg_n == 8'h2B) begin
        head_true <= 1'b1;
    end else  begin
        head_true <= 1'b0;
    end
end


always @(posedge cam_clk or negedge rst_n) begin
    if (!rst_n) begin
        cstate <= idle; // 复位状态机
    end else begin
        cstate <= nstate; // 更新当前状态
    end
end

endmodule

`timescale 1ns / 1ps

module iic_drive(
    input               clk_8m,
    input               clk_i,     // 2xI2C时钟（400kHz*4=0.8MHz）
    input               rst_n,
    input               wr_rd_flag, // 0:写 1:读
    input               start_en,
    input        [7:0]   i2c_device_addr,
    input       [15:0]  register,
    input       [7:0]   data_byte,
    output reg          scl,
    inout               sda,
    output reg          busy,
    output reg          err,
    output reg [7:0]    rd_data,
    output reg sda_o,
  // 改为纯输出
    output reg sda_t   ,   // 三态控制信号（需监控）
    input sda_i  ,      // 新增：SDA输入状态
    //input  [7:0]    cam_data_byte// 摄像头数据字节输入
    output wire [15:0] Rec_count,
    output wire [7:0] nstate
);
//jiancha1yixia1djisk

localparam  idle         = 8'b1111_1110; // FE - 空闲状态（等待启动）
localparam  start_bit    = 8'b1111_1101; // FD - 起始位状态（产生START条件）
localparam  wr_dev_ctrl  = 8'b1111_1011; // FB - 写设备控制字（地址+写标志）
localparam  wr_reg_high  = 8'b1111_0111; // F7 - 写寄存器高字节
localparam  wr_reg_low   = 8'b1110_1111; // EF - 写寄存器低字节
localparam  wr_data_byte = 8'b1101_1111; // DF - 写数据字节
localparam  repeat_start = 8'b1011_1111; // BF - 重复起始位（读操作前）
localparam  rd_dev_ctrl  = 8'b0111_1111; // 7F - 读设备控制字（地址+读标志）
localparam  rd_data_byte = 8'b0111_1110; // 7E - 读数据字节
localparam  i2c_over     = 8'b1011_1101; // BD - 传输结束（产生STOP条件）
//localparam  i2c_ack      = 8'b0111_1011; // 7B - 等待/应答ACK周期

reg [7:0] nstate;
reg [7:0] cstate; 
reg [7:0] dev_r;
reg [7:0] reg_h;
reg [7:0] reg_l;
reg [7:0] data_byte_r;
reg [7:0] rd_dev_r;
reg [7:0] rd_reg_h;
reg [7:0] rd_reg_l;
reg [7:0] rd_data_byte_r;  // 接收数据寄存器

//reg       sda_t;
reg       State_turn;
reg [15:0] Rec_count;
// 在寄存器定义区增加
reg scl_d;                         // 打拍后的SCL
wire scl_rise = (scl && !scl_d);   // SCL上升沿

// 打拍
always @(posedge clk_i or negedge rst_n) begin
    if(!rst_n) scl_d <= 1'b1;
    else       scl_d <= scl;
end

//assign sda_i = sda;

always @(*) begin
    case (cstate)
        idle:        nstate = (start_en) ? start_bit : idle;
        start_bit:   nstate = (State_turn) ? wr_dev_ctrl : start_bit;
        wr_dev_ctrl: nstate = (State_turn) ? wr_reg_high : wr_dev_ctrl;
        wr_reg_high: nstate = (State_turn) ? wr_reg_low : wr_reg_high;
        wr_reg_low:  nstate = (State_turn) ? ((wr_rd_flag) ? repeat_start : wr_data_byte) : wr_reg_low;
        wr_data_byte: nstate = (State_turn) ? i2c_over : wr_data_byte;
        repeat_start: nstate = (State_turn) ? rd_dev_ctrl : repeat_start;
        rd_dev_ctrl: nstate = (State_turn) ? rd_data_byte : rd_dev_ctrl;
        rd_data_byte: nstate = (State_turn) ? i2c_over : rd_data_byte;
        i2c_over:    nstate = (State_turn) ? idle : i2c_over;
        default:     nstate = idle; // 必须的默认分支
    endcase
end

always @(posedge clk_i or negedge rst_n) begin
    if (!rst_n) begin
        scl <= 1'b1;
    end else begin
        case (nstate)
            idle: scl <= 1'b1;
            start_bit: 
                scl <= (Rec_count >= 16'd2) ? 1'b0 : 1'b1;
            wr_dev_ctrl, wr_reg_high, wr_reg_low, wr_data_byte, 
            rd_dev_ctrl, rd_data_byte: scl <= ~scl;

            repeat_start: scl <= (Rec_count >= 16'd14) ? 1'b0 : 1'b1;


            i2c_over: scl <= 1'b1;
            default: scl <= 1'b1; // 默认保持高电平
        endcase
    end
end


always @(posedge clk_i or negedge rst_n) begin
    if (!rst_n) begin
        sda_t <= 1'b1;
    end else begin
        case (nstate)
            idle: sda_t <= 1'b1;
            start_bit: sda_t <= 1'b0;
            repeat_start :begin
                if (Rec_count >= 16'd12) begin
                    sda_t <= 1'b0;
                end else begin
                    sda_t <= 1'b1;
                end
            end
            rd_data_byte: begin 
                if ( Rec_count == 16'd16) begin
                    sda_t <= 1'b0;
                end
                else    sda_t <= 1'b1;
            end
            wr_dev_ctrl, wr_reg_high, wr_reg_low, wr_data_byte: 
                sda_t <= (Rec_count == 16'd15 || Rec_count == 16'd16) ? 1'b1 : 1'b0;

            rd_dev_ctrl: sda_t <= (Rec_count == 16'd15 || Rec_count == 16'd16|| Rec_count == 16'd17) ? 1'b1 : 1'b0;
            i2c_over: sda_t <= 1'b0;
            default: sda_t <= 1'b1;
        endcase
    end
end


always @(posedge clk_i or negedge rst_n) begin
    if (!rst_n) begin
      
        sda_o <= 1'b1;
        dev_r <= 8'hff;
        reg_h <= 8'hff;
        reg_l <= 8'hff;
        data_byte_r <= 8'hff;
        rd_dev_r <= 8'h00;
        rd_reg_h <= 8'h00;
        rd_reg_l <= 8'h00;
        rd_data_byte_r <= 8'h00;
    end else begin
        case (nstate)
            idle: begin
                sda_o <= 1'b1;
            end
            start_bit: begin
                dev_r <= {i2c_device_addr[6:0], 1'b0};
                reg_h <= register[15:8];
                reg_l <= register[7:0];
                data_byte_r <= data_byte;
                // rd_data_byte_r <= cam_data_byte;
                if (Rec_count >= 16'd3) begin
                    sda_o <= dev_r[7];
                end else begin
                    sda_o <= 1'b0;
                end
            end
            wr_dev_ctrl: begin
                if (Rec_count == 16'd15 || Rec_count == 16'd16) begin
                    sda_o <= 1'b1;
                end else if (Rec_count == 16'd17) begin
                    sda_o <= reg_h[7];
                end else begin
                    sda_o <= dev_r[7];
                    if (!scl) dev_r <= {dev_r[6:0], dev_r[7]};
                end
            end
            
            wr_reg_high: begin
                if (Rec_count == 16'd15 || Rec_count == 16'd16) begin
                    sda_o <= 1'b1;
                end else if (Rec_count == 16'd17) begin
                    sda_o <= reg_l[7];
                end else begin
                    sda_o <= reg_h[7];
                    if (!scl) reg_h <= {reg_h[6:0], reg_h[7]};
                end
            end
            
            wr_reg_low: begin
                if (Rec_count == 16'd15 || Rec_count == 16'd16) begin
                    sda_o <= 1'b1;
                end else if (Rec_count == 16'd17 && wr_rd_flag == 1'b0) begin
                    sda_o <= data_byte_r[7];
                end 
                else if (Rec_count == 16'd17 && wr_rd_flag == 1'b1) begin
                    sda_o <= 1'b1; // 如果是读操作，发送ACK信号
                end
                else begin
                    sda_o <= reg_l[7];
                    if (!scl) reg_l <= {reg_l[6:0], reg_l[7]};
                end
            end
            
            wr_data_byte: begin
                if (Rec_count == 16'd15 || Rec_count == 16'd16) begin
                    sda_o <= 1'b1;
                end else if (Rec_count == 16'd17) begin
                    sda_o <= 1'b0;
                end else begin
                    sda_o <= data_byte_r[7];
                    if (!scl) data_byte_r <= {data_byte_r[6:0], data_byte_r[7]};
                end
            end
            
            repeat_start: begin
                rd_dev_r <= {i2c_device_addr[6:0], 1'b1};
                if (Rec_count == 16'd16||Rec_count == 16'd15) begin
                    sda_o <= dev_r[7];
                end else if (Rec_count >= 16'd12) begin
                    sda_o <= 1'b0;
                end
                else if (Rec_count < 16'd12) begin
                    sda_o <= 1'b1;
                end
            end
            
            rd_dev_ctrl: begin
                if (Rec_count == 16'd15 || Rec_count == 16'd16||Rec_count == 16'd17) begin
                    sda_o <= 1'b1;
                // end else if (Rec_count == 16'd17) begin
                //     sda_o <= rd_dev_r[7];//存疑
                // 
                end 
                else begin
                    sda_o <= rd_dev_r[7];
                    if (!scl) rd_dev_r <= {rd_dev_r[6:0], rd_dev_r[7]};
                end
            end
            
            rd_data_byte: begin
                if (Rec_count == 16'd16) begin
                    sda_o<= 1'b0;
                end else 
                    sda_o <= 1'b1;
            end
            
            i2c_over: begin
                
                if (Rec_count <= 16'd1) begin
                    sda_o <= 1'b0;
                end else begin
                    sda_o <= 1'b1;
                end
            end
            default: sda_o <= 1'b1;
        endcase
    end
end

always @(posedge clk_i or negedge rst_n) begin 
    if (!rst_n) begin 
        rd_data <= 8'h00;
    end else begin
        case (nstate)
            idle: rd_data <= 8'h00;

            // 只在SCL上升沿、数据位（非ACK位）采样
            rd_data_byte: begin
                if (scl_rise && Rec_count < 16'd16)
                    rd_data <= {rd_data[6:0], sda_i};
            end
            default: rd_data <= rd_data;
        endcase
    end
end


always @(posedge clk_i or negedge rst_n) begin
    if (!rst_n) begin
        Rec_count <= 16'd0;
        State_turn <= 1'b0;
    end else begin
        case (nstate)
            idle: begin
                Rec_count <= 16'd0;
                State_turn <= 1'b0;
            end
            repeat_start: begin
                if (Rec_count == 16'd16) begin
                    Rec_count <= 16'd0;
                    State_turn <= 1'b1;
                end
                     else begin
                    Rec_count <= Rec_count + 1'b1;
                    State_turn <= 1'b0;
                end
                
            end

            start_bit,  i2c_over: begin
                if (Rec_count == 16'd3) begin // 4周期计数
                    Rec_count <= 16'd0;
                    State_turn <= 1'b1;
                end else begin
                    Rec_count <= Rec_count + 1'b1;
                    State_turn <= 1'b0;
                end
            end
            
            default: begin // 数据传输状态
                if (Rec_count == 16'd17) begin // 18周期计数
                    Rec_count <= 16'd0;
                    State_turn <= 1'b1;
                end else begin
                    Rec_count <= Rec_count + 1'b1;
                    State_turn <= 1'b0;
                end
            end
        endcase
    end
end


always @(posedge clk_i or negedge rst_n) begin
    if (!rst_n) begin
        err <= 1'b0;
    end else begin
        case (nstate)
            wr_dev_ctrl, wr_reg_high, wr_reg_low, wr_data_byte, rd_dev_ctrl: begin

                if (Rec_count == 16'd16) begin
                    err <= ~sda_i; // ACK检测（期望0），如果SDA高表示没有应答
                end else begin
                    err <= err;
                end
            end

            rd_data_byte: begin
                if (Rec_count == 16'd16) begin
                    // 读数据结束后的 ACK 检测
                    err <= ~sda_i;   // 如果SDA=1 → 无应答
                end else begin
                    err <= err; // 保持原值，不要在读数据过程中乱改
                end
            end

            default: begin
                err <= 1'b0;
            end
        endcase
    end
end


always @(posedge clk_i or negedge rst_n) begin
    if (!rst_n) begin
        busy <= 1'b0;
    end else begin
        case (nstate)
            idle: busy <= 1'b0;
            default: busy <= 1'b1;
        endcase
    end
end

always @(posedge clk_i or negedge rst_n) begin
    if (!rst_n) begin
        cstate <= idle;
    end else begin
        cstate <= nstate;
    end
end

endmodule

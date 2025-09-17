// module cam_reset_min(
//     input clk_50m,
//     output reg cam_rst  // 连接到Y26
// );

// reg [7:0] cnt;
// always @(posedge clk_50m) begin
//     if (cnt < 8'd50) begin  // 1ms复位脉冲
//         cam_rst <= 0;    // 拉低复位
//         cnt <= cnt + 1;
//     end else begin
//         cam_rst <= 1;    // 释放复位
//     end
// end

// endmodule
module cam_reset_min(
    input clk_50m,
    output reg cam_rst
);
reg [14:0] cnt;  // 折中方案：200μs复位
always @(posedge clk_50m) begin
    if(cnt < 15'd10_000) begin  // 200μs
        cam_rst <= 0;
        cnt <= cnt + 1;
    end else begin
        cam_rst <= 1;
    end
end
endmodule
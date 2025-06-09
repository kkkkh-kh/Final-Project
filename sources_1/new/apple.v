`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/02 13:52:45
// Design Name: 
// Module Name: apple
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


module apple (
    input clk,
    input reset, 
    input [9:0]snake_x,//蛇头x
    input [9:0]snake_y,//蛇头y
    output reg [9:0] apple_x,//苹果x坐标
    output reg [9:0] apple_y,//苹果y坐标
    output reg add//判定为可加分
);
    reg [9:0] random_x; //随机数x
    reg [9:0] random_y; //随机数y,有待根据屏幕尺寸修改
    reg [15:0] lfsr;

always @(posedge clk or posedge reset) begin
    if (reset)
        lfsr <= 16'hACE1; // 初始种子
    else
        lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
        random_x <= lfsr[9:0];
        random_y <= lfsr[15:6];
end



always @(posedge clk or posedge reset) begin
    if (reset) begin
        apple_x <= 10'd16; // Reset 
        apple_y <= 10'd20; // Reset 
        add <= 1'b0; // Reset add signal
    end else begin
        if (snake_x == apple_x && snake_y == apple_y) begin
            add <= 1'b1; 
            apple_x <= random_x[9:0]; // Update apple_x with random value
            apple_y <= random_y[9:0]; // Update apple_y with random value
        end else begin
            add <= 1'b0; // No collision, reset add signal
        end
    end
end
endmodule




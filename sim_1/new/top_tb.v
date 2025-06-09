`timescale 1ns / 1ps

module top_tb;
    reg clk;
    reg reset;
    reg [3:0] BTN;
    reg [2:0] SW;
    
    wire [9:0] head_x;
    wire [9:0] head_y;
    wire [11:0] score;

    // 实例化 top 模块
    top uut (
        .clk(clk),
        .reset(reset),
        .BTN(BTN),
        .SW(SW),
        .head_x(head_x),
        .head_y(head_y),
        .score(score)
    );

    // 产生时钟信号
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz 时钟
    end

    // 主测试逻辑
    initial begin
        $display("Simulation Start");
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);

        // 初始化
        reset = 0;
        BTN = 4'b0000;
        SW = 3'b001; // 设置初始速度
        #20;

        reset = 1; // 释放复位
        #50;

        // 模拟按键按下（向右）


        // 模拟向下
        BTN = 4'b0010;
        #200;

        // 模拟吃苹果或蛇移动情况
        BTN = 4'b0001;
        #500;

        // 模拟长时间运行
        BTN = 4'b0000;
        #2000;

        // 结束仿真
        $display("Simulation End");
        $finish;
    end
endmodule

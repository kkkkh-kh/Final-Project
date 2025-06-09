`timescale 1ns / 1ps

module game_tb;

  // 输入信号
  reg clk;
  reg reset;
  reg [3:0] BTN;
  reg [2:0] SW;
  reg hit_wall;
  reg hit_self;

  // 输出信号
  wire [1:0] game_state;

  // 实例化被测模块
  game uut (
    .clk(clk),
    .reset(reset),
    .BTN(BTN),
    .SW(SW),
    .hit_wall(hit_wall),
    .hit_self(hit_self),
    .game_state(game_state)
  );

  // 生成时钟：10ns周期
  initial clk = 0;
  always #5 clk = ~clk;

  // 测试流程
  initial begin
    $display("Start simulation");
    $monitor("Time=%t, game_state=%b", $time, game_state);

    // 初始化信号
    reset = 0;
    BTN = 0;
    SW = 0;
    hit_wall = 0;
    hit_self = 0;

    #20 reset = 1;  // 释放复位
    #10;

    // 尝试按下按钮进入 PLAYING 状态
    BTN = 2'b01;
    //#10 BTN = 2'b00;
    #20;

    // 模拟一段时间后撞墙，进入 OVER 状态
    hit_wall = 1;
    #10 hit_wall = 0;
    #20;

    // 模拟按下按钮进入 RESTART 状态
    BTN = 2'b01;
    #10 BTN = 2'b00;
    #20;

    // 模拟开关拉起，进入 PLAYING 状态
    SW = 2'b01;
    #10 SW = 2'b00;
    #20;

    $display("End simulation");
    $finish;
  end

endmodule

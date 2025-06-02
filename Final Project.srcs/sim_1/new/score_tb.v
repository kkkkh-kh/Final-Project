`timescale 1ns / 1ps

module scores_tb;

  // 输入信号
  reg clk;
  reg reset;
  reg add;

  // 输出信号
  wire [11:0] score;

  // 实例化待测试模块
  scores uut (
    .clk(clk),
    .reset(reset),
    .add(add),
    .score(score)
  );

  // 时钟生成：10ns周期
  initial clk = 0;
  always #5 clk = ~clk;

  // 测试序列
  initial begin
    $display("Start simulation...");
    
    // 初始化信号
    reset = 0; add = 0;
    #20;

    // 拉高 reset，使能开始加分
    reset = 1;
    #10;

    // 模拟连续加分
    repeat (5) begin
      add = 1;
      #10;
      add = 0;
      #10;
    end

    // 模拟快速加满（到 4095）
    repeat (4096) begin
      add = 1;
      #10;
      add = 0;
      #10;
    end

    // 停止仿真
    $display("Final score = %d", score);
    $finish;
  end

endmodule

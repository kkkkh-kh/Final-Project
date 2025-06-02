`timescale 1ns/1ps

module snake_direction_tb;

    reg clk;
    reg reset;
    reg [3:0] BTN;
    reg [2:0] SW;
    reg [1:0] game_state;
    reg add;
    wire [9:0] head_x;
    wire [9:0] head_y;
    wire [1:0] hit_wall;
    wire [1:0] hit_self;

    // 实例化 snake_direction
    snake_direction uut (
        .clk(clk),
        .reset(reset),
        .BTN(BTN),
        .SW(SW),
        .head_x(head_x),
        .head_y(head_y),
        .game_state(game_state),
        .add(add),
        .hit_wall(hit_wall),
        .hit_self(hit_self)
    );

    // 时钟生成
    always #5 clk = ~clk;

    initial begin
        // 初始化
        clk = 0;
        reset = 0;
        BTN = 4'b0000;
        SW = 3'b001; // 设置低速
        add = 0;
        game_state = 2'b11; // STATE_PLAYING

        #20;
        reset = 1; // 释放复位

        #50;

        // 模拟方向输入
        BTN = 4'b0001; // UP
        #100;

        BTN = 4'b0100; // DOWN
        #100;

        BTN = 4'b0010; // LEFT
        #100;
        BTN=0;
        #20;
        BTN = 4'b1000; // RIGHT
        #100;

        BTN = 4'b0000;

        // 模拟 add 使蛇增长
        add = 1;
        #100;
        add = 0;

        // 观察输出一段时间
        #1000;

        // 模拟撞墙
        // 直接将蛇头设置为边界进行碰撞测试（建议在设计中暴露接口进行直接赋值）

        $stop;
    end

endmodule

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

    // ʵ���� snake_direction
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

    // ʱ������
    always #5 clk = ~clk;

    initial begin
        // ��ʼ��
        clk = 0;
        reset = 0;
        BTN = 4'b0000;
        SW = 3'b001; // ���õ���
        add = 0;
        game_state = 2'b11; // STATE_PLAYING

        #20;
        reset = 1; // �ͷŸ�λ

        #50;

        // ģ�ⷽ������
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

        // ģ�� add ʹ������
        add = 1;
        #100;
        add = 0;

        // �۲����һ��ʱ��
        #1000;

        // ģ��ײǽ
        // ֱ�ӽ���ͷ����Ϊ�߽������ײ���ԣ�����������б�¶�ӿڽ���ֱ�Ӹ�ֵ��

        $stop;
    end

endmodule

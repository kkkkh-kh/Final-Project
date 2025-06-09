`timescale 1ns / 1ps

module game_tb;

  // �����ź�
  reg clk;
  reg reset;
  reg [3:0] BTN;
  reg [2:0] SW;
  reg hit_wall;
  reg hit_self;

  // ����ź�
  wire [1:0] game_state;

  // ʵ��������ģ��
  game uut (
    .clk(clk),
    .reset(reset),
    .BTN(BTN),
    .SW(SW),
    .hit_wall(hit_wall),
    .hit_self(hit_self),
    .game_state(game_state)
  );

  // ����ʱ�ӣ�10ns����
  initial clk = 0;
  always #5 clk = ~clk;

  // ��������
  initial begin
    $display("Start simulation");
    $monitor("Time=%t, game_state=%b", $time, game_state);

    // ��ʼ���ź�
    reset = 0;
    BTN = 0;
    SW = 0;
    hit_wall = 0;
    hit_self = 0;

    #20 reset = 1;  // �ͷŸ�λ
    #10;

    // ���԰��°�ť���� PLAYING ״̬
    BTN = 2'b01;
    //#10 BTN = 2'b00;
    #20;

    // ģ��һ��ʱ���ײǽ������ OVER ״̬
    hit_wall = 1;
    #10 hit_wall = 0;
    #20;

    // ģ�ⰴ�°�ť���� RESTART ״̬
    BTN = 2'b01;
    #10 BTN = 2'b00;
    #20;

    // ģ�⿪�����𣬽��� PLAYING ״̬
    SW = 2'b01;
    #10 SW = 2'b00;
    #20;

    $display("End simulation");
    $finish;
  end

endmodule

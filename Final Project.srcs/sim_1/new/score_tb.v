`timescale 1ns / 1ps

module scores_tb;

  // �����ź�
  reg clk;
  reg reset;
  reg add;

  // ����ź�
  wire [11:0] score;

  // ʵ����������ģ��
  scores uut (
    .clk(clk),
    .reset(reset),
    .add(add),
    .score(score)
  );

  // ʱ�����ɣ�10ns����
  initial clk = 0;
  always #5 clk = ~clk;

  // ��������
  initial begin
    $display("Start simulation...");
    
    // ��ʼ���ź�
    reset = 0; add = 0;
    #20;

    // ���� reset��ʹ�ܿ�ʼ�ӷ�
    reset = 1;
    #10;

    // ģ�������ӷ�
    repeat (5) begin
      add = 1;
      #10;
      add = 0;
      #10;
    end

    // ģ����ټ������� 4095��
    repeat (4096) begin
      add = 1;
      #10;
      add = 0;
      #10;
    end

    // ֹͣ����
    $display("Final score = %d", score);
    $finish;
  end

endmodule

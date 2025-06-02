`timescale 1ns / 1ps

module top_tb;
    reg clk;
    reg reset;
    reg [3:0] BTN;
    reg [2:0] SW;
    
    wire [9:0] head_x;
    wire [9:0] head_y;
    wire [11:0] score;

    // ʵ���� top ģ��
    top uut (
        .clk(clk),
        .reset(reset),
        .BTN(BTN),
        .SW(SW),
        .head_x(head_x),
        .head_y(head_y),
        .score(score)
    );

    // ����ʱ���ź�
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz ʱ��
    end

    // �������߼�
    initial begin
        $display("Simulation Start");
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);

        // ��ʼ��
        reset = 0;
        BTN = 4'b0000;
        SW = 3'b001; // ���ó�ʼ�ٶ�
        #20;

        reset = 1; // �ͷŸ�λ
        #50;

        // ģ�ⰴ�����£����ң�


        // ģ������
        BTN = 4'b0010;
        #200;

        // ģ���ƻ�������ƶ����
        BTN = 4'b0001;
        #500;

        // ģ�ⳤʱ������
        BTN = 4'b0000;
        #2000;

        // ��������
        $display("Simulation End");
        $finish;
    end
endmodule

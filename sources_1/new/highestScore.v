`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/08 22:27:51
// Design Name: 
// Module Name: highestScore
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


module highest_score_ctrl (
    input wire clk,
    input wire reset,             // ԭʼ��е��������
    input wire [11:0] score,      // ��ǰ����
    output reg [11:0] highestScore,  // �����߷�
    output reg reset_stable
);

    // ͬ�� + ��������
    reg reset_sync1, reset_sync2;
    always @(posedge clk) begin
        reset_sync1 <= reset;
        reset_sync2 <= reset_sync1;
    end

    // ���˲��������ڷ�����
    reg [7:0] pbshift;

    always@(posedge clk) begin
        pbshift = pbshift<<1;
        pbshift[0] = reset_sync2;
        if (pbshift==8'b0)
            reset_stable=0;
        if (pbshift==8'hFF)
            reset_stable=1;    
    end



    // �����ж��Ƿ񳤰�8��
    reg [29:0] reset_cnt;
    wire long_press_8s = (reset_cnt >= 30'd500_0000); // ����һ��ʱ������Ч

    always @(posedge clk) begin
        if (reset_stable) begin
            if (reset_cnt < 30'd500_0000)
                reset_cnt <= reset_cnt + 1;
            else
                reset_cnt <= reset_cnt;
        end else begin
            reset_cnt <= 0;
        end
    end

    // highestScore �����߼�
    always @(posedge clk) begin
        if (long_press_8s)
            highestScore <= 12'd0;
        else if (score > highestScore)
            highestScore <= score;
    end

endmodule


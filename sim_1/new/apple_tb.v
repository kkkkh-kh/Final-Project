`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/02 14:23:27
// Design Name: 
// Module Name: apple_tb
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



module apple_tb;

  // Ports
  reg clk;
  reg reset;
  reg [9:0] snake_x;
  reg [9:0] snake_y;
  wire [9:0] apple_x;
  wire [9:0] apple_y;
  wire add;

  // Instantiate the DUT (Device Under Test)
  apple apple_inst (
    .clk(clk),
    .reset(reset),
    .snake_x(snake_x),
    .snake_y(snake_y),
    .apple_x(apple_x),
    .apple_y(apple_y),
    .add(add)
  );

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk; // ÿ 5 ʱ�䵥λ��תһ�Σ�ʵ������Ϊ10��ʱ��

  // Test sequence
  initial begin
    // ��ʼ��
    reset = 0;
    snake_x = 10'd100;
    snake_y = 10'd150;

    #10;
    reset = 1;

    // ģ�����ƶ����۲� apple ����� add �仯
    #50;
    snake_x = 10'd200;
    snake_y = 10'd250;

    #50;
    snake_x = apple_x;
    snake_y = apple_y;

    #50;

    $finish;
  end

endmodule






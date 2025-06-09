`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/04 15:49:01
// Design Name: 
// Module Name: vgac
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
module vga_ctrl(
    input vga_clk,
    input clrn,
    input [11:0] d_in,
    output reg [8:0] row_addr,
    output reg [9:0] col_addr,
    output reg rdn,
    output reg [3:0] r,g,b,
    output reg hs, vs
);  
    wire pix_clk;
    reg [9:0] h_cnt=0;
    reg [9:0] v_cnt=0;

    localparam h_sync=96;
    localparam h_back=48;
    localparam h_disp=640;
    localparam h_front=16;
    localparam h_total=800;

    localparam v_sync=2;
    localparam v_back=33;
    localparam v_disp=480;
    localparam v_front=10;
    localparam v_total=525;

    always@(posedge vga_clk,negedge clrn) begin
        if(!clrn) begin 
            h_cnt<=0;
            v_cnt<=0;
        end else begin
            if(h_cnt == h_total-1) begin
                h_cnt<=0;
                if(v_cnt == v_total-1)
                    v_cnt<=0;
                else
                    v_cnt<=v_cnt+1;
            end else begin
                h_cnt<=h_cnt+1;
            end
        end
    end

    always @(posedge vga_clk) begin
        hs=(h_cnt<h_sync)?0:1;
        vs=(v_cnt<v_sync)?0:1;
    end
    wire valid;
    assign valid=(h_cnt>=h_sync+h_back&&h_cnt<h_sync+h_back+h_disp)&&(v_cnt>=v_sync+v_back&&v_cnt<v_sync+v_back+v_disp);

    always @(posedge vga_clk) begin
        if (valid) begin
            col_addr<=h_cnt-(h_sync+h_back)+1;
            row_addr<=v_cnt-(v_sync+v_back)+1;
            rdn<=0;
            {r,g,b}<=d_in[11:0];
        end else begin
            col_addr<=0;
            row_addr<=0;
            rdn<=1;
            {r,g,b}<=12'h0;
        end
    end

endmodule

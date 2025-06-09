module top(
    input clk,
    input reset,
    input [3:0] BTN,
    input [2:0] SW,
    output [3:0] r,
    output [3:0] g,
    output [3:0] b,
    output hs,
    output vs
);
    wire vga_clk;
    wire [31:0] div_res;
    clkdiv clkdiv_inst(
        .clk(clk),
        .rst(~reset),
        .div_res(div_res)
    );
    
    clk_gen clk_gen_inst(
        .clk(div_res), // 100 MHz
        .vga_clk(vga_clk) // 25 MHz
        );
   /* DispNum D0( .AN(AN）,
                .BTN(BTN),
                .BTN_X(BTN_X),
                .SEGMENT(SEGMENT),
                .SW(SW)
                );//这个七段数码管前四位显示最高纪录，后四位当前记录的显示应该还要根据端口再修改一下
    *///最高纪录的模块应该也还要写一下
    wire [1:0] game_state;
    wire [2:0] state;
    wire [9:0] head_x;
    wire [8:0] head_y;
    reg [10*16-1:0] snake_x_bus;
    reg [9*16-1:0] snake_y_bus;
    wire [4:0] snake_len;
    wire [9:0] apple_x;
    wire [8:0] apple_y;
    wire add;
    wire hit_wall;
    wire hit_self;
    wire [11:0] score;
    reg [11:0] rgb_out;
    

    scores scores_inst (
        .clk(clk),
        .reset(reset_stable),
        .add(add),
        .score(score)
    );
    highest_score_ctrl  highest_score_ctrl_inst (
    .clk(clk),
    .reset(reset),
    .score(score),
    .highestScore(highestScore),
    .reset_stable(reset_stable)
  );
    game game_inst (
        .clk(clk),
        .reset(reset_stable),
        .BTN(BTN),
        .SW(SW),
        .hit_wall(hit_wall),
        .hit_self(hit_self),
        .game_state(game_state)
    );

    snake  snake_inst (
        .clk(clk),
        .reset(reset_stable),
        .BTN(BTN),
        .SW(SW),
        .head_x(head_x),
        .head_y(head_y),
        .game_state(game_state),
        .add(add),
        .hit_wall(hit_wall),
        .hit_self(hit_self),
        .snake_x_bus(snake_x_bus),
        .snake_y_bus(snake_y_bus),
        .snake_len(snake_len)
    );

    apple apple_inst (
        .clk(clk),
        .reset(clrn),
        .snake_x(head_x),
        .snake_y(head_y),
        .apple_x(apple_x),
        .apple_y(apple_y),
        .add(add)
    );
    vga_ctrl vgac (
        .vga_clk(vga_clk),
        .clrn(reset_stable),
        .d_in({rgb_out[3:0],rgb_out[7:4],rgb_out[11:8]}),
        .row_addr(row_addr),
        .col_addr(col_addr),
        .rdn(rdn),
        .r(r),.g(g),.b(b),
        .hs(hs),.vs(vs)
    );
    vga_screen_pic vgas (
           .node_x(col_addr),
           .node_y(row_addr),
           .snake_x_bus(snake_x_bus),
           .snake_y_bus(snake_y_bus),
           .head_x(head_x),
           .head_y(head_y),
           .apple_x(apple_x),
           .apple_y(apple_y),
           .clk(div_res),
           .game_state(game_state),
           .rgb_out(rgb_out)
    );
endmodule

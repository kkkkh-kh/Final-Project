module top(
    input clk,
    input reset, //�͵�ƽ��Ч
    input [3:0] BTN, //����ѡ������
    input [2:0] SW,  //�Ѷ�����
    output [9:0] head_x,
    output [9:0] head_y,
    output [11:0] score
);
    wire add;
    wire [9:0] apple_x;
    wire [9:0] apple_y;
    wire hit_wall;
    wire hit_self;
    wire [1:0] game_state;

    scores scores_inst (
        .clk(clk),
        .reset(reset),
        .add(add),
        .score(score)
    );

    game game_inst (
        .clk(clk),
        .reset(reset),
        .BTN(BTN),
        .SW(SW),
        .hit_wall(hit_wall),
        .hit_self(hit_self),
        .game_state(game_state)
    );

    snake_direction snake_direction_inst (
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

    apple apple_inst (
        .clk(clk),
        .reset(reset),
        .snake_x(head_x),
        .snake_y(head_y),
        .apple_x(apple_x),
        .apple_y(apple_y),
        .add(add)
    );
endmodule

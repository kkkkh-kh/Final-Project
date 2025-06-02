module game(
    input clk,
    input reset,//低电平有效
    input [3:0] BTN,
    input [2:0] SW,
    input hit_wall, //碰撞墙壁
    input hit_self, //碰撞自身
    output reg [1:0]  game_state//游戏状态
);
    // 游戏状态定义
    localparam STATE_START = 2'b00; // 游戏开始
    localparam STATE_RESTART= 2'b01; // 重新开始
    localparam STATE_OVER = 2'b10; // 游戏结束
    localparam STATE_PLAYING = 2'b11; // 游戏进行中
    //reg [32:0] counter; //计数器
    always@(posedge clk or negedge reset) begin
        if (!reset) begin
            //counter <= 0;
            game_state <= STATE_START; // 初始化游戏状态为开始
            end
        else begin
            case(game_state)
                STATE_START: begin
                    if (BTN[0] || BTN[1] || BTN[2] ||BTN[3]) begin
                        game_state <=STATE_PLAYING; // 按下任意按钮，进入游戏状态
                        //counter <= 0; // 重置计数器
                    end else begin
                        game_state <= STATE_START; // 保持在开始状态
                    end               
                end

                STATE_RESTART: begin
                    if (SW[0] || SW[1] || SW[2]) begin
                        game_state <= STATE_PLAYING; // 按下任意难度选择开关，进入游戏进行状态
                        //counter <= 0; // 重置计数器
                    end else begin
                        game_state <= STATE_RESTART; // 保持在重新开始状态
                    end
                end

                STATE_PLAYING: begin
                    if (hit_wall || hit_self) begin
                        game_state <= STATE_OVER; // 碰撞墙壁或自身，进入游戏结束状态
                    end else begin
                        game_state <= STATE_PLAYING; // 保持在游戏进行状态
                    end
                end
                STATE_OVER: begin
                    if (BTN[0] || BTN[1] || BTN[2] ||BTN[3]) begin
                        game_state <= STATE_RESTART; // 按下任意按钮，进入重新开始状态
                        //counter <= 0; // 重置计数器
                    end else begin
                        game_state <= STATE_OVER; // 保持在游戏结束状态
                    end
                end
                default: begin
                    game_state <= STATE_START; // 默认状态为开始
                end
            endcase
        end
    end
endmodule




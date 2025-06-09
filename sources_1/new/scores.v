module scores (
    input  clk,
    input  reset, 
    input  add,//判定为可加分
    //input [1:0] game_state, //游戏状态
    output reg [11:0] score//当前分数
);
always @(posedge clk or posedge reset) begin
    if (reset) begin
        score <= 0; // Reset score to 0
    end else if (add) begin
        if (score < 12'b1111_1111_1111) begin // Check if score is less than the maximum value (4095)
            score <= score + 1; // Increment score by 1
        end
        end
    end
endmodule //scores
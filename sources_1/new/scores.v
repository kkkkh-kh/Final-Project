module scores (
    input  clk,
    input  reset, 
    input  add,//�ж�Ϊ�ɼӷ�
    //input [1:0] game_state, //��Ϸ״̬
    output reg [11:0] score//��ǰ����
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
module game(
    input clk,
    input reset,//�͵�ƽ��Ч
    input [3:0] BTN,
    input [2:0] SW,
    input hit_wall, //��ײǽ��
    input hit_self, //��ײ����
    output reg [1:0]  game_state//��Ϸ״̬
);
    // ��Ϸ״̬����
    localparam STATE_START = 2'b00; // ��Ϸ��ʼ
    localparam STATE_RESTART= 2'b01; // ���¿�ʼ
    localparam STATE_OVER = 2'b10; // ��Ϸ����
    localparam STATE_PLAYING = 2'b11; // ��Ϸ������
    //reg [32:0] counter; //������
    always@(posedge clk or negedge reset) begin
        if (!reset) begin
            //counter <= 0;
            game_state <= STATE_START; // ��ʼ����Ϸ״̬Ϊ��ʼ
            end
        else begin
            case(game_state)
                STATE_START: begin
                    if (BTN[0] || BTN[1] || BTN[2] ||BTN[3]) begin
                        game_state <=STATE_PLAYING; // �������ⰴť��������Ϸ״̬
                        //counter <= 0; // ���ü�����
                    end else begin
                        game_state <= STATE_START; // �����ڿ�ʼ״̬
                    end               
                end

                STATE_RESTART: begin
                    if (SW[0] || SW[1] || SW[2]) begin
                        game_state <= STATE_PLAYING; // ���������Ѷ�ѡ�񿪹أ�������Ϸ����״̬
                        //counter <= 0; // ���ü�����
                    end else begin
                        game_state <= STATE_RESTART; // ���������¿�ʼ״̬
                    end
                end

                STATE_PLAYING: begin
                    if (hit_wall || hit_self) begin
                        game_state <= STATE_OVER; // ��ײǽ�ڻ�����������Ϸ����״̬
                    end else begin
                        game_state <= STATE_PLAYING; // ��������Ϸ����״̬
                    end
                end
                STATE_OVER: begin
                    if (BTN[0] || BTN[1] || BTN[2] ||BTN[3]) begin
                        game_state <= STATE_RESTART; // �������ⰴť���������¿�ʼ״̬
                        //counter <= 0; // ���ü�����
                    end else begin
                        game_state <= STATE_OVER; // ��������Ϸ����״̬
                    end
                end
                default: begin
                    game_state <= STATE_START; // Ĭ��״̬Ϊ��ʼ
                end
            endcase
        end
    end
endmodule




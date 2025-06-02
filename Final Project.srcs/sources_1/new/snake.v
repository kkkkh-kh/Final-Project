module snake_direction (
    input clk,
    input reset, //�͵�ƽ��Ч
    input [3:0] BTN, //����ѡ������
    input [1:0] SW, //�Ѷ�����
    output reg [9:0] head_x, //��ͷλ��
    output reg [9:0] head_y, //��ͷλ��

    input [1:0] game_state, // ��Ϸ״̬
    input add, // �߳�������
    output reg hit_wall, // ��ײǽ��
    output reg hit_self  // ��ײ����
);

localparam UP    = 4'b0001;
localparam DOWN  = 4'b0010;
localparam LEFT  = 4'b0100;
localparam RIGHT = 4'b1000;

localparam MAX_X = 10'd640;//�д��޸�
localparam MAX_Y = 10'd480;

localparam STATE_START   = 2'b00;
localparam STATE_RESTART = 2'b01;
localparam STATE_OVER    = 2'b10;
localparam STATE_PLAYING = 2'b11;

reg [9:0] node_x [0:15];
reg [9:0] node_y [0:15];
reg [3:0] length; // ��󳤶�16
reg [31:0] counter;
reg [31:0] speed;
reg [3:0] direction;
reg debug;

// �ٶ��趨
always @(posedge clk or negedge reset) begin
    if (!reset) begin
        speed <= 32'd500000;
    end else begin
        case (SW[1:0])
            2'b01: speed <= 32'd500000;
            2'b10: speed <= 32'd1000000;
            2'b11: speed <= 32'd1500000;
            default: speed <= 32'd500000;
        endcase
    end
end

// �������
always @(posedge clk or negedge reset) begin
    if (!reset) direction <= RIGHT;
    else begin
        case (BTN)
            UP:    if (direction != DOWN)  direction <= UP;
            DOWN:  if (direction != UP)    direction <= DOWN;
            LEFT:  if (direction != RIGHT) direction <= LEFT;
            RIGHT: if (direction != LEFT)  direction <= RIGHT;
            default: direction <= direction;
        endcase
    end
end

// ��ʼ��/�ƶ��߼�
integer i;
always @(posedge clk or negedge reset) begin
    if (!reset || game_state == STATE_RESTART) begin
        length <= 4'd3;
        node_x[0] <= 10'd16; node_y[0] <= 10'd16;
        node_x[1] <= 10'd15; node_y[1] <= 10'd16;
        node_x[2] <= 10'd14; node_y[2] <= 10'd16;
        for (i = 3; i < 16; i = i + 1) begin
            node_x[i] <= 10'd0;
            node_y[i] <= 10'd0;
        end
        direction <= RIGHT;
        hit_wall <= 1'b0;
        hit_self <= 1'b0;
    end else begin
        debug<=1;
        counter <= counter + 1;
        if (counter >= (debug)?debug:speed && game_state == STATE_PLAYING) begin
            counter <= 0;

            // ײǽ���
            if ((node_x[0] == MAX_X && direction == RIGHT) ||
                (node_x[0] == 0 && direction == LEFT) ||
                (node_y[0] == MAX_Y && direction == DOWN) ||
                (node_y[0] == 0 && direction == UP)) begin
                hit_wall <= 1'b1;
            end else begin
                hit_wall <= 1'b0;

                // ײ�Լ����
                hit_self <= 1'b0;
                for (i = 1; i < length; i = i + 1) begin
                    if (node_x[0] == node_x[i] && node_y[0] == node_y[i]) begin
                        hit_self <= 1'b1;
                    end
                end

                // ���ƶ�
                if (!hit_self) begin
                    if (length < 15) begin
                        node_x[length + 1] <= node_x[length];
                        node_y[length + 1] <= node_y[length];
                    end

                    for (i = length; i > 0; i = i - 1) begin
                        node_x[i] <= node_x[i - 1];
                        node_y[i] <= node_y[i - 1];
                    end

                    case (direction)
                        UP:    node_y[0] <= node_y[0] - 1;
                        DOWN:  node_y[0] <= node_y[0] + 1;
                        LEFT:  node_x[0] <= node_x[0] - 1;
                        RIGHT: node_x[0] <= node_x[0] + 1;
                        default: ;
                    endcase

                    if (add && length < 15) begin
                        length <= length + 1;
                    end
                end
            end
        end
    end
    head_x <= node_x[0];
    head_y <= node_y[0];
end

endmodule

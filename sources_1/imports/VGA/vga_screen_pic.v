module vga_screen_pic(
    input [9:0] node_x,
    input [8:0] node_y,
    input [9:0] head_x,
    input [8:0] head_y,
    input [9:0] apple_x,
    input [8:0] apple_y,
    input [10*16-1:0] snake_x_bus,
    input [9*16-1:0] snake_y_bus,
    input clk, // 100 MHz
    input [1:0] game_state,
    output reg [11:0] rgb_out
    );

    parameter dot_size = 10'd16, // applesnake
               ui_size = 19'd640; // start/pause/over picture

    /*localparam STATE_START = 2'b00;
    localparam STATE_RESTART= 2'b01;
    localparam STATE_OVER = 2'b10;
    localparam STATE_PLAYING = 2'b11;
    12'h000,12'h000,12'h0f0,green,12'hff0,yellow,12'hf00,red*/

    wire [7:0] pic_rom0;  // apple/snake?finally we didnot use
    wire [18:0] pic_rom1; // start/pause/over picture
    wire [11:0] snake_head_data, snake_body_data, 
                apple_data, wall_data, 
                game_start_data, 
                game_over_data,game_pause_data;//rom data

function [9:0] cell_x;
    input [9:0] node_x;
    begin
        cell_x = (node_x >> 4) * dot_size;
    end
endfunction

function [8:0] cell_y; 
    input [8:0] node_y;
    begin
        cell_y = (node_y >> 4) * dot_size;
    end
endfunction

assign pic_rom0 = (node_x - cell_x(node_x)) + (node_y - cell_y(node_y)) * dot_size;
assign pic_rom1 = node_x + node_y * ui_size;


game_start game_start0(
    .addra(pic_rom1),
    .clka(clk),
    .douta(game_start_data)
);

game_pause game_pause0(
    .addra(pic_rom1),
    .clka(clk),
    .douta(game_pause_data)
);

game_over game_over0(
    .addra(pic_rom1),
    .clka(clk),
    .douta(game_over_data)
);
    integer i;
    reg matched;

always @(posedge clk) begin
    case (game_state)
        2'd0: rgb_out<= game_start_data;
        2'd1: rgb_out<= game_pause_data;
        2'd2: rgb_out<= game_over_data;
        
        2'd3: begin
            rgb_out <= 12'h000;
            // wall=brown
            if (node_x < 10 || node_x >= 630 || node_y < 10 || node_y >= 470)
                rgb_out <= 12'hA52;
        
            // apple=red
            else if ((node_x >= apple_x) && (node_x < apple_x + dot_size) &&
                     (node_y >= apple_y) && (node_y < apple_y + dot_size))
                rgb_out <= 12'hF00; 
        
            // snake_head=green
            else if ((node_x >= head_x) && (node_x < head_x + dot_size) &&
                     (node_y >= head_y) && (node_y < head_y + dot_size))
                rgb_out <= 12'h0F0;
            // snake_body=qingse
            else begin

                matched = 0;
                for (i = 0; i < 16; i = i + 1) begin
                    if ((snake_x_bus[10*i +: 10] == head_x) && (snake_y_bus[9*i +: 9] == head_y)) begin
                    end else if ((node_x >= snake_x_bus[10*i +: 10]) && (node_x < snake_x_bus[10*i +: 10] + dot_size) &&
                                 (node_y >= snake_y_bus[9*i +: 9]) && (node_y < snake_y_bus[9*i +: 9] + dot_size)) begin
                        matched = 1;
                    end
                end
                if (matched)
                    rgb_out <= 12'h0FF;
            end
        end
        
        default: rgb_out<= 12'h000; 
    endcase
end
endmodule
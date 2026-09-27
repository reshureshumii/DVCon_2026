module top2_comparator #(
    parameter DATA_WIDTH  = 16,
    parameter SCORE_WIDTH = 32,
    parameter THRESHOLD   = 32'd80000
) (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,

    input  wire [DATA_WIDTH-1:0]  confidence_0,
    input  wire [DATA_WIDTH-1:0]  weight_0,
    input  wire [DATA_WIDTH-1:0]  confidence_1,
    input  wire [DATA_WIDTH-1:0]  weight_1,
    input  wire [DATA_WIDTH-1:0]  confidence_2,
    input  wire [DATA_WIDTH-1:0]  weight_2,
    input  wire [DATA_WIDTH-1:0]  confidence_3,
    input  wire [DATA_WIDTH-1:0]  weight_3,
    input  wire [DATA_WIDTH-1:0]  confidence_4,
    input  wire [DATA_WIDTH-1:0]  weight_4,

    output reg  [2:0]             primary_index,
    output reg  [SCORE_WIDTH-1:0] primary_score,
    output reg  [2:0]             alternative_index,
    output reg  [SCORE_WIDTH-1:0] alternative_score,
    output reg  [4:0]             valid_mask,
    output reg                    done,
    output reg                    ready
);

    reg [SCORE_WIDTH-1:0] score0, score1, score2, score3, score4;
    reg [4:0]             above_thresh;
    reg                   valid_stage1;
    reg                   busy;

    always @(posedge clk) begin
        if (!rst_n) begin
            score0       <= 0;
            score1       <= 0;
            score2       <= 0;
            score3       <= 0;
            score4       <= 0;
            above_thresh <= 5'b0;
            valid_stage1 <= 1'b0;
        end else begin
            valid_stage1    <= start;
            score0          <= confidence_0 * weight_0;
            score1          <= confidence_1 * weight_1;
            score2          <= confidence_2 * weight_2;
            score3          <= confidence_3 * weight_3;
            score4          <= confidence_4 * weight_4;
            above_thresh[0] <= (confidence_0 * weight_0) >= THRESHOLD;
            above_thresh[1] <= (confidence_1 * weight_1) >= THRESHOLD;
            above_thresh[2] <= (confidence_2 * weight_2) >= THRESHOLD;
            above_thresh[3] <= (confidence_3 * weight_3) >= THRESHOLD;
            above_thresh[4] <= (confidence_4 * weight_4) >= THRESHOLD;
        end
    end

    reg [SCORE_WIDTH-1:0] max_s, sec_s;
    reg [2:0]             max_i, sec_i;

    always @(posedge clk) begin
        if (!rst_n) begin
            primary_index     <= 3'd0;
            primary_score     <= 0;
            alternative_index <= 3'd0;
            alternative_score <= 0;
            valid_mask        <= 5'b0;
            done              <= 1'b0;
            ready             <= 1'b1;
            busy              <= 1'b0;
        end else begin
            done <= 1'b0;

            if (start && !busy) begin
                busy  <= 1'b1;
                ready <= 1'b0;
            end

            if (valid_stage1) begin
                busy  <= 1'b0;
                ready <= 1'b1;

                max_s = 0; max_i = 3'd0;
                sec_s = 0; sec_i = 3'd0;

                if (above_thresh[0]) begin
                    max_s = score0; max_i = 3'd0;
                end

                if (above_thresh[1]) begin
                    if (score1 > max_s) begin
                        sec_s = max_s; sec_i = max_i;
                        max_s = score1; max_i = 3'd1;
                    end else if (score1 > sec_s) begin
                        sec_s = score1; sec_i = 3'd1;
                    end
                end

                if (above_thresh[2]) begin
                    if (score2 > max_s) begin
                        sec_s = max_s; sec_i = max_i;
                        max_s = score2; max_i = 3'd2;
                    end else if (score2 > sec_s) begin
                        sec_s = score2; sec_i = 3'd2;
                    end
                end

                if (above_thresh[3]) begin
                    if (score3 > max_s) begin
                        sec_s = max_s; sec_i = max_i;
                        max_s = score3; max_i = 3'd3;
                    end else if (score3 > sec_s) begin
                        sec_s = score3; sec_i = 3'd3;
                    end
                end

                if (above_thresh[4]) begin
                    if (score4 > max_s) begin
                        sec_s = max_s; sec_i = max_i;
                        max_s = score4; max_i = 3'd4;
                    end else if (score4 > sec_s) begin
                        sec_s = score4; sec_i = 3'd4;
                    end
                end

                primary_index     <= max_i;
                primary_score     <= max_s;
                alternative_index <= sec_i;
                alternative_score <= sec_s;
                valid_mask        <= above_thresh;
                done              <= 1'b1;
            end
        end
    end

endmodule

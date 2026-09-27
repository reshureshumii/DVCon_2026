module axi_slave_interface (
    input  wire        clk,
    input  wire        rst_n,

    input  wire [11:0] s_axi_awid,
    input  wire [63:0] s_axi_awaddr,
    input  wire [7:0]  s_axi_awlen,
    input  wire [2:0]  s_axi_awsize,
    input  wire [1:0]  s_axi_awburst,
    input  wire        s_axi_awlock,
    input  wire [3:0]  s_axi_awcache,
    input  wire [2:0]  s_axi_awprot,
    input  wire [3:0]  s_axi_awqos,
    input  wire        s_axi_awvalid,
    output reg         s_axi_awready,

    input  wire [63:0] s_axi_wdata,
    input  wire [7:0]  s_axi_wstrb,
    input  wire        s_axi_wlast,
    input  wire        s_axi_wvalid,
    output reg         s_axi_wready,

    output reg  [11:0] s_axi_bid,
    output reg  [1:0]  s_axi_bresp,
    output reg         s_axi_bvalid,
    input  wire        s_axi_bready,

    input  wire [11:0] s_axi_arid,
    input  wire [63:0] s_axi_araddr,
    input  wire [7:0]  s_axi_arlen,
    input  wire [2:0]  s_axi_arsize,
    input  wire [1:0]  s_axi_arburst,
    input  wire        s_axi_arlock,
    input  wire [3:0]  s_axi_arcache,
    input  wire [2:0]  s_axi_arprot,
    input  wire [3:0]  s_axi_arqos,
    input  wire        s_axi_arvalid,
    output reg         s_axi_arready,

    output reg  [11:0] s_axi_rid,
    output reg  [63:0] s_axi_rdata,
    output reg  [1:0]  s_axi_rresp,
    output reg         s_axi_rlast,
    output reg         s_axi_rvalid,
    input  wire        s_axi_rready,

    output reg  [15:0] confidence_0, output reg [15:0] weight_0,
    output reg  [15:0] confidence_1, output reg [15:0] weight_1,
    output reg  [15:0] confidence_2, output reg [15:0] weight_2,
    output reg  [15:0] confidence_3, output reg [15:0] weight_3,
    output reg  [15:0] confidence_4, output reg [15:0] weight_4,
    output reg         start,

    input  wire [2:0]  primary_index,
    input  wire [31:0] primary_score,
    input  wire [2:0]  alternative_index,
    input  wire [31:0] alternative_score,
    input  wire [4:0]  valid_mask,
    input  wire        ready,
    input  wire        done
);

    reg [63:0] reg_result0;
    reg [63:0] reg_result1;

    reg [11:0] awid_latch;
    reg [63:0] awaddr_latch;
    reg        aw_active;

    reg [11:0] arid_latch;
    reg [63:0] araddr_latch;
    reg        ar_active;

    always @(posedge clk) begin
        if (!rst_n) begin
            reg_result0 <= 64'd0;
            reg_result1 <= 64'd0;
        end else if (done) begin
            reg_result0 <= {primary_score,     {29'd0, primary_index}};
            reg_result1 <= {alternative_score, {29'd0, alternative_index}};
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            s_axi_awready <= 1'b0;
            s_axi_wready  <= 1'b0;
            s_axi_bvalid  <= 1'b0;
            s_axi_bresp   <= 2'b00;
            s_axi_bid     <= 12'd0;
            aw_active     <= 1'b0;
            awid_latch    <= 12'd0;
            awaddr_latch  <= 64'd0;
            confidence_0  <= 16'd0; weight_0 <= 16'd0;
            confidence_1  <= 16'd0; weight_1 <= 16'd0;
            confidence_2  <= 16'd0; weight_2 <= 16'd0;
            confidence_3  <= 16'd0; weight_3 <= 16'd0;
            confidence_4  <= 16'd0; weight_4 <= 16'd0;
            start         <= 1'b0;
        end else begin
            start         <= 1'b0;
            s_axi_awready <= 1'b0;
            s_axi_wready  <= 1'b0;

            if (s_axi_bvalid && s_axi_bready)
                s_axi_bvalid <= 1'b0;

            if (s_axi_awvalid && !aw_active) begin
                s_axi_awready <= 1'b1;
                awid_latch    <= s_axi_awid;
                awaddr_latch  <= s_axi_awaddr;
                aw_active     <= 1'b1;
            end

            if (aw_active && s_axi_wvalid) begin
                s_axi_wready <= 1'b1;
                case (awaddr_latch[7:0])
                    8'h00: begin
                        confidence_0 <= s_axi_wdata[15:0];
                        weight_0     <= s_axi_wdata[31:16];
                    end
                    8'h08: begin
                        confidence_1 <= s_axi_wdata[15:0];
                        weight_1     <= s_axi_wdata[31:16];
                    end
                    8'h10: begin
                        confidence_2 <= s_axi_wdata[15:0];
                        weight_2     <= s_axi_wdata[31:16];
                    end
                    8'h18: begin
                        confidence_3 <= s_axi_wdata[15:0];
                        weight_3     <= s_axi_wdata[31:16];
                    end
                    8'h20: begin
                        confidence_4 <= s_axi_wdata[15:0];
                        weight_4     <= s_axi_wdata[31:16];
                    end
                    8'h28: begin
                        start <= s_axi_wdata[0];
                    end
                    default: ;
                endcase
                s_axi_bid    <= awid_latch;
                s_axi_bresp  <= 2'b00;
                s_axi_bvalid <= 1'b1;
                aw_active    <= 1'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            s_axi_arready <= 1'b0;
            s_axi_rvalid  <= 1'b0;
            s_axi_rdata   <= 64'd0;
            s_axi_rresp   <= 2'b00;
            s_axi_rlast   <= 1'b0;
            s_axi_rid     <= 12'd0;
            ar_active     <= 1'b0;
            arid_latch    <= 12'd0;
            araddr_latch  <= 64'd0;
        end else begin
            s_axi_arready <= 1'b0;

            if (s_axi_rvalid && s_axi_rready) begin
                s_axi_rvalid <= 1'b0;
                s_axi_rlast  <= 1'b0;
                ar_active    <= 1'b0;
            end

            if (s_axi_arvalid && !ar_active) begin
                s_axi_arready <= 1'b1;
                arid_latch    <= s_axi_arid;
                araddr_latch  <= s_axi_araddr;
                ar_active     <= 1'b1;
            end

            if (ar_active && !s_axi_rvalid) begin
                s_axi_rid    <= arid_latch;
                s_axi_rresp  <= 2'b00;
                s_axi_rlast  <= 1'b1;
                s_axi_rvalid <= 1'b1;
                case (araddr_latch[7:0])
                    8'h00: s_axi_rdata <= {32'd0, weight_0, confidence_0};
                    8'h08: s_axi_rdata <= {32'd0, weight_1, confidence_1};
                    8'h10: s_axi_rdata <= {32'd0, weight_2, confidence_2};
                    8'h18: s_axi_rdata <= {32'd0, weight_3, confidence_3};
                    8'h20: s_axi_rdata <= {32'd0, weight_4, confidence_4};
                    8'h28: s_axi_rdata <= {63'd0, start};
                    8'h30: s_axi_rdata <= reg_result0;
                    8'h38: s_axi_rdata <= reg_result1;
                    8'h40: s_axi_rdata <= {59'd0, valid_mask};
                    8'h48: s_axi_rdata <= {63'd0, ready};
                    default: s_axi_rdata <= 64'hDEADBEEFDEADBEEF;
                endcase
            end
        end
    end

endmodule
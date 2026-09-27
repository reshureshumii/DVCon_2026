// NOTE: This accelerator does not use AXI read (AR/R channels).
// Inputs (confidence_N, weight_N) are written directly via the
// AXI4-Slave register interface by the CPU — no memory DMA read
// is performed. AR/R signals are tied off intentionally.

module axi_master_interface (
    input  wire        clk,
    input  wire        rst_n,

    output reg  [11:0] m_axi_awid,
    output reg  [63:0] m_axi_awaddr,
    output reg  [7:0]  m_axi_awlen,
    output reg  [2:0]  m_axi_awsize,
    output reg  [1:0]  m_axi_awburst,
    output reg         m_axi_awlock,
    output reg  [3:0]  m_axi_awcache,
    output reg  [3:0]  m_axi_awqos,
    output reg  [2:0]  m_axi_awprot,
    output reg         m_axi_awvalid,
    input  wire        m_axi_awready,

    output reg         m_axi_wvalid,
    output reg         m_axi_wlast,
    output reg  [63:0] m_axi_wdata,
    output reg  [7:0]  m_axi_wstrb,
    input  wire        m_axi_wready,

    output reg         m_axi_bready,
    input  wire        m_axi_bvalid,
    input  wire [11:0] m_axi_bid,
    input  wire [1:0]  m_axi_bresp,

    output reg  [11:0] m_axi_arid,
    output reg  [7:0]  m_axi_arlen,
    output reg  [2:0]  m_axi_arsize,
    output reg  [1:0]  m_axi_arburst,
    output reg         m_axi_arlock,
    output reg  [3:0]  m_axi_arcache,
    output reg  [3:0]  m_axi_arqos,
    output reg  [2:0]  m_axi_arprot,
    output reg  [63:0] m_axi_araddr,
    output reg         m_axi_arvalid,
    input  wire        m_axi_arready,

    output reg         m_axi_rready,
    input  wire        m_axi_rvalid,
    input  wire [11:0] m_axi_rid,
    input  wire        m_axi_rlast,
    input  wire [1:0]  m_axi_rresp,
    input  wire [63:0] m_axi_rdata,

    input  wire [31:0] score_1,
    input  wire [31:0] score_2,
    input  wire [2:0]  winner,
    input  wire        tie_flag,
    input  wire        done,

    input  wire [63:0] result_base_addr,

    output reg         write_done
);

    localparam IDLE      = 3'd0;
    localparam WR_ADDR_1 = 3'd1;
    localparam WR_DATA_1 = 3'd2;
    localparam WR_RESP_1 = 3'd3;
    localparam WR_ADDR_2 = 3'd4;
    localparam WR_DATA_2 = 3'd5;
    localparam WR_RESP_2 = 3'd6;
    localparam DONE      = 3'd7;

    reg [2:0] state;

    always @(posedge clk) begin
        if (!rst_n) begin
            state         <= IDLE;
            write_done    <= 1'b0;

            m_axi_awid    <= 12'd0;
            m_axi_awaddr  <= 64'd0;
            m_axi_awlen   <= 8'd0;
            m_axi_awsize  <= 3'b011;
            m_axi_awburst <= 2'b01;
            m_axi_awlock  <= 1'b0;
            m_axi_awcache <= 4'b0010;
            m_axi_awqos   <= 4'd0;
            m_axi_awprot  <= 3'd0;
            m_axi_awvalid <= 1'b0;

            m_axi_wdata   <= 64'd0;
            m_axi_wstrb   <= 8'hFF;
            m_axi_wlast   <= 1'b0;
            m_axi_wvalid  <= 1'b0;

            m_axi_bready  <= 1'b0;

            m_axi_rready  <= 1'b0;
            m_axi_araddr  <= 64'd0;
            m_axi_arid    <= 12'd0;
            m_axi_arlen   <= 8'd0;
            m_axi_arsize  <= 3'b011;
            m_axi_arburst <= 2'b01;
            m_axi_arlock  <= 1'b0;
            m_axi_arcache <= 4'b0010;
            m_axi_arqos   <= 4'd0;
            m_axi_arprot  <= 3'd0;
            m_axi_arvalid <= 1'b0;

        end else begin
            write_done <= 1'b0;

            case (state)


                IDLE: begin
                    if (done)
                        state <= WR_ADDR_1;
                end
               

                WR_ADDR_1: begin
                    m_axi_awid    <= 12'd1;
                    m_axi_awaddr  <= result_base_addr;
                    m_axi_awlen   <= 8'd0;
                    m_axi_awsize  <= 3'b011;
                    m_axi_awburst <= 2'b01;
                    m_axi_awvalid <= 1'b1;
                    if (m_axi_awvalid && m_axi_awready) begin
                        m_axi_awvalid <= 1'b0;
                        state         <= WR_DATA_1;
                    end
                end

                WR_DATA_1: begin
                    m_axi_wdata  <= {score_2, score_1};
                    m_axi_wstrb  <= 8'hFF;
                    m_axi_wlast  <= 1'b1;
                    m_axi_wvalid <= 1'b1;
                    if (m_axi_wvalid && m_axi_wready) begin
                        m_axi_wvalid <= 1'b0;
                        m_axi_wlast  <= 1'b0;
                        state        <= WR_RESP_1;
                    end
                end

                WR_RESP_1: begin
                    m_axi_bready <= 1'b1;
                    if (m_axi_bready && m_axi_bvalid) begin
                        m_axi_bready <= 1'b0;
                        state        <= WR_ADDR_2;
                    end
                end

                WR_ADDR_2: begin
                    m_axi_awid    <= 12'd2;
                    m_axi_awaddr  <= result_base_addr + 64'h8;
                    m_axi_awlen   <= 8'd0;
                    m_axi_awsize  <= 3'b011;
                    m_axi_awburst <= 2'b01;
                    m_axi_awvalid <= 1'b1;
                    if (m_axi_awvalid && m_axi_awready) begin
                        m_axi_awvalid <= 1'b0;
                        state         <= WR_DATA_2;
                    end
                end

                WR_DATA_2: begin
                    m_axi_wdata  <= {59'd0, tie_flag, winner, done};
                    m_axi_wstrb  <= 8'hFF;
                    m_axi_wlast  <= 1'b1;
                    m_axi_wvalid <= 1'b1;
                    if (m_axi_wvalid && m_axi_wready) begin
                        m_axi_wvalid <= 1'b0;
                        m_axi_wlast  <= 1'b0;
                        state        <= WR_RESP_2;
                    end
                end

                WR_RESP_2: begin
                    m_axi_bready <= 1'b1;
                    if (m_axi_bready && m_axi_bvalid) begin
                        m_axi_bready <= 1'b0;
                        state        <= DONE;
                    end
                end

                DONE: begin
                    write_done <= 1'b1;
                    state      <= IDLE;
                end

                default: state <= IDLE;

            endcase
        end
    end

endmodule

`timescale 1ns / 1ps

module Accelerator_Top  (
    input wire s_axi_aclk,
    input wire s_axi_aresetn,

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
    output wire        s_axi_awready,

    input  wire [63:0] s_axi_wdata,
    input  wire [7:0]  s_axi_wstrb,
    input  wire        s_axi_wlast,
    input  wire        s_axi_wvalid,
    output wire        s_axi_wready,

    output wire [11:0] s_axi_bid,
    output wire [1:0]  s_axi_bresp,
    output wire        s_axi_bvalid,
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
    output wire        s_axi_arready,

    output wire [11:0] s_axi_rid,
    output wire [63:0] s_axi_rdata,
    output wire [1:0]  s_axi_rresp,
    output wire        s_axi_rlast,
    output wire        s_axi_rvalid,
    input  wire        s_axi_rready,

    output wire [11:0] m_axi_awid,
    output wire [63:0] m_axi_awaddr,
    output wire [7:0]  m_axi_awlen,
    output wire [2:0]  m_axi_awsize,
    output wire [1:0]  m_axi_awburst,
    output wire        m_axi_awlock,
    output wire [3:0]  m_axi_awcache,
    output wire [3:0]  m_axi_awqos,
    output wire [2:0]  m_axi_awprot,
    output wire        m_axi_awvalid,
    input  wire        m_axi_awready,

    output wire        m_axi_wvalid,
    output wire        m_axi_wlast,
    output wire [63:0] m_axi_wdata,
    output wire [7:0]  m_axi_wstrb,
    input  wire        m_axi_wready,

    output wire        m_axi_bready,
    input  wire        m_axi_bvalid,
    input  wire [11:0] m_axi_bid,
    input  wire [1:0]  m_axi_bresp,

    output wire [11:0] m_axi_arid,
    output wire [7:0]  m_axi_arlen,
    output wire [2:0]  m_axi_arsize,
    output wire [1:0]  m_axi_arburst,
    output wire        m_axi_arlock,
    output wire [3:0]  m_axi_arcache,
    output wire [3:0]  m_axi_arqos,
    output wire [2:0]  m_axi_arprot,
    output wire [63:0] m_axi_araddr,
    output wire        m_axi_arvalid,
    input  wire        m_axi_arready,

    output wire        m_axi_rready,
    input  wire        m_axi_rvalid,
    input  wire [11:0] m_axi_rid,
    input  wire        m_axi_rlast,
    input  wire [1:0]  m_axi_rresp,
    input  wire [63:0] m_axi_rdata

);
    wire clk   = s_axi_aclk;
    wire rst_n = s_axi_aresetn;
    wire write_done;

    wire [15:0] confidence_0, weight_0;
    wire [15:0] confidence_1, weight_1;
    wire [15:0] confidence_2, weight_2;
    wire [15:0] confidence_3, weight_3;
    wire [15:0] confidence_4, weight_4;
    wire        start;

    wire [2:0]  primary_index;
    wire [31:0] primary_score;
    wire [2:0]  alternative_index;
    wire [31:0] alternative_score;
    wire [4:0]  valid_mask;
    wire        ready;
    wire        done;

    wire [63:0] result_base_addr;

    top2_comparator u_top2 (
        .clk               (clk),
        .rst_n             (rst_n),
        .start             (start),
        .confidence_0      (confidence_0), .weight_0 (weight_0),
        .confidence_1      (confidence_1), .weight_1 (weight_1),
        .confidence_2      (confidence_2), .weight_2 (weight_2),
        .confidence_3      (confidence_3), .weight_3 (weight_3),
        .confidence_4      (confidence_4), .weight_4 (weight_4),
        .primary_index     (primary_index),
        .primary_score     (primary_score),
        .alternative_index (alternative_index),
        .alternative_score (alternative_score),
        .valid_mask        (valid_mask),
        .done              (done),
        .ready             (ready)
    );

    axi_slave_interface u_axi_slave (
        .clk               (clk),
        .rst_n             (rst_n),
        .s_axi_awid        (s_axi_awid),
        .s_axi_awaddr      (s_axi_awaddr),
        .s_axi_awlen       (s_axi_awlen),
        .s_axi_awsize      (s_axi_awsize),
        .s_axi_awburst     (s_axi_awburst),
        .s_axi_awlock      (s_axi_awlock),
        .s_axi_awcache     (s_axi_awcache),
        .s_axi_awprot      (s_axi_awprot),
        .s_axi_awqos       (s_axi_awqos),
        .s_axi_awvalid     (s_axi_awvalid),
        .s_axi_awready     (s_axi_awready),
        .s_axi_wdata       (s_axi_wdata),
        .s_axi_wstrb       (s_axi_wstrb),
        .s_axi_wlast       (s_axi_wlast),
        .s_axi_wvalid      (s_axi_wvalid),
        .s_axi_wready      (s_axi_wready),
        .s_axi_bid         (s_axi_bid),
        .s_axi_bresp       (s_axi_bresp),
        .s_axi_bvalid      (s_axi_bvalid),
        .s_axi_bready      (s_axi_bready),
        .s_axi_arid        (s_axi_arid),
        .s_axi_araddr      (s_axi_araddr),
        .s_axi_arlen       (s_axi_arlen),
        .s_axi_arsize      (s_axi_arsize),
        .s_axi_arburst     (s_axi_arburst),
        .s_axi_arlock      (s_axi_arlock),
        .s_axi_arcache     (s_axi_arcache),
        .s_axi_arprot      (s_axi_arprot),
        .s_axi_arqos       (s_axi_arqos),
        .s_axi_arvalid     (s_axi_arvalid),
        .s_axi_arready     (s_axi_arready),
        .s_axi_rid         (s_axi_rid),
        .s_axi_rdata       (s_axi_rdata),
        .s_axi_rresp       (s_axi_rresp),
        .s_axi_rlast       (s_axi_rlast),
        .s_axi_rvalid      (s_axi_rvalid),
        .s_axi_rready      (s_axi_rready),
        .confidence_0      (confidence_0), .weight_0 (weight_0),
        .confidence_1      (confidence_1), .weight_1 (weight_1),
        .confidence_2      (confidence_2), .weight_2 (weight_2),
        .confidence_3      (confidence_3), .weight_3 (weight_3),
        .confidence_4      (confidence_4), .weight_4 (weight_4),
        .start             (start),
        .result_base_addr (result_base_addr),
        .primary_index     (primary_index),
        .primary_score     (primary_score),
        .alternative_index (alternative_index),
        .alternative_score (alternative_score),
        .valid_mask        (valid_mask),
        .ready             (ready),
        .done              (done),
        .write_done        (write_done)
    );

    axi_master_interface u_axi_master (
        .clk              (clk),
        .rst_n            (rst_n),
        .m_axi_awid       (m_axi_awid),
        .m_axi_awaddr     (m_axi_awaddr),
        .m_axi_awlen      (m_axi_awlen),
        .m_axi_awsize     (m_axi_awsize),
        .m_axi_awburst    (m_axi_awburst),
        .m_axi_awlock     (m_axi_awlock),
        .m_axi_awcache    (m_axi_awcache),
        .m_axi_awqos      (m_axi_awqos),
        .m_axi_awprot     (m_axi_awprot),
        .m_axi_awvalid    (m_axi_awvalid),
        .m_axi_awready    (m_axi_awready),
        .m_axi_wvalid     (m_axi_wvalid),
        .m_axi_wlast      (m_axi_wlast),
        .m_axi_wdata      (m_axi_wdata),
        .m_axi_wstrb      (m_axi_wstrb),
        .m_axi_wready     (m_axi_wready),
        .m_axi_bready     (m_axi_bready),
        .m_axi_bvalid     (m_axi_bvalid),
        .m_axi_bid        (m_axi_bid),
        .m_axi_bresp      (m_axi_bresp),
        .m_axi_arid       (m_axi_arid),
        .m_axi_arlen      (m_axi_arlen),
        .m_axi_arsize     (m_axi_arsize),
        .m_axi_arburst    (m_axi_arburst),
        .m_axi_arlock     (m_axi_arlock),
        .m_axi_arcache    (m_axi_arcache),
        .m_axi_arqos      (m_axi_arqos),
        .m_axi_arprot     (m_axi_arprot),
        .m_axi_araddr     (m_axi_araddr),
        .m_axi_arvalid    (m_axi_arvalid),
        .m_axi_arready    (m_axi_arready),
        .m_axi_rready     (m_axi_rready),
        .m_axi_rvalid     (m_axi_rvalid),
        .m_axi_rid        (m_axi_rid),
        .m_axi_rlast      (m_axi_rlast),
        .m_axi_rresp      (m_axi_rresp),
        .m_axi_rdata      (m_axi_rdata),
        .score_1          (primary_score),
        .score_2          (alternative_score),
        .winner           (primary_index),
        .tie_flag         (1'b0),
        .done             (done),
        .result_base_addr (result_base_addr),
        .write_done       (write_done)
    );

endmodule

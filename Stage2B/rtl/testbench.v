`timescale 1ns / 1ps

module testbench;

    reg clk;
    reg rst_n;

    always #10 clk = ~clk;

    reg  [11:0] s_axi_awid;
    reg  [63:0] s_axi_awaddr;
    reg  [7:0]  s_axi_awlen;
    reg  [2:0]  s_axi_awsize;
    reg  [1:0]  s_axi_awburst;
    reg         s_axi_awlock;
    reg  [3:0]  s_axi_awcache;
    reg  [2:0]  s_axi_awprot;
    reg  [3:0]  s_axi_awqos;
    reg         s_axi_awvalid;
    wire        s_axi_awready;

    reg  [63:0] s_axi_wdata;
    reg  [7:0]  s_axi_wstrb;
    reg         s_axi_wlast;
    reg         s_axi_wvalid;
    wire        s_axi_wready;

    wire [11:0] s_axi_bid;
    wire [1:0]  s_axi_bresp;
    wire        s_axi_bvalid;
    reg         s_axi_bready;

    reg  [11:0] s_axi_arid;
    reg  [63:0] s_axi_araddr;
    reg  [7:0]  s_axi_arlen;
    reg  [2:0]  s_axi_arsize;
    reg  [1:0]  s_axi_arburst;
    reg         s_axi_arlock;
    reg  [3:0]  s_axi_arcache;
    reg  [2:0]  s_axi_arprot;
    reg  [3:0]  s_axi_arqos;
    reg         s_axi_arvalid;
    wire        s_axi_arready;

    wire [11:0] s_axi_rid;
    wire [63:0] s_axi_rdata;
    wire [1:0]  s_axi_rresp;
    wire        s_axi_rlast;
    wire        s_axi_rvalid;
    reg         s_axi_rready;

    wire [11:0] m_axi_awid;
    wire [63:0] m_axi_awaddr;
    wire [7:0]  m_axi_awlen;
    wire [2:0]  m_axi_awsize;
    wire [1:0]  m_axi_awburst;
    wire        m_axi_awlock;
    wire [3:0]  m_axi_awcache;
    wire [3:0]  m_axi_awqos;
    wire [2:0]  m_axi_awprot;
    wire        m_axi_awvalid;
    wire        m_axi_awready;

    wire        m_axi_wvalid;
    wire        m_axi_wlast;
    wire [63:0] m_axi_wdata;
    wire [7:0]  m_axi_wstrb;
    wire        m_axi_wready;

    wire        m_axi_bready;
    wire        m_axi_bvalid;
    wire [11:0] m_axi_bid;
    wire [1:0]  m_axi_bresp;

    wire [11:0] m_axi_arid;
    wire [7:0]  m_axi_arlen;
    wire [2:0]  m_axi_arsize;
    wire [1:0]  m_axi_arburst;
    wire        m_axi_arlock;
    wire [3:0]  m_axi_arcache;
    wire [3:0]  m_axi_arqos;
    wire [2:0]  m_axi_arprot;
    wire [63:0] m_axi_araddr;
    wire        m_axi_arvalid;
    wire        m_axi_arready;

    wire        m_axi_rready;
    wire        m_axi_rvalid;
    wire [11:0] m_axi_rid;
    wire        m_axi_rlast;
    wire [1:0]  m_axi_rresp;
    wire [63:0] m_axi_rdata;

    wire        write_done;

    top_module u_dut (
        .clk             (clk),
        .rst_n           (rst_n),
        .s_axi_awid      (s_axi_awid),
        .s_axi_awaddr    (s_axi_awaddr),
        .s_axi_awlen     (s_axi_awlen),
        .s_axi_awsize    (s_axi_awsize),
        .s_axi_awburst   (s_axi_awburst),
        .s_axi_awlock    (s_axi_awlock),
        .s_axi_awcache   (s_axi_awcache),
        .s_axi_awprot    (s_axi_awprot),
        .s_axi_awqos     (s_axi_awqos),
        .s_axi_awvalid   (s_axi_awvalid),
        .s_axi_awready   (s_axi_awready),
        .s_axi_wdata     (s_axi_wdata),
        .s_axi_wstrb     (s_axi_wstrb),
        .s_axi_wlast     (s_axi_wlast),
        .s_axi_wvalid    (s_axi_wvalid),
        .s_axi_wready    (s_axi_wready),
        .s_axi_bid       (s_axi_bid),
        .s_axi_bresp     (s_axi_bresp),
        .s_axi_bvalid    (s_axi_bvalid),
        .s_axi_bready    (s_axi_bready),
        .s_axi_arid      (s_axi_arid),
        .s_axi_araddr    (s_axi_araddr),
        .s_axi_arlen     (s_axi_arlen),
        .s_axi_arsize    (s_axi_arsize),
        .s_axi_arburst   (s_axi_arburst),
        .s_axi_arlock    (s_axi_arlock),
        .s_axi_arcache   (s_axi_arcache),
        .s_axi_arprot    (s_axi_arprot),
        .s_axi_arqos     (s_axi_arqos),
        .s_axi_arvalid   (s_axi_arvalid),
        .s_axi_arready   (s_axi_arready),
        .s_axi_rid       (s_axi_rid),
        .s_axi_rdata     (s_axi_rdata),
        .s_axi_rresp     (s_axi_rresp),
        .s_axi_rlast     (s_axi_rlast),
        .s_axi_rvalid    (s_axi_rvalid),
        .s_axi_rready    (s_axi_rready),
        .m_axi_awid      (m_axi_awid),
        .m_axi_awaddr    (m_axi_awaddr),
        .m_axi_awlen     (m_axi_awlen),
        .m_axi_awsize    (m_axi_awsize),
        .m_axi_awburst   (m_axi_awburst),
        .m_axi_awlock    (m_axi_awlock),
        .m_axi_awcache   (m_axi_awcache),
        .m_axi_awqos     (m_axi_awqos),
        .m_axi_awprot    (m_axi_awprot),
        .m_axi_awvalid   (m_axi_awvalid),
        .m_axi_awready   (m_axi_awready),
        .m_axi_wvalid    (m_axi_wvalid),
        .m_axi_wlast     (m_axi_wlast),
        .m_axi_wdata     (m_axi_wdata),
        .m_axi_wstrb     (m_axi_wstrb),
        .m_axi_wready    (m_axi_wready),
        .m_axi_bready    (m_axi_bready),
        .m_axi_bvalid    (m_axi_bvalid),
        .m_axi_bid       (m_axi_bid),
        .m_axi_bresp     (m_axi_bresp),
        .m_axi_arid      (m_axi_arid),
        .m_axi_arlen     (m_axi_arlen),
        .m_axi_arsize    (m_axi_arsize),
        .m_axi_arburst   (m_axi_arburst),
        .m_axi_arlock    (m_axi_arlock),
        .m_axi_arcache   (m_axi_arcache),
        .m_axi_arqos     (m_axi_arqos),
        .m_axi_arprot    (m_axi_arprot),
        .m_axi_araddr    (m_axi_araddr),
        .m_axi_arvalid   (m_axi_arvalid),
        .m_axi_arready   (m_axi_arready),
        .m_axi_rready    (m_axi_rready),
        .m_axi_rvalid    (m_axi_rvalid),
        .m_axi_rid       (m_axi_rid),
        .m_axi_rlast     (m_axi_rlast),
        .m_axi_rresp     (m_axi_rresp),
        .m_axi_rdata     (m_axi_rdata),
        .write_done      (write_done)
    );

    memory_model u_mem (
        .clk     (clk),           .rst_n   (rst_n),
        .awid    (m_axi_awid),    .awaddr  (m_axi_awaddr),
        .awlen   (m_axi_awlen),   .awsize  (m_axi_awsize),
        .awburst (m_axi_awburst), .awvalid (m_axi_awvalid),
        .awready (m_axi_awready), .wdata   (m_axi_wdata),
        .wstrb   (m_axi_wstrb),   .wlast   (m_axi_wlast),
        .wvalid  (m_axi_wvalid),  .wready  (m_axi_wready),
        .bid     (m_axi_bid),     .bresp   (m_axi_bresp),
        .bvalid  (m_axi_bvalid),  .bready  (m_axi_bready),
        .arid    (m_axi_arid),    .araddr  (m_axi_araddr),
        .arlen   (m_axi_arlen),   .arsize  (m_axi_arsize),
        .arburst (m_axi_arburst), .arvalid (m_axi_arvalid),
        .arready (m_axi_arready), .rid     (m_axi_rid),
        .rdata   (m_axi_rdata),   .rresp   (m_axi_rresp),
        .rlast   (m_axi_rlast),   .rvalid  (m_axi_rvalid),
        .rready  (m_axi_rready)
    );

    integer pass_count = 0;
    integer fail_count = 0;
    reg [63:0] result0_word, result1_word, flags_word;
    reg [63:0] t_start, t_done, latency_ns;

    // =====================================================
    // AXI write task
    // =====================================================
    task axi_write(input [63:0] addr, input [63:0] data);
        begin
            @(posedge clk);
            s_axi_awaddr  <= addr;  s_axi_awid    <= 12'd1;
            s_axi_awlen   <= 8'd0;  s_axi_awsize  <= 3'b011;
            s_axi_awburst <= 2'b01; s_axi_awvalid <= 1'b1;
            s_axi_wdata   <= data;  s_axi_wstrb   <= 8'hFF;
            s_axi_wlast   <= 1'b1;  s_axi_wvalid  <= 1'b1;
            s_axi_bready  <= 1'b1;
            @(posedge clk);
            while (!s_axi_awready) @(posedge clk);
            s_axi_awvalid <= 1'b0;
            while (!s_axi_wready)  @(posedge clk);
            s_axi_wvalid  <= 1'b0; s_axi_wlast <= 1'b0;
            while (!s_axi_bvalid)  @(posedge clk);
            @(posedge clk);
            s_axi_bready  <= 1'b0;
        end
    endtask

    // =====================================================
    // AXI read task
    // =====================================================
    task axi_read(input [63:0] addr, output [63:0] data);
        begin
            @(posedge clk);
            s_axi_araddr  <= addr;  s_axi_arid    <= 12'd1;
            s_axi_arlen   <= 8'd0;  s_axi_arsize  <= 3'b011;
            s_axi_arburst <= 2'b01; s_axi_arvalid <= 1'b1;
            s_axi_rready  <= 1'b1;
            @(posedge clk);
            while (!s_axi_arready) @(posedge clk);
            s_axi_arvalid <= 1'b0;
            while (!s_axi_rvalid)  @(posedge clk);
            data = s_axi_rdata;
            @(posedge clk);
            s_axi_rready  <= 1'b0;
        end
    endtask

    // =====================================================
    // Core run task — takes object names as inputs
    // =====================================================
    task run_5obj_test;
        input [239:0] test_name;
        input [15:0]  c0; input [15:0] w0; input [127:0] name0;
        input [15:0]  c1; input [15:0] w1; input [127:0] name1;
        input [15:0]  c2; input [15:0] w2; input [127:0] name2;
        input [15:0]  c3; input [15:0] w3; input [127:0] name3;
        input [15:0]  c4; input [15:0] w4; input [127:0] name4;
        input [2:0]   exp_pri_idx;
        input [31:0]  exp_pri_score;
        input [2:0]   exp_alt_idx;
        input [31:0]  exp_alt_score;
        input [4:0]   exp_valid_mask;

        reg [127:0] names [0:4];
        reg [2:0]   pri_idx, alt_idx;
        reg [31:0]  pri_score, alt_score;

        begin
            names[0] = name0;
            names[1] = name1;
            names[2] = name2;
            names[3] = name3;
            names[4] = name4;

           $display("==================================================");
$display("TEST: %0s", test_name);
$display("  Objects loaded:");

$display("    [0] %0s  conf=%0d  weight=%0d",
         names[0], c0, w0);

$display("    [1] %0s  conf=%0d  weight=%0d",
         names[1], c1, w1);

$display("    [2] %0s  conf=%0d  weight=%0d",
         names[2], c2, w2);

$display("    [3] %0s  conf=%0d  weight=%0d",
         names[3], c3, w3);

$display("    [4] %0s  conf=%0d  weight=%0d",
         names[4], c4, w4);
            axi_write(64'h00, {32'd0, w0, c0});
            axi_write(64'h08, {32'd0, w1, c1});
            axi_write(64'h10, {32'd0, w2, c2});
            axi_write(64'h18, {32'd0, w3, c3});
            axi_write(64'h20, {32'd0, w4, c4});

            t_start = $time;
            axi_write(64'h28, 64'h1);

            repeat(60) @(posedge clk);

            t_done     = $time;
            latency_ns = t_done - t_start;

            axi_read(64'h30, result0_word);
            axi_read(64'h38, result1_word);
            axi_read(64'h40, flags_word);

            pri_idx   = result0_word[2:0];
            pri_score = result0_word[63:32];
            alt_idx   = result1_word[2:0];
            alt_score = result1_word[63:32];

            $display("  Hardware latency  : %0d ns", latency_ns);
            $display("  Valid mask        : %05b  (1=above threshold 80000)",
                     flags_word[4:0]);

            if (exp_pri_score == 32'd0) begin
                // Fallback case — no valid objects
                $display("  Primary    : NONE (all objects filtered out)");
                $display("  Alternative: NONE (all objects filtered out)");
            end else begin
                $display("  Primary    : [%0d] %0s  score=%0d",
                         pri_idx, names[pri_idx], pri_score);
                $display("  Alternative: [%0d] %0s  score=%0d",
                         alt_idx, names[alt_idx], alt_score);
            end

            if (result0_word[2:0]   == exp_pri_idx   &&
                result0_word[63:32] == exp_pri_score  &&
                result1_word[2:0]   == exp_alt_idx    &&
                result1_word[63:32] == exp_alt_score  &&
                flags_word[4:0]     == exp_valid_mask) begin
                $display("  RESULT: PASS");
                pass_count = pass_count + 1;
            end else begin
                $display("  RESULT: FAIL");
                $display("  Expected pri: [%0d] score=%0d",
                         exp_pri_idx, exp_pri_score);
                $display("  Expected alt: [%0d] score=%0d",
                         exp_alt_idx, exp_alt_score);
                $display("  Expected mask: %05b", exp_valid_mask);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // =====================================================
    // Main stimulus
    // =====================================================
    initial begin
        clk=0; rst_n=0;
        s_axi_awid=0; s_axi_awaddr=0; s_axi_awlen=0; s_axi_awsize=0;
        s_axi_awburst=0; s_axi_awlock=0; s_axi_awcache=0; s_axi_awprot=0;
        s_axi_awqos=0; s_axi_awvalid=0;
        s_axi_wdata=0; s_axi_wstrb=0; s_axi_wlast=0; s_axi_wvalid=0;
        s_axi_bready=0;
        s_axi_arid=0; s_axi_araddr=0; s_axi_arlen=0; s_axi_arsize=0;
        s_axi_arburst=0; s_axi_arlock=0; s_axi_arcache=0; s_axi_arprot=0;
        s_axi_arqos=0; s_axi_arvalid=0; s_axi_rready=0;

        repeat(5) @(posedge clk); rst_n=1;
        repeat(5) @(posedge clk);

        // -----------------------------------------------
        // TEST 1 — Task: Water Plant
        // -----------------------------------------------
        run_5obj_test("Task_Water_Plant",
            16'd811, 16'd900, "Potted_Plant",
            16'd584, 16'd400, "Vase        ",
            16'd850, 16'd200, "Laptop      ",
            16'd800, 16'd200, "Cell_Phone  ",
            16'd750, 16'd200, "Keyboard    ",
            3'd0, 32'd729900,
            3'd1, 32'd233600,
            5'b11111);

        repeat(10) @(posedge clk);

        // -----------------------------------------------
        // TEST 2 — Task: Step On Something
        // -----------------------------------------------
        run_5obj_test("Task_Step_On_Something",
            16'd735, 16'd700, "Chair_1     ",
            16'd677, 16'd700, "Chair_2     ",
            16'd900, 16'd200, "Laptop      ",
            16'd850, 16'd200, "Person      ",
            16'd800, 16'd200, "Dining_Table",
            3'd0, 32'd514500,
            3'd1, 32'd473900,
            5'b11111);

        repeat(10) @(posedge clk);

        // -----------------------------------------------
        // TEST 3 — Task: Dig A Hole
        // -----------------------------------------------
        run_5obj_test("Task_Dig_A_Hole",
            16'd900, 16'd700, "Spoon       ",
            16'd850, 16'd500, "Knife       ",
            16'd100, 16'd200, "Cup_FILTERED",
            16'd200, 16'd200, "Bowl_FILTERD",
            16'd900, 16'd500, "Fork        ",
            3'd0, 32'd630000,
            3'd4, 32'd450000,
            5'b10011);

        repeat(10) @(posedge clk);

        // -----------------------------------------------
        // TEST 4 — Task: Sit Comfortably
        // -----------------------------------------------
        run_5obj_test("Task_Sit_Comfortably",
            16'd600, 16'd900, "Chair       ",
            16'd850, 16'd700, "Couch       ",
            16'd780, 16'd500, "Bench       ",
            16'd700, 16'd400, "Dining_Table",
            16'd100, 16'd200, "Other_FILTRD",
            3'd1, 32'd595000,
            3'd0, 32'd540000,
            5'b01111);

        repeat(10) @(posedge clk);

        // -----------------------------------------------
        // TEST 5 — Task: Extinguish Fire (all filtered)
        // -----------------------------------------------
        run_5obj_test("Task_Extinguish_Fire",
            16'd300, 16'd200, "Chair_FILTRD",
            16'd350, 16'd200, "Cup_FILTERED",
            16'd250, 16'd200, "Bowl_FILTERD",
            16'd380, 16'd200, "Bottle_FLTRD",
            16'd200, 16'd200, "Vase_FILTERD",
            3'd0, 32'd0,
            3'd0, 32'd0,
            5'b00000);

        repeat(10) @(posedge clk);

        $display("==================================================");
        $display("TOTAL: %0d PASS, %0d FAIL", pass_count, fail_count);
        if (fail_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("SOME TESTS FAILED — CHECK ABOVE");
        $display("==================================================");
        $finish;
    end

endmodule
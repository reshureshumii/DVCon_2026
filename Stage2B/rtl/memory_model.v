`timescale 1ns / 1ps

module memory_model (
    input  wire        clk,
    input  wire        rst_n,

    input  wire [11:0] awid,
    input  wire [63:0] awaddr,
    input  wire [7:0]  awlen,
    input  wire [2:0]  awsize,
    input  wire [1:0]  awburst,
    input  wire        awvalid,
    output reg         awready,

    input  wire [63:0] wdata,
    input  wire [7:0]  wstrb,
    input  wire        wlast,
    input  wire        wvalid,
    output reg         wready,

    output reg  [11:0] bid,
    output reg  [1:0]  bresp,
    output reg         bvalid,
    input  wire        bready,

    input  wire [11:0] arid,
    input  wire [63:0] araddr,
    input  wire [7:0]  arlen,
    input  wire [2:0]  arsize,
    input  wire [1:0]  arburst,
    input  wire        arvalid,
    output reg         arready,

    output reg  [11:0] rid,
    output reg  [63:0] rdata,
    output reg  [1:0]  rresp,
    output reg         rlast,
    output reg         rvalid,
    input  wire        rready
);

    reg [63:0] mem [0:511];

    reg [63:0] awaddr_latch;
    reg        aw_active;

    always @(posedge clk) begin
        if (!rst_n) begin
            awready      <= 1'b0;
            aw_active    <= 1'b0;
            awaddr_latch <= 64'd0;
        end else begin
            awready <= 1'b0;
            if (awvalid && !aw_active) begin
                awready      <= 1'b1;
                awaddr_latch <= awaddr;
                aw_active    <= 1'b1;
            end
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            wready <= 1'b0;
            bvalid <= 1'b0;
            bresp  <= 2'b00;
            bid    <= 12'd0;
        end else begin
            wready <= 1'b0;
            bvalid <= 1'b0;

            if (aw_active && wvalid) begin
                wready <= 1'b1;
                mem[awaddr_latch[11:3]] <= wdata;

                bid       <= 12'd0;
                bresp     <= 2'b00;
                bvalid    <= 1'b1;
                aw_active <= 1'b0;
            end
        end
    end

    reg [63:0] araddr_latch;
    reg        ar_active;

    always @(posedge clk) begin
        if (!rst_n) begin
            arready      <= 1'b0;
            ar_active    <= 1'b0;
            araddr_latch <= 64'd0;
        end else begin
            arready <= 1'b0;
            if (arvalid && !ar_active) begin
                arready      <= 1'b1;
                araddr_latch <= araddr;
                ar_active    <= 1'b1;
            end
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            rvalid <= 1'b0;
            rdata  <= 64'd0;
            rresp  <= 2'b00;
            rlast  <= 1'b0;
            rid    <= 12'd0;
        end else begin
            rvalid <= 1'b0;
            rlast  <= 1'b0;

            if (ar_active) begin
                rid    <= 12'd0;
                rdata  <= mem[araddr_latch[11:3]];
                rresp  <= 2'b00;
                rlast  <= 1'b1;
                rvalid <= 1'b1;
                if (rready)
                    ar_active <= 1'b0;
            end
        end
    end

endmodule
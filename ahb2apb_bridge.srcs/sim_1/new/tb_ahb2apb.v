`timescale 1ns/1ps
module tb_ahb2apb;

    reg         HCLK, HRESETn, HSEL, HWRITE, HREADY;
    reg  [1:0]  HTRANS;
    reg  [31:0] HADDR, HWDATA, PRDATA;
    reg         PREADY;
    wire        HREADYOUT;
    wire [31:0] HRDATA, PADDR, PWDATA;
    wire        PSEL, PENABLE, PWRITE, PRESETn;

    ahb2apb_bridge dut (
        .HCLK(HCLK),          .HRESETn(HRESETn),
        .HSEL(HSEL),           .HWRITE(HWRITE),
        .HREADY(HREADY),       .HTRANS(HTRANS),
        .HADDR(HADDR),         .HWDATA(HWDATA),
        .HREADYOUT(HREADYOUT), .HRDATA(HRDATA),
        .PSEL(PSEL),           .PENABLE(PENABLE),
        .PWRITE(PWRITE),       .PRESETn(PRESETn),
        .PADDR(PADDR),         .PWDATA(PWDATA),
        .PRDATA(PRDATA),       .PREADY(PREADY)
    );

    // Clock
    initial HCLK = 0;
    always #5 HCLK = ~HCLK;

    // Write Task
    task ahb_write;
        input [31:0] addr;
        input [31:0] data;
        begin
            @(posedge HCLK);
            HSEL=1; HWRITE=1; HREADY=1;
            HTRANS=2'b10; HADDR=addr; HWDATA=data;
            @(posedge HCLK);
            HSEL=0; HTRANS=2'b00;
            PREADY=1;
            #20;
            PREADY=0;
            $display("WRITE: ADDR=%h DATA=%h PADDR=%h PWDATA=%h",
                      addr, data, PADDR, PWDATA);
        end
    endtask

    // Read Task
    task ahb_read;
        input [31:0] addr;
        input [31:0] rdata;
        begin
            @(posedge HCLK);
            HSEL=1; HWRITE=0; HREADY=1;
            HTRANS=2'b10; HADDR=addr; PRDATA=rdata;
            @(posedge HCLK);
            HSEL=0; HTRANS=2'b00;
            PREADY=1;
            #20;
            PREADY=0;
            $display("READ: ADDR=%h HRDATA=%h",
                      addr, HRDATA);
        end
    endtask

    // Main Test
    initial begin
        $dumpfile("ahb2apb.vcd");
        $dumpvars(0, tb_ahb2apb);

        // Reset
        HRESETn=0; HSEL=0; HWRITE=0;
        HREADY=1; HTRANS=0; HADDR=0;
        HWDATA=0; PRDATA=0; PREADY=0;
        repeat(4) @(posedge HCLK);
        HRESETn=1;
        repeat(2) @(posedge HCLK);

        // Test 1: Write
        ahb_write(32'h4000_0000, 32'hDEAD_BEEF);
        repeat(2) @(posedge HCLK);

        // Test 2: Write
        ahb_write(32'h4000_0004, 32'hCAFE_BABE);
        repeat(2) @(posedge HCLK);

        // Test 3: Read
        ahb_read(32'h4000_0000, 32'h1234_5678);
        repeat(2) @(posedge HCLK);

        repeat(5) @(posedge HCLK);
        $display("=== Simulation Done ===");
        $finish;
    end

endmodule
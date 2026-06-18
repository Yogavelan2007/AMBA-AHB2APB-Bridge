module ahb2apb_bridge (
    input         HCLK, HRESETn,
    input         HSEL, HWRITE, HREADY,
    input  [1:0]  HTRANS,
    input  [31:0] HADDR, HWDATA,
    output        HREADYOUT,
    output [31:0] HRDATA,
    output        PSEL, PENABLE, PWRITE, PRESETn,
    output [31:0] PADDR, PWDATA,
    input  [31:0] PRDATA,
    input         PREADY
);
    wire [31:0] slv_addr, slv_wdata;
    wire        slv_write, slv_valid, apb_done;

    ahb_slave_interface u0 (
        .HCLK(HCLK),         .HRESETn(HRESETn),
        .HSEL(HSEL),          .HTRANS(HTRANS),
        .HWRITE(HWRITE),      .HREADY(HREADY),
        .HADDR(HADDR),        .HWDATA(HWDATA),
        .slv_addr(slv_addr),  .slv_wdata(slv_wdata),
        .slv_write(slv_write),.slv_valid(slv_valid),
        .apb_done(apb_done),
        .HREADYOUT(HREADYOUT),
        .PRDATA(PRDATA),      .HRDATA(HRDATA)
    );

    apb_controller u1 (
        .HCLK(HCLK),           .HRESETn(HRESETn),
        .slv_addr(slv_addr),   .slv_wdata(slv_wdata),
        .slv_write(slv_write), .slv_valid(slv_valid),
        .PSEL(PSEL),            .PENABLE(PENABLE),
        .PWRITE(PWRITE),        .PRESETn(PRESETn),
        .PADDR(PADDR),          .PWDATA(PWDATA),
        .PRDATA(PRDATA),        .PREADY(PREADY),
        .apb_done(apb_done)
    );
endmodule
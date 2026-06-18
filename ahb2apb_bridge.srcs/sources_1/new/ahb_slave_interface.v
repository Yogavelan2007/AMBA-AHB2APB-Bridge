module ahb_slave_interface (
    input         HCLK, HRESETn,
    input         HSEL,
    input  [1:0]  HTRANS,
    input         HWRITE, HREADY,
    input  [31:0] HADDR, HWDATA,
    output reg [31:0] slv_addr, slv_wdata,
    output reg        slv_write, slv_valid,
    input             apb_done,
    output            HREADYOUT,
    input      [31:0] PRDATA,
    output     [31:0] HRDATA
);
    wire valid_ahb = HSEL & HREADY & HTRANS[1];

    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            slv_addr  <= 0; slv_wdata <= 0;
            slv_write <= 0; slv_valid <= 0;
        end else begin
            slv_valid <= valid_ahb;
            if (valid_ahb) begin
                slv_addr  <= HADDR;
                slv_write <= HWRITE;
            end
            if (slv_valid)
                slv_wdata <= HWDATA;
        end
    end

    assign HREADYOUT = apb_done | ~slv_valid;
    assign HRDATA    = PRDATA;
endmodule
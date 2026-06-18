module apb_controller (
    input         HCLK, HRESETn,
    input  [31:0] slv_addr, slv_wdata,
    input         slv_write, slv_valid,
    output reg        PSEL, PENABLE, PWRITE, PRESETn,
    output reg [31:0] PADDR, PWDATA,
    input      [31:0] PRDATA,
    input             PREADY,
    output reg        apb_done
);
    localparam IDLE=2'b00, SETUP=2'b01, ACCESS=2'b10;
    reg [1:0] state, next_state;

    always @(posedge HCLK or negedge HRESETn)
        if (!HRESETn) state <= IDLE;
        else          state <= next_state;

    always @(posedge HCLK or negedge HRESETn)
        if (!HRESETn) PRESETn <= 0;
        else          PRESETn <= 1;

    always @(*) begin
        next_state=IDLE; PSEL=0; PENABLE=0;
        PWRITE=0; PADDR=0; PWDATA=0; apb_done=0;
        case (state)
            IDLE:   if (slv_valid) next_state = SETUP;

            SETUP: begin
                PSEL=1; PENABLE=0;
                PWRITE=slv_write; PADDR=slv_addr; PWDATA=slv_wdata;
                next_state = ACCESS;
            end

            ACCESS: begin
                PSEL=1; PENABLE=1;
                PWRITE=slv_write; PADDR=slv_addr; PWDATA=slv_wdata;
                if (PREADY) begin apb_done=1; next_state=IDLE; end
                else        begin apb_done=0; next_state=ACCESS; end
            end
        endcase
    end
endmodule
import arriskv_pkg::*;

module mem_access #(
    parameter int wd_regs_p = 32

) (
    input  logic                        clk,
    input  logic                        rst_n,
    // In/out operations
    input  decoded_op_t                 i_op,
    output decoded_op_t                 o_op,
    // Mem. interface
    output logic        [wd_regs_p-1:0] o_mem_rd_addr,
    input  logic        [wd_regs_p-1:0] i_mem_rd_data,
    output logic                        o_mem_wr_en,
    output logic        [wd_regs_p-1:0] o_mem_wr_addr,
    output logic        [wd_regs_p-1:0] o_mem_wr_data
);
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            o_op <= '0;
            o_mem_rd_addr <='0;
            o_mem_wr_en <= 0;
            o_mem_wr_addr <= '0;
            o_mem_wr_data <= '0;
        end else begin
            o_op <= i_op;
            o_mem_wr_en <= 0;
            if (i_op.store) begin
                o_mem_wr_en   <= 1;
                o_mem_wr_addr <= i_op.ex_result;
                o_mem_wr_data <= i_op.arg2;
            end
            if (i_op.load) begin
                o_mem_rd_addr <= i_op.ex_result;
            end
        end
    end

endmodule

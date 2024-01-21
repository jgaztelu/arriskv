import arriskv_pkg::*;

module reg_writeback #(
    parameter  int wd_regs_p = 32,
    parameter  int n_regs_p  = 32,
    localparam int wd_addr_p = $clog2(n_regs_p)
) (
    input  logic                        clk,
    input  logic                        rst_n,
    // 
    input  decoded_op_t                 i_op,
    output logic                        o_wr_en,
    output logic        [wd_addr_p-1:0] o_reg_wr_addr,
    output logic        [wd_regs_p-1:0] o_reg_wr_data
);

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            o_wr_en <= 0;
            o_reg_wr_addr <= '0;
            o_reg_wr_data <= '0;
        end else begin
            o_wr_en <= 0;
            if (!i_op.store) begin
                o_wr_en <= 1;
                o_reg_wr_addr <= i_op.rdest;
                o_reg_wr_data <= i_op.ex_result;
            end
        end
    end


endmodule

import arriskv_pkg::*;

module arriskv_top #(
    parameter int wd_regs_p = 32,
    parameter int n_regs_p = 32
) (
    input logic clk,
    input logic rst_n
);

decoded_op_t decoded_op;

instr_decode #(
    .wd_instr_p    (32),
    .n_regs_p      (32),
    .wd_regs_p     (32),
    .n_rd_ports    (2),
    .wd_addr_p     (n_regs_p)
) instr_decode_i (
    .clk(clk),
    .rst_n(rst_n),
    .i_instr(i_instr),
    .o_reg_rd_addr(),
    .i_reg_rd_data(),
    .o_instr(decoded_op)
);

execute #(
    .wd_regs_p    (32)
) execute_i (
    .clk          (clk),
    .rst_n        (rst_n),
    // Inputs from register file
    .i_reg1       (i_reg1),
    .i_reg2       (i_reg2),
    // Decoded instruction
    .i_pc         (i_pc),
    // Decoded operation
    .i_dec_op     (decoded_op)
);

endmodule
import arriskv_pkg::*;

module arriskv_top #(
    parameter int wd_regs_p = 32,
    parameter int n_regs_p = 32,
    localparam int n_reg_rd_ports = 2,
    localparam int n_reg_wr_ports = 2,
    localparam int wd_addr_p = $clog2(n_regs_p)
) (
    input logic clk,
    input logic rst_n
);

    decoded_op_t                                     decoded_op;

    // Register file read/write signals
    logic        [n_reg_rd_ports-1:0][wd_addr_p-1:0] reg_rd_addr;
    logic        [n_reg_rd_ports-1:0][wd_regs_p-1:0] reg_rd_data;
    logic        [n_reg_wr_ports-1:0]                reg_wr_en;
    logic        [n_reg_wr_ports-1:0][wd_addr_p-1:0] reg_wr_addr;
    logic        [n_reg_wr_ports-1:0][wd_regs_p-1:0] reg_wr_data;

    reg_file #(
        .n_regs_p  (n_regs_p),
        .wd_regs_p (wd_regs_p),
        .n_rd_ports(n_reg_rd_ports),
        .n_wr_ports(n_reg_wr_ports)
    ) reg_file_i (
        .clk(clk),
        .rst_n(rst_n),
        // Read ports
        .i_reg_rd_addr(reg_rd_addr),
        .o_reg_rd_data(reg_rd_data),
        // Write ports
        .i_reg_wr_en(reg_wr_en),
        .i_reg_wr_addr(reg_wr_addr),
        .i_reg_wr_data(reg_wr_data)
    );

    instr_decode #(
        .wd_instr_p(32),
        .n_regs_p  (n_regs_p),
        .wd_regs_p (wd_regs_p),
        .n_rd_ports(2)
    ) instr_decode_i (
        .clk(clk),
        .rst_n(rst_n),
        .i_instr(i_instr),
        .o_reg_rd_addr(reg_rd_addr),
        .i_reg_rd_data(),
        .o_instr(decoded_op)
    );

    execute #(
        .n_regs_p  (n_regs_p),
        .wd_regs_p (wd_regs_p),
        .n_rd_ports(n_reg_rd_ports)
    ) execute_i (
        .clk          (clk),
        .rst_n        (rst_n),
        // Inputs from register file
        .i_reg_rd_data(reg_rd_data),
        // Decoded instruction
        .i_pc         (i_pc),
        // Decoded operation
        .i_dec_op     (decoded_op)
    );

endmodule

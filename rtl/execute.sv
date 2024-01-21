module execute #(
    parameter int n_regs_p   = 32,
    parameter int wd_regs_p  = 32,
    parameter int n_rd_ports = 2
) (
    input  logic                                        clk,
    input  logic                                        rst_n,
    // Inputs from register file
    input  logic        [n_rd_ports-1:0][wd_regs_p-1:0] i_reg_rd_data,
    // Program counter input
    input  logic        [ wd_regs_p-1:0]                i_pc,
    // Decoded operation
    input  decoded_op_t                                 i_dec_op,
    // Jump/branch
    output logic                                        o_br_taken,
    output logic        [ wd_regs_p-1:0]                o_jmp_addr,
    // Executed operation
    output decoded_op_t                                 o_ex_op
);

    decoded_op_t decoded_op;
    always_comb begin
        decoded_op = i_dec_op;
        decoded_op.arg1 = i_reg_rd_data[0];
        decoded_op.arg2 = i_reg_rd_data[1];
    end

    alu #(
        .wd_regs_p(wd_regs_p)
    ) alu_i (
        .clk  (clk),
        .rst_n(rst_n),
        // Program counter
        .i_pc (i_pc),
        // Input operation
        .i_op (decoded_op),
        // Outputs
        .o_op (o_ex_op)
    );

    branching #(
        .wd_regs_p(wd_regs_p)
    ) branching_i (
        .clk       (clk),
        .rst_n     (rst_n),
        // Program counter
        .i_pc      (i_pc),
        // Branch taken, set PC to new value
        .o_pc      (o_jmp_addr),
        .o_br_taken(o_br_taken),
        // Input arguments
        .i_op      (decoded_op)
    );


endmodule

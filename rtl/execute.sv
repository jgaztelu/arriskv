module execute #(
    parameter int wd_regs_p = 32
) (
    input logic clk,
    input logic rst_n,
    // Inputs from register file
    input logic [wd_regs_p-1:0] i_reg1,
    input logic [wd_regs_p-1:0] i_reg2,
    // Decoded instruction
    input decoded_op_t          i_dec_op,
    input logic i_jump,
    input logic [wd_regs_p-1:0] i_pc,
    input logic instruction  // TODO: Replace placeholder with decoded instruction interface
);

    decoded_op_t decoded_op;

    alu #(
        .wd_regs_p(wd_regs_p)
    ) alu_i (
        .clk         (clk),
        .rst_n       (rst_n),
        // Program counter
        .i_pc        (i_pc),
        // Input arguments
        .i_arg1      (i_arg1),
        .i_arg2      (i_arg2),
        // Instruction
        .i_instr     (i_instr),
        .i_instr_type(i_instr_type),
        .o_result    (o_result),
        .o_rdest     (o_rdest)
    );

    branching #(
        .wd_regs_p(wd_regs_p)
    ) branching_i (
        .clk       (clk),
        .rst_n     (rst_n),
        // Program counter
        .i_pc      (i_pc),
        .o_pc      (o_pc),
        .o_br_taken(o_br_taken),
        // Branch taken, set PC to new value
        // Input arguments
        .i_arg1    (i_arg1),
        .i_arg2    (i_arg2),
        .i_jump    (i_jump),
        // Jump type operation 
        // Instruction
        //input  instr_type_t     i_instr_type
        .i_instr   (i_instr)
    );

endmodule

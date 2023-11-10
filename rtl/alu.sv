import arriskv_pkg::*;

module alu #(
    parameter int wd_regs_p = 32
) (
    input logic clk,
    input logic rst_n,
    // Program counter
    input logic [wd_regs_p-1:0] i_pc,
    output logic [wd_regs_p-1:0] o_pc,
    // Input arguments
    input logic [wd_regs_p-1:0] i_arg1,
    input logic [wd_regs_p-1:0] i_arg2,
    // Instruction
    input  instr_t          i_instr,
    input  instr_type_t     i_instr_type,
    output logic [wd_regs_p-1:0] o_result
    
);
    logic [wd_regs_p-1:0] arg1_se;
    logic [wd_regs_p-1:0] arg2_se;
    logic [4:0] shamt;              // Shift amount
    
    assign shamt = i_arg2[4:0];

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            o_result <= '0;
        end else begin
            case (i_instr)
                ADDI: o_result <= i_arg1 + arg2_se;
                SLTI: o_result <= (i_arg1 < arg2_se) ? 1 : 0;   // TODO: Convert to signed comparison!
                SLTIU: o_result <= (i_arg1 < arg2_se) ? 1 : 0;
                ANDI: o_result <= i_arg1 & arg2_se;
                ORI: o_result <= i_arg1 | arg2_se;
                XORI: o_result <= i_arg1 ^ arg2_se;
                ADD: o_result <= i_arg1 + i_arg2;
                SLLI: o_result <= i_arg1 << shamt;
                SRLI: o_result <= i_arg1 >> shamt;
                SRAI: o_result <= i_arg1 >>> shamt;             // TODO: Check with signed inputs
                LUI: o_result <=  {i_arg2[19:0], 12'b0};        // TODO: Think about separate port for immediates?  
                AUIPC: o_pc    <= i_pc + {i_arg2[19:0], 12'b0};
                default: o_result <= '0;
            endcase
        end
    end
    
    sign_extend #(
        .wd_regs_p(wd_regs_p)
    ) sign_extend_i (
        .i_immediate(i_arg2),
        .i_instr_type(i_instr_type),
        .o_sign_ext(arg2_se)
    );
    
endmodule
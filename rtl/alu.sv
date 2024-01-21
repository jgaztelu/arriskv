import arriskv_pkg::*;

module alu #(
    parameter int wd_regs_p = 32
) (
    input  logic                        clk,
    input  logic                        rst_n,
    // Program counter
    input  logic        [wd_regs_p-1:0] i_pc,
    // Input operation    
    input  decoded_op_t                 i_op,
    // Output operation
    //output logic        [wd_regs_p-1:0] o_result,
    //output logic        [wd_regs_p-1:0] o_rdest
    output decoded_op_t                 o_op

);

    logic [4:0] shamt;  // Shift amount

    assign shamt = i_op.imm[4:0];

    always_ff @(posedge clk) begin : arith_proc
        if (!rst_n) begin
            //o_result <= '0;
            o_op <= '0;
        end else begin
            // Default assignments
            // o_result <= '0;
            o_op <= i_op;
            case (i_op.op)
                // Register-immediate
                ADDI:  o_op.ex_result <= i_op.arg1 + i_op.imm_se;
                SLTI:  o_op.ex_result <= (i_op.arg1 < i_op.imm_se) ? 1 : 0;  // TODO: Convert to signed comparison!
                SLTIU: o_op.ex_result <= (i_op.arg1 < i_op.imm_se) ? 1 : 0;
                ANDI:  o_op.ex_result <= i_op.arg1 & i_op.imm_se;
                ORI:   o_op.ex_result <= i_op.arg1 | i_op.imm_se;
                XORI:  o_op.ex_result <= i_op.arg1 ^ i_op.imm_se;
                SLLI:  o_op.ex_result <= i_op.arg1 << shamt;
                SRLI:  o_op.ex_result <= i_op.arg1 >> shamt;
                SRAI:  o_op.ex_result <= i_op.arg1 >>> shamt;  // TODO: Check with signed inputs
                LUI:   o_op.ex_result <= {i_op.arg2[19:0], 12'b0};  // TODO: Think about separate port for immediates?  

                // Register-register
                ADD: o_op.ex_result <= i_op.arg1 + i_op.arg2;
                SLT: o_op.ex_result <= (i_op.arg1 < i_op.arg2) ? 1 : 0;  // TODO: Convert to signed comparison!
                SLTU: o_op.ex_result <= (i_op.arg1 < i_op.arg2) ? 1 : 0;
                AND: o_op.ex_result <= i_op.arg1 & i_op.arg2;
                OR: o_op.ex_result <= i_op.arg1 | i_op.arg2;
                XOR: o_op.ex_result <= i_op.arg1 ^ i_op.arg2;
                SLLI: o_op.ex_result <= i_op.arg1 << shamt;  // TODO: Ensure shamt comes from reg and not immediate?
                SRLI: o_op.ex_result <= i_op.arg1 >> shamt;
                SRA: o_op.ex_result <= i_op.arg1 >>> shamt;  // TODO: Check with signed inputs
                SUB: o_op.ex_result <= i_op.arg1 - i_op.arg2;
                AUIPC: o_op.ex_result <= i_pc + {i_op.arg2[19:0], 12'b0};

                // New address calculation / Jumps
                JAL:  o_op.ex_result <= i_pc + i_op.imm_se[20:0];  // TODO: Implement actual jump behavior
                JALR: o_op.ex_result <= i_op.arg1 + i_op.imm_se[11:0];  // TODO: Implement actual jump behavior

                // Load/store address
                LB, LH, LW, LBU, LHU: o_op.ex_result <= i_op.arg1 + i_op.imm_se;
                SB, SH, SW: o_op.ex_result <= i_op.arg1 + i_op.imm_se;


                default: o_op.ex_result <= '0;
            endcase
        end
    end
endmodule

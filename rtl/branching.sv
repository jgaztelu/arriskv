import arriskv_pkg::*;

module branching #(
    parameter int wd_regs_p = 32
) (
    input  logic                        clk,
    input  logic                        rst_n,
    // Program counter
    input  logic        [wd_regs_p-1:0] i_pc,
    output logic        [wd_regs_p-1:0] o_pc,
    output logic                        o_br_taken,  // Branch taken, set PC to new value
    // Input arguments
    input  decoded_op_t                 i_op
);

    always_ff @(posedge clk) begin : branching_proc
        if (!rst_n) begin
            o_pc <= '0;
            o_br_taken <= 0;
        end else begin
            if (i_op.jump) begin
                case (i_op.op)
                    JAL: o_pc <= i_pc + i_op.arg2[19:0] + 4;
                    JALR: o_pc <= i_op.arg1 + i_op.arg2[11:0] + 4;  // TODO: Need to add sign extension
                    BEQ:
                    o_pc <= (i_op.arg1 == i_op.arg2) ? i_pc + i_op.arg2[12:0] : i_pc; // TODO: Add immediate port, substitue i_op.arg2  
                    BNE:
                    o_pc <= (i_op.arg1 != i_op.arg2) ? i_pc + i_op.arg2[12:0] : i_pc; // TODO: Add immediate port, substitue i_op.arg2    
                    BLT:
                    o_pc <= (i_op.arg1 < i_op.arg2) ? i_pc + i_op.arg2[12:0] : i_pc;  // TODO: Make signed 
                    BGE:
                    o_pc <= (i_op.arg1 >= i_op.arg2) ? i_pc + i_op.arg2[12:0] : i_pc;  // TODO: Make signed  
                    BLTU:
                    o_pc <= (i_op.arg1 < i_op.arg2) ? i_pc + i_op.arg2[12:0] : i_pc; // TODO: Add immediate port, substitue i_op.arg2  
                    BGEU:
                    o_pc <= (i_op.arg1 >= i_op.arg2) ? i_pc + i_op.arg2[12:0] : i_pc; // TODO: Add immediate port, substitue i_op.arg2  
                endcase

                o_br_taken <= 1;
            end else begin
                o_pc <= i_pc;
                o_br_taken <= 0;
            end
        end
    end
endmodule

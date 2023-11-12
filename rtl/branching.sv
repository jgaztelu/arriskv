import arriskv_pkg::*;

module branching #(
    parameter int wd_regs_p = 32
) (
    input logic clk,
    input logic rst_n,
    // Program counter
    input logic [wd_regs_p-1:0] i_pc,
    output logic [wd_regs_p-1:0] o_pc,
    output logic                 o_br_taken,   // Branch taken, set PC to new value
    // Input arguments
    input logic [wd_regs_p-1:0] i_arg1,
    input logic [wd_regs_p-1:0] i_arg2,
    input logic                 i_jump,        // Jump type operation 
    // Instruction
    input  instr_t          i_instr
    //input  instr_type_t     i_instr_type
);

always_ff @(posedge clk) begin : branching_proc
    if (!rst_n) begin
        o_pc <= '0;
        o_br_taken <= 0;
    end else begin
        if (i_jump) begin
            case (i_instr)
                JAL:  o_pc <= i_pc + i_arg2[19:0] + 4;
                JALR: o_pc <= i_arg1 + i_arg2[11:0] + 4; // TODO: Need to add sign extension
                BEQ:  o_pc <= (i_arg1 == i_arg2) ? i_pc + i_arg2[12:0] : i_pc; // TODO: Add immediate port, substitue i_arg2  
                BNE:  o_pc <= (i_arg1 != i_arg2) ? i_pc + i_arg2[12:0] : i_pc; // TODO: Add immediate port, substitue i_arg2    
                BLT:  o_pc <= (i_arg1 < i_arg2) ? i_pc + i_arg2[12:0] : i_pc; // TODO: Make signed 
                BGE:  o_pc <= (i_arg1 >= i_arg2) ? i_pc + i_arg2[12:0] : i_pc; // TODO: Make signed  
                BLTU: o_pc <= (i_arg1 < i_arg2) ? i_pc + i_arg2[12:0] : i_pc; // TODO: Add immediate port, substitue i_arg2  
                BGEU: o_pc <= (i_arg1 >= i_arg2) ? i_pc + i_arg2[12:0] : i_pc; // TODO: Add immediate port, substitue i_arg2  
            endcase

            o_br_taken <= 1;
        end else begin
            o_pc <= i_pc;
            o_br_taken <= 0;
        end
    end        
end
endmodule
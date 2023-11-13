import arriskv_pkg::*;

module instr_decode #(
    parameter  int wd_instr_p = 32,
    parameter  int n_regs_p   = 32,
    parameter  int wd_regs_p  = 32,
    parameter  int n_rd_ports = 2,
    localparam int wd_addr_p  = $clog2(n_regs_p)
) (
    input logic clk,
    input logic rst_n,
    // Incoming instruction
    input logic [wd_instr_p-1:0] i_instr,

    // Read ports for register file
    output logic [n_rd_ports-1:0][wd_addr_p-1:0] o_reg_rd_addr,
    input  logic [n_rd_ports-1:0][wd_regs_p-1:0] i_reg_rd_data,

    // Output to ALU
    output decoded_op_t o_instr

);

    operation_t decode_v;
    logic [wd_regs_p-1:0] imm_se;  // Sign-extended immediate

    always_comb begin : decode_proc
        decode_v = '0;
        // Simple rs1/rs2/rd extraction, always get assigned even if not needed
        decode_v.rs1 = i_instr[19:15];
        decode_v.rs2 = i_instr[24:20];
        decode_v.rdest = i_instr[11:7];
        // Simple funct7/funct3 extraction
        decode_v.funct7 = i_instr[31:25];
        decode_v.funct3 = i_instr[14:12];
        decode_v.imm_sign = i_instr[31];

        // Extract instruction type
        case (i_instr[6:0])
            7'b0000011: decode_v.instr_type = IL;
            //7'b0100011: decode_v.instr_type = IS;
            7'b0110011: decode_v.instr_type = R;
            7'b0010011: decode_v.instr_type = I;
            7'b0100011: decode_v.instr_type = S;
            7'b1100011: decode_v.instr_type = B;
            7'b0110111: decode_v.instr_type = U;
            7'b1100111: decode_v.instr_type = IJ;  // Only used for JALR? TODO: Check this
            7'b1101111: decode_v.instr_type = J;
            default: decode_v.instr_type = I;  // Shouldn't get here, use I as default for the moment
        endcase

        // Extract immediate. For smaller immediates, only LSBs are used
        case (decode_v.instr_type)
            R: decode_v.immediate = '0;  // No immediate
            I: decode_v.immediate = {8'b0, i_instr[31:20]};
            S: decode_v.immediate = {8'b0, i_instr[31:25], i_instr[11:7]};
            B: decode_v.immediate = {7'b0, i_instr[31], i_instr[7], i_instr[30:25], i_instr[11:8], 1'b0};  // Pad with zero for branch addresses
            U: decode_v.immediate = i_instr[31:12];
            J: decode_v.immediate = {7'b0, i_instr[31], i_instr[19:12], i_instr[20], i_instr[30:21], 1'b0};  // Pad with zero for branch addresses
        endcase

        // Extract opcode
        // case (i_instr[6:5])
        //     2'b00: begin
        //         case (i_instr[4:2])
        //             3'b000: decode_v.opcode = LOAD;
        //             3'b100: decode_v.opcode = OP_IMM;
        //             //3'b101: decode_v.opcode = AUIPC;
        //             default: decode_v.opcode = NOP;
        //         endcase
        //     end
        //     2'b01: begin
        //         case (i_instr[4:2])
        //             3'b000: decode_v.opcode = STORE;
        //             3'b100: decode_v.opcode = OP;
        //             //3'b101: decode_v.opcode = LUI;
        //             default: decode_v.opcode = NOP;
        //         endcase
        //     end
        //     2'b10: begin
        //         decode_v.opcode = NOP;
        //     end
        //     2'b11: begin
        //         case (i_instr[4:2])
        //             3'b000: decode_v.opcode = BRANCH;
        //             //3'b001: decode_v.opcode = JALR;
        //             //3'b011: decode_v.opcode = JAL;
        //             3'b100: decode_v.opcode = SYSTEM;
        //             default: decode_v.opcode = NOP;                       
        //         endcase
        //     end
        // endcase
        decode_v.instruction <= NOP;
        decode_v.jump <= 0;
        case (decode_v.instr_type)
            I: begin
                case (decode_v.funct3)
                    3'b000: decode_v.instruction = ADDI;
                    3'b001: decode_v.instruction = SLLI;
                    3'b010: decode_v.instruction = SLTI;
                    3'b011: decode_v.instruction = SLTIU;
                    3'b100: decode_v.instruction = XORI;
                    3'b101: decode_v.instruction = i_instr[30] ? SRLI : SRAI;
                    3'b110: decode_v.instruction = ORI;
                    3'b111: decode_v.instruction = ANDI;
                endcase
            end

            U: begin
                case (i_instr[6:0])
                    7'b0110111: decode_v.instruction = LUI;
                    7'b0010111: decode_v.instruction = AUIPC;
                endcase
            end

            R: begin
                // TODO: Add funct7 (bit 30 instrus)
                case (decode_v.funct7)
                    7'b0000000: begin
                        case (decode_v.funct3)
                            3'b000: decode_v.instruction = ADD;
                            3'b001: decode_v.instruction = SLL;
                            3'b010: decode_v.instruction = SLT;
                            3'b011: decode_v.instruction = SLTU;
                            3'b100: decode_v.instruction = XOR;
                            3'b101: decode_v.instruction = SRL;
                            3'b110: decode_v.instruction = ORI;
                            3'b111: decode_v.instruction = ANDI;
                        endcase
                    end
                    7'b0100000: begin
                        case (decode_v.funct3)
                            3'b000: decode_v.instruction = SUB;
                            3'b101: decode_v.instruction = SRA;
                        endcase
                    end
                endcase
            end

            J: begin
                decode_v.instruction = JAL;
                decode_v.jump <= 1;
            end

            IJ: begin
                decode_v.instruction = JALR;
                decode_v.jump <= 1;
            end

            B: begin
                decode_v.jump <= 1;
                case (decode_v.funct3)
                    3'b000: decode_v.instruction = BEQ;
                    3'b001: decode_v.instruction = BNE;
                    3'b100: decode_v.instruction = BLT;
                    3'b101: decode_v.instruction = BGE;
                    3'b110: decode_v.instruction = BLTU;
                    3'b111: decode_v.instruction = BGEU;
                endcase
            end

            IL: begin
                case (decode_v.funct3)
                    3'b000: decode_v.instruction = LB;
                    3'b001: decode_v.instruction = LH;
                    3'b010: decode_v.instruction = LW;
                    3'b100: decode_v.instruction = LBU;
                    3'b101: decode_v.instruction = LHU;
                endcase
            end

            S: begin
                case (decode_v.funct3)
                    3'b000: decode_v.instruction = SB;
                    3'b001: decode_v.instruction = SH;
                    3'b010: decode_v.instruction = SW;
                endcase
            end

        endcase

    end

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            o_reg_rd_addr <= '0;
            o_instr <= '0;
        end else begin
            o_reg_rd_addr[0] <= decode_v.rs1;
            o_reg_rd_addr[1] <= decode_v.rs2;
            // Assign outputs towards execution stage
            o_instr.op <= decode_v.instruction;
            o_instr.imm <= decode_v.immediate;
            o_instr.rdest <= decode_v.rdest;
            o_instr.arg1 <= '0;
            o_instr.arg2 <= '0;
            o_instr.jump <= decode_v.jump;
            o_instr.imm_se <= imm_se;
        end
    end

    // Sign extend immediates
    sign_extend #(
        .wd_regs_p(wd_regs_p)
    ) sign_extend_i1 (
        .i_immediate (decode_v.immediate),
        .i_instr_type(decode_v.instr_type),
        .o_sign_ext  (imm_se)
    );


endmodule

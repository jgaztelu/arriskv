package arriskv_pkg;
    typedef enum logic[2:0]{R,I,S,B,U,J} instr_type_t;
    typedef enum logic[3:0]{OP_IMM,/*LUI,AUIPC*/OP,JAL,JALR,BRANCH,LOAD,STORE,MISC_MEM,SYSTEM,NOP} opcode_t;
    typedef enum {  /* Integer instructions */
                    /* Register immediate */
                    ADDI,SLTI,SLTIU,ANDI,ORI,XORI,SLLI,SRLI,SRAI, // I-type
                    LUI,AUIPC,                                     // U-type  
                    /* Register-Register instructions */
                    ADD,SLT,SLTU,AND,OR,XOR,SLL,SRL,SUB,SRA
                    } instr_t;
    
    typedef struct packed {
        instr_type_t instr_type;
        opcode_t    opcode;
        instr_t     instruction;
        logic [4:0] rs1;
        logic [4:0] rs2;
        logic [4:0] rdest;
        logic [19:0] immediate;
        logic [6:0] funct7;
        logic [2:0] funct3;
    } operation_t;    
endpackage
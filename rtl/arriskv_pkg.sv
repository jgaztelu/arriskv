package arriskv_pkg;
    // Instruction types according to ISA opcodes (RISBUJ)
    // Special types for different opcodes with same instruction type: IJ (Integer jump), IL (Integer load), IS (Integer store)
    typedef enum logic [3:0] {
        R,
        I,
        S,
        B,
        U,
        J,
        IJ,
        IL   /*,
        IS*/
    } instr_type_t;
    //typedef enum logic[3:0]{OP_IMM,/*LUI,AUIPC*/OP,/*JAL,JALR,*/BRANCH,LOAD,STORE,MISC_MEM,SYSTEM,NOP} opcode_t;
    typedef enum {  /* Integer instructions */
        /* Register immediate */
        ADDI,
        SLTI,
        SLTIU,
        ANDI,
        ORI,
        XORI,
        SLLI,
        SRLI,
        SRAI,   // I-type
        LUI,
        AUIPC,  // U-type  
        /* Register-Register instructions */
        ADD,
        SLT,
        SLTU,
        AND,
        OR,
        XOR,
        SLL,
        SRL,
        SUB,
        SRA,
        /* Control transfer instructions */
        JAL,
        JALR,
        BEQ,
        BNE,
        BLT,
        BLTU,
        BGE,
        BGEU,
        /* Load/store instructions */
        LB,
        LH,
        LW,
        LBU,
        LHU,
        SB,
        SH,
        SW,
        /* NOP instruction */
        NOP
    } instr_t;

    typedef struct packed {
        instr_type_t instr_type;
        //logic [6:0]    opcode;
        instr_t      instruction;
        logic [4:0]  rs1;
        logic [4:0]  rs2;
        logic [4:0]  rdest;
        logic [19:0] immediate;
        logic [6:0]  funct7;
        logic [2:0]  funct3;
        logic        imm_sign;
        logic        jump;
        logic        load;
        logic        store;
    } operation_t;

    typedef struct packed {
        instr_t      op;
        logic [31:0] arg1;
        //logic [31:0] arg1_se;  // Sign extended
        logic [31:0] arg2;
        //logic [31:0] arg2_se;  // Sign extended
        logic [19:0] imm;
        logic [31:0] imm_se;
        logic [4:0]  rdest;
        logic [31:0] ex_result;  // Execution result
        logic        jump;       // Jump type operation    
        logic        load;
        logic        store;
    } decoded_op_t;

endpackage

package arriskv_pkg;
    typedef enum logic[2:0]{R,I,S,B,U,J} instr_type_t;
    
    typedef struct packed {
        instr_type_t instr_type;
        logic [4:0] rs1;
        logic [4:0] rs2;
        logic [4:0] rdest;
        logic [19:0] immediate;
        logic [6:0] funct7;
        logic [2:0] funct3;
    } operation_t;    
endpackage
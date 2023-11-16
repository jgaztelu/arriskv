import arriskv_pkg::*;

module sign_extend #(
    parameter int wd_regs_p = 32
) (
    input  logic        [wd_regs_p-1:0] i_immediate,
    input  instr_type_t                 i_instr_type,
    output logic        [wd_regs_p-1:0] o_sign_ext
);

    always_comb begin : sign_extend_proc
        case (i_instr_type)
            I,IJ,IL,S: o_sign_ext = {{(wd_regs_p - 12) {i_immediate[11]}}, i_immediate[11:0]};  //12b imm
            //IJ: o_sign_ext = {{(wd_regs_p - 12) {i_immediate[11]}}, i_immediate[11:0]};
            //IL: o_sign_ext = {{(wd_regs_p - 12) {i_immediate[11]}}, i_immediate[11:0]};
            //IS: o_sign_ext = {{(wd_regs_p - 12) {i_immediate[11]}}, i_immediate[11:0]};
            //S: o_sign_ext = {{(wd_regs_p - 12) {i_immediate[11]}}, i_immediate[11:0]};
            B: o_sign_ext = {{(wd_regs_p - 13) {i_immediate[12]}}, i_immediate[12:0]};          //13b imm
            U,J: o_sign_ext = {{(wd_regs_p - 20) {i_immediate[19]}}, i_immediate[19:0]};        //20b imm
            //J: o_sign_ext = {{(wd_regs_p - 20) {i_immediate[19]}}, i_immediate[19:0]};
            default: o_sign_ext = i_immediate;
        endcase
    end
endmodule

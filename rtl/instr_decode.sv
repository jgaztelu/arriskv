import arriskv_pkg::*;

module instr_decode #(
    parameter wd_instr_p = 32
) (
    input logic clk,
    input logic rst_n,
    // Incoming instruction
    input logic [wd_instr_p-1:0] i_instr,

    output operation_t o_decoded_instr
);
    
    operation_t instr_decoded;

    always_ff @(posedge clk) begin
        operation_t decode_v;
        if (!rst_n) begin
            o_decoded_instr <= '0;
        end else begin
            decode_v = '0;
            // Simple rs1/rs2/rd extraction, always get assigned even if not needed
            decode_v.rs1 = i_instr[19:15];
            decode_v.rs2 = i_instr[24:20];
            decode_v.rdest = i_instr[11:7];
            // Simple funct7/funct3 extraction
            decode_v.funct7 = i_instr[31:25];
            decode_v.funct3 = i_instr[14:12];

            // Extract instruction type
            case (i_instr[6:0]) 
                6'b0110011: decode_v.instr_type = R;
                6'b0010011: decode_v.instr_type = I;
                6'b0100011: decode_v.instr_type = S;
                6'b1100011: decode_v.instr_type = B;
                6'b0110111: decode_v.instr_type = U;
                6'b1101111: decode_v.instr_type = J;
                default: decode_v.instr_type = I; // Shouldn't get here, use I as default for the moment
            endcase            

            // Extract immediate. For smaller immediates, only LSBs are used
            case (decode_v.instr_type)
                R: decode_v.immediate = '0; // No immediate
                I: decode_v.immediate = {8'b0, i_instr[31:20]};
                S: decode_v.immediate = {8'b0, i_instr[31:25], i_instr[11:7]};
                B: decode_v.immediate = {7'b0, i_instr[31], i_instr[7], i_instr[30:25], i_instr[11:8], 1'b0}; // Pad with zero for branch addresses
                U: decode_v.immediate = i_instr[31:12];
                J: decode_v.immediate = {7'b0, i_instr[31], i_instr[19:12], i_instr[20], i_instr[30:21], 1'b0}; // Pad with zero for branch addresses
            endcase
            
            o_decoded_instr <= decode_v;
        end
    end


endmodule
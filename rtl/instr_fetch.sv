module instr_fetch #(
    parameter int wd_regs_p = 32,
    parameter int wd_ramaddr_p = 32
) (
    input logic clk,
    input logic rst_n,
    // Instruction fetch from memory
    output logic [wd_ramaddr_p-1:0] o_fetch_addr,
    input logic [wd_regs_p-1:0] i_fetch_data,
    // Output to decoder
    output logic [wd_regs_p-1:0] o_fetch_data,
    // Inputs for jump/branch instructions
    input logic i_jmp,
    input logic [wd_regs_p-1:0] i_jmp_addr
);

    logic [wd_ramaddr_p-1:0] prog_cnt;  // Program counter

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            prog_cnt <= '0;
            o_fetch_data <= '0;
        end else begin
            if (i_jmp) begin
                prog_cnt <= i_jmp_addr;
            end else begin
                prog_cnt <= prog_cnt + 4;
            end
            o_fetch_data <= i_fetch_data;
        end
    end
    assign o_fetch_addr = prog_cnt;

endmodule

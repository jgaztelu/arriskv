import arriskv_pkg::*;

module alu #(
    parameter int wd_regs_p = 32
) (
    input logic clk,
    input logic rst_n,
    // Input arguments
    input logic [wd_regs_p-1:0] arg1,
    input logic [wd_regs_p-1:0] arg2,
    
);
    logic [wd_regs_p-1:0] arg1
    always_ff @(posedge clk) begin
        if (!rst_n) begin
        end else begin
        end
    end
    
endmodule
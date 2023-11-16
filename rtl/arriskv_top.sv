import arriskv_pkg::*;

module arriskv_top #(
    parameter int wd_regs_p = 32,
    parameter int n_regs_p = 32,
    localparam int n_reg_rd_ports = 2,
    localparam int n_reg_wr_ports = 2,
    localparam int wd_addr_p = $clog2(n_regs_p)
) (
    input  logic                 clk,
    input  logic                 rst_n,
    // Mem interface
    output logic [wd_regs_p-1:0] o_mem_rd_addr,
    input  logic [wd_regs_p-1:0] i_mem_rd_data,
    output logic                 o_mem_wr_en,
    output logic [wd_regs_p-1:0] o_mem_wr_addr,
    output logic [wd_regs_p-1:0] o_mem_wr_data

);

    decoded_op_t                                     decoded_op;

    // Internal BRAM signals
    logic        [     wd_regs_p-1:0]                ram_rd_addr;
    logic        [     wd_regs_p-1:0]                ram_rd_data;
    logic                                            ram_wr_en;
    logic        [     wd_regs_p-1:0]                ram_wr_addr;
    logic        [     wd_regs_p-1:0]                ram_wr_data;


    // Register file read/write signals
    logic        [n_reg_rd_ports-1:0][wd_addr_p-1:0] reg_rd_addr;
    logic        [n_reg_rd_ports-1:0][wd_regs_p-1:0] reg_rd_data;
    logic        [n_reg_wr_ports-1:0]                reg_wr_en;
    logic        [n_reg_wr_ports-1:0][wd_addr_p-1:0] reg_wr_addr;
    logic        [n_reg_wr_ports-1:0][wd_regs_p-1:0] reg_wr_data;

    logic        [     wd_regs_p-1:0]                fetch_data;
    logic        [     wd_regs_p-1:0]                jmp_addr;
    logic                                            jmp;

    reg_file #(
        .n_regs_p  (n_regs_p),
        .wd_regs_p (wd_regs_p),
        .n_rd_ports(n_reg_rd_ports),
        .n_wr_ports(n_reg_wr_ports)
    ) reg_file_i (
        .clk(clk),
        .rst_n(rst_n),
        // Read ports
        .i_reg_rd_addr(reg_rd_addr),
        .o_reg_rd_data(reg_rd_data),
        // Write ports
        .i_reg_wr_en(reg_wr_en),
        .i_reg_wr_addr(reg_wr_addr),
        .i_reg_wr_data(reg_wr_data)
    );

    instr_fetch #(
        .wd_regs_p   (32),
        .wd_ramaddr_p(32)
    ) instr_fetch_i (
        .clk         (clk),
        .rst_n       (rst_n),
        // Instruction fetch from memory
        .o_fetch_addr(ram_rd_addr),
        .i_fetch_data(ram_rd_data),
        // Output to decoder
        .o_fetch_data(fetch_data),
        // Inputs for jump/branch instructions
        .i_jmp       (jmp),
        .i_jmp_addr  (jmp_addr)
    );

    instr_decode #(
        .wd_instr_p(32),
        .n_regs_p  (n_regs_p),
        .wd_regs_p (wd_regs_p),
        .n_rd_ports(2)
    ) instr_decode_i (
        .clk(clk),
        .rst_n(rst_n),
        .i_instr(fetch_data),
        .o_reg_rd_addr(reg_rd_addr),
        .i_reg_rd_data(),
        .o_instr(decoded_op)
    );

    execute #(
        .n_regs_p  (n_regs_p),
        .wd_regs_p (wd_regs_p),
        .n_rd_ports(n_reg_rd_ports)
    ) execute_i (
        .clk          (clk),
        .rst_n        (rst_n),
        // Inputs from register file
        .i_reg_rd_data(reg_rd_data),
        // Decoded instruction
        .i_pc         (i_pc),
        // Decoded operation
        .i_dec_op     (decoded_op),
        // Jump/branch
        .o_br_taken   (jmp),
        .o_jmp_addr   (jmp_addr)
    );

    // ram #(
    //     .ram_size_p(1024)
    // ) ram_i (
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .i_ram_rd_addr(ram_rd_addr),
    //     .o_ram_rd_data(ram_rd_data),
    //     .i_ram_wr_en(ram_wr_en),
    //     .i_ram_wr_addr(ram_wr_addr),
    //     .i_ram_wr_data(ram_wr_data)
    // );

    assign o_mem_rd_addr = ram_rd_addr;
    assign ram_rd_data = i_mem_rd_data;
endmodule

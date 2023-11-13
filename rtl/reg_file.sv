module reg_file #(
    parameter  int n_regs_p   = 32,
    parameter  int wd_regs_p  = 32,
    parameter  int n_rd_ports = 2,
    parameter  int n_wr_ports = 1,
    localparam int wd_addr_p  = $clog2(n_regs_p)
) (
    // Clock and reset
    input  logic                                 clk,
    input  logic                                 rst_n,
    // Read ports
    input  logic [n_rd_ports-1:0][wd_addr_p-1:0] i_reg_rd_addr,
    output logic [n_rd_ports-1:0][wd_regs_p-1:0] o_reg_rd_data,
    // Write ports
    input  logic [n_wr_ports-1:0]                i_reg_wr_en,
    input  logic [n_wr_ports-1:0][wd_addr_p-1:0] i_reg_wr_addr,
    input  logic [n_wr_ports-1:0][wd_regs_p-1:0] i_reg_wr_data
);

    logic [n_regs_p-1:0][wd_regs_p-1:0] reg_file;

    always_ff @(posedge clk) begin : reg_file_wr_proc
        if (!rst_n) begin
            reg_file <= '0;
        end else begin
            // Write to reg_file from each write port
            for (int i = 0; i < n_wr_ports; i++) begin
                if (i_reg_wr_en[i]) begin
                    reg_file[i_reg_wr_addr[i]] <= i_reg_wr_data[i];
                end
            end
            // Reg. x0 hardcoded to zero according to spec
            reg_file[0] <= '0;
        end
    end

    // always_ff @(posedge clk) begin: reg_file_rd_proc_ff
    //     for (int i=0; i<n_rd_ports; i++) begin
    //         o_reg_rd_data[i] <= reg_file[i_reg_rd_addr[i]];
    //     end
    // end

    // Combinational read
    always_comb begin : reg_file_rd_proc_comb
        for (int i = 0; i < n_rd_ports; i++) begin
            o_reg_rd_data[i] = reg_file[i_reg_rd_addr[i]];
        end
    end


endmodule

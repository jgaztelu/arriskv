module ram #(
    parameter ram_size_p = 1024,
    localparam wd_addr_p = $clog2(ram_size_p),
    localparam wd_ram_p = 4*8
) (
    input logic clk,
    input logic rst_n,
    // Read port
    input logic [wd_addr_p-1:0] i_ram_rd_addr,
    output logic [wd_ram_p-1:0] o_ram_rd_data,
    // Write port
    input logic                 i_ram_wr_en,
    input logic [wd_addr_p-1:0] i_ram_wr_addr,
    input logic [wd_ram_p-1:0]  i_ram_wr_data
);
    
    logic [wd_ram_p-1:0] ram_file [ram_size_p];

    always_ff @(posedge clk) begin : ram_file_proc
        if (!rst_n) begin
            o_ram_rd_data <= '0;
        end else begin
            if (i_ram_wr_en) begin
                ram_file[i_ram_wr_addr] <= i_ram_wr_data;
            end
            o_ram_rd_data <= ram_file[i_ram_rd_addr];
        end
    end
endmodule
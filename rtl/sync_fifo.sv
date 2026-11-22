`timescale 1ns / 1ps

module sync_fifo #(
    parameter int unsigned DATA_WIDTH          = 8,
    parameter int unsigned DEPTH               = 16,
    parameter int unsigned ALMOST_FULL_THRESH  = 14,
    parameter int unsigned ALMOST_EMPTY_THRESH = 2
) (
    input  logic                    clk,
    input  logic                    rst_n,

    // Write interface
    input  logic                    wr_en,
    input  logic [DATA_WIDTH-1:0]   wr_data,
    output logic                    full,
    output logic                    almost_full,

    // Read interface
    input  logic                    rd_en,
    output logic [DATA_WIDTH-1:0]   rd_data,
    output logic                    empty,
    output logic                    almost_empty,

    // Diagnostics / occupancy
    output logic [$clog2(DEPTH):0]  occupancy
);
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];  //RAM memory array
    logic [$clog2(DEPTH):0] wr_ptr, rd_ptr;
    // TODO:
    // 1. Declare the RAM memory array: logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    // 2. Implement write (wr_ptr) and read (rd_ptr) pointers.
    // 3. Implement synchronous registered read on rd_data when rd_en is asserted.
    // 4. Implement an occupancy counter.
    // 5. Calculate flags: empty, full, almost_empty, almost_full.
    // 6. Handle simultaneous read and write.

    assign full         = 1'b0;
    assign almost_full  = 1'b0;
    assign empty        = 1'b1;
    assign almost_empty = 1'b1;
    assign occupancy    = '0;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin  //reset
            rd_ptr <= '0;
        end
        else begin
            if (rd_en && !empty) begin
                rd_data <= mem[rd_ptr]; //read the data
                rd_ptr++;
            end
        end
    end

endmodule

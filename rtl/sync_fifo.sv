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
    logic valid_rd;
    logic valid_wr;
    // TODO:
    // 1. Declare the RAM memory array: logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    // 2. Implement write (wr_ptr) and read (rd_ptr) pointers.
    // 3. Implement synchronous registered read on rd_data when rd_en is asserted.
    // 4. Implement an occupancy counter.
    // 5. Calculate flags: empty, full, almost_empty, almost_full.
    // 6. Handle simultaneous read and write.

    assign full         = (occupancy == DEPTH);
    assign almost_full  = (occupancy >= ALMOST_FULL_THRESH);
    assign empty        = (occupancy == 0);
    assign almost_empty = (occupancy <= ALMOST_EMPTY_THRESH);
    assign valid_rd = (rd_en && !empty);
    assign valid_wr = (wr_en && !full);
    //read block
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin  //reset
            rd_ptr <= '0;
        end
        else begin
            if (valid_rd) begin
                rd_data <= mem[rd_ptr]; //read the data
                rd_ptr <= rd_ptr + 1'b1;
            end
        end
    end
    //write block
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= '0;      
        end 
        else begin
            if (valid_wr) begin
                mem[wr_ptr] <= wr_data;
                wr_ptr <= wr_ptr + 1'b1;
            end
        end
    end
    //simultaneous read and write block
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            occupancy <= '0;
        end
        else begin
            case ({valid_rd, valid_wr}) 
                2'b10: occupancy <= occupancy - 1'b1;  //read only
                2'b01: occupancy <= occupancy + 1'b1;  //write only
                default: occupancy <= occupancy;
            endcase
        end
    end             
            
endmodule

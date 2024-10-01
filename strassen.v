`timescale 1ns / 1ps

module strassen_2x2(
    input clk,  // Clock signal
    input rst,  // Reset signal
    input [31:0] A11, A12, A21, A22,  // Input 2x2 matrix A
    input [31:0] B11, B12, B21, B22,  // Input 2x2 matrix B
    output reg [31:0] C11, C12, C21, C22  // Output 2x2 matrix C = A * B
);

    // Intermediate signals for matrix operations
    reg [31:0] M1, M2, M3, M4, M5, M6, M7;
    reg [31:0] S1, S2, S3, S4, S5, S6, S7;
    reg [31:0] T1, T5, T6;

    // Pipeline stages registers
    reg [31:0] stage1_M1, stage1_M2, stage1_M3, stage1_M4, stage1_M5, stage1_M6, stage1_M7;
    reg [31:0] stage2_C11, stage2_C12, stage2_C21, stage2_C22;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers to 0
            M1 <= 32'b0;
            M2 <= 32'b0;
            M3 <= 32'b0;
            M4 <= 32'b0;
            M5 <= 32'b0;
            M6 <= 32'b0;
            M7 <= 32'b0;
            C11 <= 32'b0;
            C12 <= 32'b0;
            C21 <= 32'b0;
            C22 <= 32'b0;
        end else begin
            // Stage 1: Compute intermediate sums and differences (S1 to S7)
            S1 <= A11 + A22;
            T1 <= B11 + B22;
            S2 <= A21 + A22;
            S3 <= B12 - B22;
            S4 <= B21 - B11;
            S5 <= A11 + A12;
            S6 <= A21 - A11;
            T5 <= B11 + B12;
            S7 <= A12 - A22;
            T6 <= B21 + B22;
            
            // Compute M1 to M7 using the Strassen formulas
            M1 <= S1 * T1;
            M2 <= S2 * B11;
            M3 <= A11 * S3;
            M4 <= A22 * S4;
            M5 <= S5 * B22;
            M6 <= S6 * T5;
            M7 <= S7 * T6;

            // Stage 2: Compute the final matrix C using the results from Stage 1
            C11 <= M1 + M4 - M5 + M7;
            C12 <= M3 + M5;
            C21 <= M2 + M4;
            C22 <= M1 - M2 + M3 + M6;
        end
    end

endmodule

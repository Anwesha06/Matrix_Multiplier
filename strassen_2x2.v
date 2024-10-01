`timescale 1ns / 1ps

`timescale 1ns / 1ps

module strassen_2x2(
    input [31:0] A11, A12, A21, A22,  // Input 2x2 matrix A
    input [31:0] B11, B12, B21, B22,  // Input 2x2 matrix B
    input clk,
    output reg [31:0] C11, C12, C21, C22  // Output 2x2 matrix C = A * B
);
    // Intermediate signals for matrix operations
    wire [31:0] M1, M2, M3, M4, M5, M6, M7;
    wire [31:0] S1, S2, S3, S4, S5, S6, S7, S8, S9, S10;
    wire [31:0] T1, T2, T3, T4, T5, T6, T7, T8, T9, T10;

    // Sum and difference matrices
    matrix_add add1(.a11(A11), .a12(0), .a21(0), .a22(B11), .b11(A22), .b12(0), .b21(0), .b22(B22),
                    .c11(S1), .c12(), .c21(), .c22(T1));

    matrix_add add2(.a11(A21), .a12(0), .a21(0), .a22(0), .b11(A22), .b12(0), .b21(0), .b22(0),
                    .c11(S2), .c12(), .c21(), .c22());

    matrix_sub sub1(.a11(B12), .a12(0), .a21(0), .a22(B22), .b11(B22), .b12(0), .b21(0), .b22(0),
                    .c11(S3), .c12(), .c21(), .c22());

    matrix_sub sub2(.a11(B21), .a12(0), .a21(0), .a22(B11), .b11(B11), .b12(0), .b21(0), .b22(0),
                    .c11(S4), .c12(), .c21(), .c22());

    matrix_add add3(.a11(A11), .a12(0), .a21(B11), .a22(B21), .b11(A12), .b12(0), .b21(B12), .b22(B22),
                    .c11(S5), .c12(), .c21(T5), .c22(T6));

    matrix_sub sub3(.a11(A21), .a12(0), .a21(0), .a22(0), .b11(A11), .b12(0), .b21(0), .b22(0),
                    .c11(S6), .c12(), .c21(), .c22());
                                        
    matrix_sub sub4(.a11(A12), .a12(0), .a21(0), .a22(0), .b11(A22), .b12(0), .b21(0), .b22(0),
                    .c11(S7), .c12(), .c21(), .c22());

    // Calculate M1 to M7 using the Strassen formulas
    assign M1 = S1 * T1;
    assign M2 = S2 * B11;
    assign M3 = A11 * S3;
    assign M4 = A22 * S4;
    assign M5 = S5 * B22;
    assign M6 = S6 * T5;
    assign M7 = S7 * T6;

    // Compute the final result matrix C
    always @(posedge clk) begin
    C11 <= M1 + M4 - M5 + M7;
    C12 <= M3 + M5;
    C21 <= M2 + M4;
    C22 <= M1 - M2 + M3 + M6;
    end
endmodule

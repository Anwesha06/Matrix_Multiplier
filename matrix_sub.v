`timescale 1ns / 1ps

module matrix_sub(
    input [31:0] a11, a12, a21, a22,  // 2x2 matrix A
    input [31:0] b11, b12, b21, b22,  // 2x2 matrix B
    output [31:0] c11, c12, c21, c22  // Resultant 2x2 matrix C = A - B
);
    assign c11 = a11 - b11;
    assign c12 = a12 - b12;
    assign c21 = a21 - b21;
    assign c22 = a22 - b22;
endmodule

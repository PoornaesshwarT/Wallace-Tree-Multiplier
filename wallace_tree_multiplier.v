module logic2(
    input  [3:0] a,
    input  [3:0] b,
    input        enable,
    output [7:0] p
);

    // Operand isolation
    wire [3:0] a_gated;
    wire [3:0] b_gated;

    assign a_gated = enable ? a : 4'b0000;
    assign b_gated = enable ? b : 4'b0000;

    // Partial Products
    wire pp [3:0][3:0];

    genvar i, j;

    generate
        for (i = 0; i < 4; i = i + 1) begin : GEN_ROW
            for (j = 0; j < 4; j = j + 1) begin : GEN_COL
                assign pp[i][j] = a_gated[i] & b_gated[j];
            end
        end
    endgenerate

    // --------------------------------
    // Wallace Tree Reduction
    // --------------------------------

    // Column 0
    assign p[0] = pp[0][0];

    // Column 1
    wire s_c1, c_c1;

    Half_adder HA_c1 (
        pp[1][0],
        pp[0][1],
        s_c1,
        c_c1
    );

    assign p[1] = s_c1;

    // Column 2
    wire s1_c2, c1_c2;
    wire s2_c2, c2_c2;

    full_adder FA_c2 (
        pp[2][0],
        pp[1][1],
        pp[0][2],
        s1_c2,
        c1_c2
    );

    Half_adder HA_c2 (
        s1_c2,
        c_c1,
        s2_c2,
        c2_c2
    );

    assign p[2] = s2_c2;

    // Column 3
    wire s1_c3, c1_c3;
    wire s2_c3, c2_c3;
    wire s3_c3, c3_c3;

    full_adder FA1_c3 (
        pp[3][0],
        pp[2][1],
        pp[1][2],
        s1_c3,
        c1_c3
    );

    full_adder FA2_c3 (
        s1_c3,
        pp[0][3],
        c1_c2,
        s2_c3,
        c2_c3
    );

    Half_adder HA_c3 (
        s2_c3,
        c2_c2,
        s3_c3,
        c3_c3
    );

    assign p[3] = s3_c3;

    // Column 4
    wire s1_c4, c1_c4;
    wire s2_c4, c2_c4;
    wire s3_c4, c3_c4;

    full_adder FA1_c4 (
        pp[3][1],
        pp[2][2],
        pp[1][3],
        s1_c4,
        c1_c4
    );

    full_adder FA2_c4 (
        s1_c4,
        c1_c3,
        c2_c3,
        s2_c4,
        c2_c4
    );

    Half_adder HA_c4 (
        s2_c4,
        c3_c3,
        s3_c4,
        c3_c4
    );

    assign p[4] = s3_c4;

    // Column 5
    wire s1_c5, c1_c5;
    wire s2_c5, c2_c5;

    full_adder FA1_c5 (
        pp[3][2],
        pp[2][3],
        c1_c4,
        s1_c5,
        c1_c5
    );

    full_adder FA2_c5 (
        s1_c5,
        c2_c4,
        c3_c4,
        s2_c5,
        c2_c5
    );

    assign p[5] = s2_c5;

    // Column 6
    wire s1_c6, c1_c6;

    full_adder FA1_c6 (
        pp[3][3],
        c1_c5,
        c2_c5,
        s1_c6,
        c1_c6
    );

    assign p[6] = s1_c6;

    // Column 7
    assign p[7] = c1_c6;

endmodule
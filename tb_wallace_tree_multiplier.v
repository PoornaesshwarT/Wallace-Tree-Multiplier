`timescale 1ns/1ps

module tb_wallace_tree_multiplier;

    reg        enable;
    reg  [3:0] a;
    reg  [3:0] b;
    wire [7:0] p;

    // Instantiate DUT
    logic2 uut (
        .enable(enable),
        .a(a),
        .b(b),
        .p(p)
    );

    task test_case;
        input [3:0] test_a;
        input [3:0] test_b;
        input       test_enable;
        input [7:0] expected;

        begin
            enable = test_enable;
            a = test_a;
            b = test_b;

            #10;

            if (p === expected)
                $display(
                    "PASS: enable=%b, a=%d, b=%d, p=%d",
                    enable, a, b, p
                );
            else
                $display(
                    "FAIL: enable=%b, a=%d, b=%d, expected=%d, got=%d",
                    enable, a, b, expected, p
                );
        end
    endtask

    initial begin

        // Operand isolation test
        test_case(4'd5,  4'd3,  1'b0, 8'd0);

        // Normal multiplication tests
        test_case(4'd3,  4'd4,  1'b1, 8'd12);
        test_case(4'd7,  4'd2,  1'b1, 8'd14);
        test_case(4'd9,  4'd6,  1'b1, 8'd54);
        test_case(4'd15, 4'd15, 1'b1, 8'd225);

        $display("---------------------------------------");
        $display("Wallace Tree Multiplier Test Complete");
        $display("---------------------------------------");

        $finish;
    end

endmodule
`timescale 1ns/1ps
// Directed verification for BCD digits 0 through 9.
// Inputs 10 through 15 are treated as don't-care conditions, so they are not asserted.
module tb_bcd_7segment;
    reg w, x, y, z;
    wire [3:0] select;
    wire a, b, c, d, e, f, g;
    integer digit;
    reg [6:0] expected;

    bcd_7segment dut (
        .w(w), .x(x), .y(y), .z(z),
        .select(select), .a(a), .b(b), .c(c), .d(d),
        .e(e), .f(f), .g(g)
    );

    function [6:0] expected_segments;
        input [3:0] bcd;
        begin
            case (bcd)
                4'd0: expected_segments = 7'b0000001;
                4'd1: expected_segments = 7'b1001111;
                4'd2: expected_segments = 7'b0010010;
                4'd3: expected_segments = 7'b0000110;
                4'd4: expected_segments = 7'b1001100;
                4'd5: expected_segments = 7'b0100100;
                4'd6: expected_segments = 7'b0100000;
                4'd7: expected_segments = 7'b0001111;
                4'd8: expected_segments = 7'b0000000;
                4'd9: expected_segments = 7'b0000100;
                default: expected_segments = 7'bxxxxxxx;
            endcase
        end
    endfunction

    initial begin
        for (digit = 0; digit <= 9; digit = digit + 1) begin
            {w, x, y, z} = digit[3:0];
            expected = expected_segments(digit[3:0]);
            #1;
            if ({a, b, c, d, e, f, g} !== expected)
                $fatal(1, "FAIL BCD=%0d: segments=%b expected=%b",
                       digit, {a, b, c, d, e, f, g}, expected);
            if (select !== 4'b1110)
                $fatal(1, "FAIL BCD=%0d: anode select=%b", digit, select);
        end
        $display("PASS: All 10 BCD digits and anode select verified.");
        $finish;
    end
endmodule

// Combinational BCD-to-7-segment decoder for the Blackboard FPGA.
// Active-low segment outputs for the Blackboard FPGA's common-anode display.
// BCD inputs greater than 9 were designated don't-care input combinations.
module bcd_7segment(
    input  w, x, y, z,           // 4-bit BCD input
    output [3:0] select,         // select signal for FPGA 7-seg
    output a, b, c, d, e, f, g   // segment outputs (active-low)
);

assign select = 4'b1110;  // enable rightmost 7-seg (common-anode)

// ---- 7-segment output equations (active-low) ----
assign a = (~w & ~x & ~y & z) | (x & ~y & ~z);
assign b = (x & ~y & z) | (x & y & ~z);
assign c = (~x & y & ~z);
assign d = (~w & ~x & ~y & z) | (x & ~y & ~z) | (x & y & z);
assign e = (z | (x & ~y));
assign f = (~x & y) | (y & z) | (~w & ~x & z);
assign g = (~w & ~x & ~y) | (x & y & z);

endmodule
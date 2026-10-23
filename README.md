# BCD-to-7-Segment Decoder — FPGA & Logisim

**Verilog RTL · combinational logic · Boolean minimization · Blackboard FPGA · Vivado**

A **4-bit binary-coded decimal (BCD) to 7-segment display decoder** built for a Digital Systems laboratory. The circuit drives one digit of the Blackboard FPGA's common-anode 7-segment display. It uses minimized Boolean expressions to translate an input from **0 to 9** into **seven active-low segment outputs**.

The repository includes the original Verilog implementation, FPGA pin constraints, an accompanying Logisim circuit, and a directed simulation testbench.

## Architecture

```text
Blackboard switches SW3..SW0
          │
          │ w x y z (4-bit BCD)
          ▼
 ┌───────────────────────┐
 │ Combinational decoder │
 │ seven Boolean outputs │
 └──────────┬────────────┘
            │ a b c d e f g (active LOW)
            ▼
     Seven-segment display
     rightmost digit only
  select[3:0] = 4'b1110
```

No clock is required; the output is purely combinational and changes with the switches.

## Board interface

| Signal | Source or destination | Meaning |
| --- | --- | --- |
| `w`, `x`, `y`, `z` | SW3, SW2, SW1, SW0 | BCD inputs, with `w` the MSB |
| `a`–`g` | SSEG_CA–SSEG_CG | Segment cathodes; **0 = ON**, **1 = OFF** |
| `select[3:0]` | SSEG_AN3–SSEG_AN0 | Digit enables; `1110` selects rightmost digit |

The display is **common-anode**. The original design intentionally enables only one digit. Multiplexing all four digits would require additional scanning logic and is not implemented.

## Expected behavior

The table uses segment order **a b c d e f g** and active-low outputs:

| BCD input | Digit | Segments |
| --- | ---: | --- |
| `0000` | 0 | `0000001` |
| `0001` | 1 | `1001111` |
| `0010` | 2 | `0010010` |
| `0011` | 3 | `0000110` |
| `0100` | 4 | `1001100` |
| `0101` | 5 | `0100100` |
| `0110` | 6 | `0100000` |
| `0111` | 7 | `0001111` |
| `1000` | 8 | `0000000` |
| `1001` | 9 | `0000100` |

BCD values **10–15** were specified as **don't-care cases** in the laboratory exercise. The supplied Verilog equations still produce deterministic signals for those inputs, but no digit behavior is promised for them.

## Files

```text
rtl/bcd_7segment.v               # Original data-flow RTL, personal ID removed
constraints/blackboard_7seg.xdc  # FPGA switches, anodes and segments
logisim/bcd_7segment.circ        # Original Logisim schematic, identifying ID removed
tests/tb_bcd_7segment.v          # Directed testbench for digits 0–9
README.md
```

## Simulate

With **Icarus Verilog** installed:

```bash
iverilog -g2012 -s tb_bcd_7segment -o bcd_tb rtl/bcd_7segment.v tests/tb_bcd_7segment.v
vvp bcd_tb
```

The testbench checks every valid BCD input against an independently specified active-low display truth table and confirms that the anode select is always `1110`.

**Verification note:** The original Boolean expressions were independently evaluated against all ten expected digit patterns. The new Verilog testbench is included for reproducibility but has **not been executed in an HDL simulator in this review environment**.

## Run on the Blackboard FPGA

1. Create a Vivado RTL project for the **exact FPGA device on your Blackboard revision**.
2. Add `rtl/bcd_7segment.v`; set `lab3_7segment` as the top module.
3. Add `constraints/blackboard_7seg.xdc`, checking its `PACKAGE_PIN` assignments against your board.
4. Run synthesis, implementation, and bitstream generation.
5. Program the board; use switches SW0–SW3 to select digits 0–9.

The archive contained a generated Vivado bitstream, but it is not committed: it is build output tied to the target hardware and development environment. Rebuilding from source is preferable.

## Logisim model

Open `logisim/bcd_7segment.circ` in a compatible Logisim release (the file declares **Logisim 2.7.1**). It preserves the original gate-level schematic and seven-segment display configuration used during the pre-lab design stage.

## Design notes and limitations

- The module uses **data-flow (continuous-assignment) modeling** of combinational logic.
- The seven output equations are specific to an **active-low** common-anode display.
- The implementation drives **one digit only**; it has no clocked scanning or decimal-point logic.
- All ten supported digits match the standard active-low patterns, based on an independent Boolean-expression check.
- The testbench and Verilog sources are committed as reproducible artifacts; **live FPGA results and timing measurements are not claimed**.
- Course lab manuals are not redistributed here. This repository publishes the project implementation and original documentation rather than the instructors' copyrighted handouts.

### Related project

[FPGA-Based Arithmetic Display System](https://github.com/Omar-Alhalawani/FPGA-Based-Arithmetic-Display-System) — a separate FPGA project using registered 8-bit operands, synchronized buttons, and LED outputs.
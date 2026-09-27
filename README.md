# ChipUp — DVCon India 2026 Design Contest

**Task-Aware Object Selection Using an FPGA-Based Hardware Accelerator**

Team ChipUp | Team ID 188 | Chennai Institute of Technology, Anna University

**Reshmi K · Rosiny C A · Varsha S**

🏆 Top 12 finalist team, DVCon India 2026 Design Contest — Fellowship recipient

---

## About

This project implements a custom hardware accelerator, integrated into the
indigenously developed **VEGA RISC-V SoC** (CDAC Trivandrum), for a
task-aware object selection pipeline.

Object detection and task-relevance scoring (YOLOv8) identify the top 5
candidate objects in a scene. This accelerator — built from scratch in
Verilog and integrated via AXI4 — takes those 5 confidence/weight pairs,
computes the final ranking directly in hardware, and selects the best
(primary) and second-best (alternative) match, with deterministic,
low-latency execution.

## What's inside

- **`DVCon_SoC_SRC/ACCELERATOR_IP/`** — the accelerator itself
  (`Accelerator_Top.v`, `axi_master_interface.v`, `axi_slave_interface.v`,
  `top2_comparator.v`)
- **`Application/`** — firmware (`main.c`) driving the accelerator through
  5 verified test cases
- **`RESULTS_PROOF/`** — waveform screenshots and synthesis reports
  (utilization, timing, power, DRC)
- **Full write-up** — architecture, register map, bug-fix history,
  waveform walkthrough, and synthesis results, included in the project
  report

## Highlights

- Hardware/software co-design: detection + scoring in software, final
  decision-making in a dedicated AXI4 hardware engine
- 5/5 test cases verified bit-accurate against hand-calculated expected
  scores, covering every decision path in the design
- Clean synthesis: setup timing met (WNS +4.060 ns), and the accelerator
  adds under 1% LUT/register/DSP overhead to the baseline SoC
- Verified end-to-end in AMD Vivado (XSim), targeting the Digilent
  Genesys-2 FPGA board

## Tools

AMD Vivado 2026.1 (Simulator + Synthesis), Digilent Genesys-2 (xc7k325t)

## Journey

Built over 6 months (Feb–Aug 2026) as part of the DVCon India 2026 Design
Contest — from an initial software prototype through full AXI4 hardware
integration, debugging, verification, and synthesis. A huge thank-you to
our mentors, seniors, and Chennai Institute of Technology for the
guidance and support throughout.

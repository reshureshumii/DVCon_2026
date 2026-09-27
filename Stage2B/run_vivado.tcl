# ==========================================================
# Vivado TCL Script
# Task-Aware Object Selection Using FPGA-Based
# Two-Stage Approximation
# ==========================================================
read_verilog rtl/top_module.v
read_verilog rtl/top2_comparator.v
read_verilog rtl/axi_slave_interface.v
read_verilog rtl/axi_master_interface.v
synth_design -top top_module -part xc7k70tfbv676-1
report_utilization -file results/utilization_report.txt
exit
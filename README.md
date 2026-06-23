# AMBA AHB2APB Bridge Design using Verilog HDL

## Project Overview

This project focuses on the design and verification of an **AMBA AHB to APB Bridge** using **Verilog HDL**.

The bridge acts as an interface between the high-performance **AMBA AHB (Advanced High-performance Bus)** and the low-power **AMBA APB (Advanced Peripheral Bus)**. It converts AHB transactions into APB-compatible transactions to enable communication between high-speed processors and peripheral devices.

The design includes an **AHB Slave Interface**, an **APB Controller**, and a **Finite State Machine (FSM)** based control mechanism for managing APB transfer operations.

## Objectives

- Design an RTL-based AHB to APB bridge using Verilog HDL.
- Implement FSM-based APB transaction control.
- Verify the functionality using simulation testbench.
- Perform synthesis analysis and evaluate hardware utilization.

## Features

- AMBA AHB Slave Interface
- AMBA APB Master Controller
- FSM based APB transfer sequencing
- Support for Read and Write transactions
- RTL simulation and waveform verification
- FPGA synthesis analysis using Vivado
# Synchronous FIFO

This project implements a **Synchronous FIFO** (First In First Out) buffer with configurable data width and depth, designed using SystemVerilog. The FIFO supports basic operations such as writing data, reading data, checking for full and empty conditions, and handling overflow/underflow situations.

## Table of Contents

- [Parameters](#parameters)
- [Ports](#ports)
- [Testbench Overview](#testbench-overview)
- [Coverage and Assertions](#coverage-and-assertions)
- [Steps to Run](#steps-to-run)
- [Verification Plan](#verification-plan)
- [Submission Files](#submission-files)

## Parameters

- **FIFO_WIDTH**: Data input/output and memory word width (default: 16 bits)
- **FIFO_DEPTH**: Memory depth (default: 8 words)

## Ports

| Port      | Direction | Function                                                                 |
|-----------|-----------|--------------------------------------------------------------------------|
| `data_in` | Input      | Write Data: The input data bus for writing into the FIFO.                |
| `wr_en`   | Input      | Write Enable: Enables writing data into the FIFO if it's not full.       |
| `rd_en`   | Input      | Read Enable: Enables reading data from the FIFO if it's not empty.       |
| `clk`     | Input      | Clock signal for synchronous operations.                                |
| `rst_n`   | Input      | Active low asynchronous reset.                                          |
| `data_out`| Output     | Read Data: The output data bus when reading from the FIFO.               |
| `full`    | Output     | Full: Indicates if the FIFO is full, rejecting any further writes.       |
| `empty`   | Output     | Empty: Indicates if the FIFO is empty, preventing further reads.         |
| `almostfull` | Output  | Almost Full: Indicates when FIFO is almost full.                         |
| `almostempty` | Output | Almost Empty: Indicates when FIFO is almost empty.                       |
| `overflow`| Output     | Overflow: Signals that a write was attempted when FIFO was full.         |
| `underflow`| Output    | Underflow: Signals that a read was attempted when FIFO was empty.        |
| `wr_ack`  | Output     | Write Acknowledge: Confirms a successful write into the FIFO.            |

## Testbench Overview

The testbench generates the clock signal and passes the interface to the DUT (Design Under Test) and monitor modules. The DUT is reset, and inputs are randomized. A signal named `test_finished` is asserted once the test completes.

### Testbench Flow

- The **monitor module**:
  1. Samples the input and output data at each clock cycle.
  2. Collects coverage data to ensure all combinations of write/read operations are exercised.
  3. Tracks error counters and checks for violations like overflows, underflows, and data mismatches.
  4. Displays the result summary after test completion.

## Coverage and Assertions

Assertions are added to check the flags of the FIFO (`full`, `empty`, etc.) as well as the data output signal (`data_out`). Additional checks ensure proper functioning of FIFO during edge cases like concurrent reads and writes, and out-of-bound operations.

### Coverage

- Cross-coverage of signals:
  - Write enable (`wr_en`)
  - Read enable (`rd_en`)
  - Output signals (`data_out`, `full`, `empty`, etc.)

## Steps to Run

1. Adjust the FIFO design to use an interface and change the file extension to `.sv`.
2. Create the following SystemVerilog packages and files:
   - **FIFO_Transaction**: Contains all input/output signals and data variables for transactions.
   - **FIFO_Coverage**: Tracks coverage data of read/write enable signals and checks correctness.
   - **FIFO_Scoreboard**: Verifies correctness of the FIFO outputs, comparing them to expected values.
3. Add necessary assertions in the design to monitor `full`, `empty`, and other output conditions.
4. Compile the design using the provided `run.do` file in ModelSim or QuestaSim.
5. Review the coverage report and check for 100% functional and sequential domain coverage.

## Verification Plan

The verification plan includes:
- **Functionality checks**: Ensure the FIFO meets the design requirements.
- **Coverage**: All combinations of reads/writes are tested.
- **Assertions**: Verify the FIFO behaves as expected, particularly in edge cases (e.g., full and empty conditions).
- **Error tracking**: Log errors related to overflow/underflow conditions and data mismatches.


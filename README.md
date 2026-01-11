# VELSYNC_VCD_04
This project implements a UART Receiver using Verilog HDL. It receives serial data, synchronizes the input, detects the start bit, samples 8-bit data at the selected baud rate, checks the stop bit, and outputs valid data with a one-cycle flag. A framing error is indicated for invalid stop bits.

# ✨ Features

*8-bit UART Receiver

* Configurable clock frequency and baud rate

* Start bit detection and mid-bit sampling

* Stop bit validation

* Framing error detection

* Fully synthesizable RTL

* Compatible with Xilinx ISE and Vivado

* Verified using ISim testbench

# 🧩 Module Interface
# Inputs

* clk : System clock

* rst : Active-high synchronous reset

* rx_serial : UART serial input

# Outputs

* rx_data[7:0] : Received 8-bit data

* rx_data_valid : One-clock pulse indicating valid data

* framing_error : Indicates invalid stop bit

# ⚙️ Parameters

* CLK_FREQ_HZ : System clock frequency (default: 50 MHz)

* BAUD_RATE : UART baud rate (default: 9600)

# 🧪 Simulation & Verification

* Testbench drives rx_serial with a valid UART frame

* Verifies received data using rx_data_valid

* Confirms framing error behavior

* Simulated successfully in ISim

# 🚀 How to Run

* Open Xilinx ISE or Vivado

* Add uart_rx.v and uart_tb.v

* Set uart_tb as simulation top

* Run behavioral simulation

# 📂 Files

* uart_rx.v – UART Receiver RTL

* uart_tb.v – Testbench for verification

* README.md – Project documentation

# 📖 Applications

* FPGA serial communication

* Xilinx ISE / Vivado (any one)
  
* UART-based debugging interfaces

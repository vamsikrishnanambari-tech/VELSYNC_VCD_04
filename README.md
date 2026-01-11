# VELSYNC_VCD_04
This project implements a UART Receiver using Verilog HDL. It receives serial data, synchronizes the input, detects the start bit, samples 8-bit data at the selected baud rate, checks the stop bit, and outputs valid data with a one-cycle flag. A framing error is indicated for invalid stop bits.

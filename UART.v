`timescale 1ns / 1ps

module uart_rx #(
    parameter integer CLK_FREQ_HZ = 50000000,
    parameter integer BAUD_RATE   = 9600
)(
    input  wire       clk,
    input  wire       rst,

    input  wire       rx_serial,

    output reg [7:0]  rx_data,
    output reg        rx_data_valid,
    output reg        framing_error
);

    localparam integer BAUD_DIV = CLK_FREQ_HZ / BAUD_RATE;

    reg [$clog2(BAUD_DIV)-1:0] baud_cnt;
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;
    reg rx_sync1, rx_sync2;
    reg busy;

    // -------------------------------
    // RX input synchronizer
    // -------------------------------
    always @(posedge clk) begin
        rx_sync1 <= rx_serial;
        rx_sync2 <= rx_sync1;
    end

    // -------------------------------
    // UART RX logic
    // -------------------------------
    always @(posedge clk) begin
        if (rst) begin
            baud_cnt      <= 0;
            bit_cnt       <= 0;
            busy          <= 0;
            shift_reg     <= 0;
            rx_data       <= 0;
            rx_data_valid <= 0;
            framing_error <= 0;
        end else begin
            rx_data_valid <= 1'b0;   // default

            if (!busy) begin
                // Detect start bit
                if (rx_sync2 == 1'b0) begin
                    busy     <= 1'b1;
                    baud_cnt <= BAUD_DIV / 2;  // middle of start bit
                    bit_cnt  <= 0;
                end
            end else begin
                if (baud_cnt == BAUD_DIV-1) begin
                    baud_cnt <= 0;

                    if (bit_cnt < 8) begin
                        // Sample data bits
                        shift_reg[bit_cnt] <= rx_sync2;
                        bit_cnt <= bit_cnt + 1;
                    end else begin
                        // Sample stop bit
                        busy <= 1'b0;

                        if (rx_sync2 == 1'b1) begin
                            rx_data       <= shift_reg;
                            rx_data_valid <= 1'b1;
                            framing_error <= 1'b0;
                        end else begin
                            framing_error <= 1'b1;
                        end
                    end
                end else begin
                    baud_cnt <= baud_cnt + 1;
                end
            end
        end
    end

endmodule

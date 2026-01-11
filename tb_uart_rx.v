`timescale 1ns / 1ps

module tb_uart_rx;

    // -------------------------------------------------
    // Parameters
    // -------------------------------------------------
    localparam integer CLK_FREQ_HZ = 50000000;
    localparam integer BAUD_RATE   = 9600;
    localparam integer BAUD_PERIOD = 1000000000 / BAUD_RATE; // ns

    // -------------------------------------------------
    // Signals
    // -------------------------------------------------
    reg clk = 0;
    reg rst;
    reg rx_serial;

    wire [7:0] rx_data;
    wire rx_data_valid;
    wire framing_error;

    // -------------------------------------------------
    // Clock generation (50 MHz)
    // -------------------------------------------------
    always #10 clk = ~clk;

    // -------------------------------------------------
    // DUT
    // -------------------------------------------------
    uart_rx #(
        .CLK_FREQ_HZ(CLK_FREQ_HZ),
        .BAUD_RATE(BAUD_RATE)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .rx_serial(rx_serial),
        .rx_data(rx_data),
        .rx_data_valid(rx_data_valid),
        .framing_error(framing_error)
    );

    // -------------------------------------------------
    // Test sequence
    // -------------------------------------------------
    initial begin
        $display("UART RX Testbench Started");

        // Initial conditions
        rst       = 1'b1;
        rx_serial = 1'b1; // idle

        #200;
        rst = 1'b0;

        // Wait after reset
        repeat (5) @(posedge clk);

        // Send test bytes
        send_uart_byte(8'h55);
        send_uart_byte(8'hA3);
        send_uart_byte(8'hF0);

        #200000;
        $display("UART RX Testbench Completed");
        $finish;
    end

    // -------------------------------------------------
    // UART transmit task (drives rx_serial)
    // -------------------------------------------------
    task send_uart_byte(input [7:0] data);
        integer i;
        begin
            // Start bit
            rx_serial = 1'b0;
            #(BAUD_PERIOD);

            // Data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx_serial = data[i];
                #(BAUD_PERIOD);
            end

            // Stop bit
            rx_serial = 1'b1;
            #(BAUD_PERIOD);

            // Wait for RX to process
            wait (rx_data_valid);

            // Check received data
            if (rx_data !== data) begin
                $display("ERROR: Sent %h, Received %h", data, rx_data);
                $fatal;
            end else begin
                $display("PASS: %h received correctly", data);
            end

            if (framing_error) begin
                $display("ERROR: Framing error detected");
                $fatal;
            end
        end
    endtask

endmodule

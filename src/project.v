/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */


`default_nettype none

module tt_um_sowmya_hamming_top ( 
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Extract data bits from input (4 LSBs)
    wire [3:0] data_in = ui_in[3:0];

    // Encoded output bits (7 bits for Hamming(7,4))
    wire [6:0] encoded_out;

    // Map data bits to encoded_out positions:
    assign encoded_out[6:4] = data_in[3:1];
    assign encoded_out[2]   = data_in[0];

    // Calculate parity bits
    assign encoded_out[0] = encoded_out[6] ^ encoded_out[4] ^ encoded_out[2];
    assign encoded_out[1] = encoded_out[6] ^ encoded_out[5] ^ encoded_out[2];
    assign encoded_out[3] = encoded_out[6] ^ encoded_out[5] ^ encoded_out[4];

    // Assign outputs
    assign uo_out[6:0] = encoded_out;
    assign uo_out[7]   = 1'b0;  // explicitly assign the MSB to zero

    // Assign zero to unused IO ports as per your request
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Silence unused input warnings by referencing them (optional)
    wire unused_ena = ena;
    wire unused_clk = clk;
    wire unused_rst_n = rst_n;
    wire unused_uio_in = |uio_in;  // OR reduce all bits

endmodule



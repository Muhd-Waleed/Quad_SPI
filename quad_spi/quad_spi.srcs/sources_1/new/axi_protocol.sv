`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/11/2022 04:59:50 PM
// Design Name: 
// Module Name: axi_protocol
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axi_protocol(
    inout logic spi_io0_i,
    inout logic spi_io1_i,
    inout logic spi_io2_i,
    inout logic spi_io3_i,
    output logic spi_ss_o,
    output logic spi_clk_o,

    input logic read,
    input logic write,
    // output logic compare,
    output logic led,
    input clk,
    input rst_n
);

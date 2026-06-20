`ifndef SPI_INTERFACE
`define SPI_INTERFACE
interface spi_interface(input logic clk, rst);
    logic sck;
    logic mosi;
    logic miso;
endinterface
`endif
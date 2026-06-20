`ifndef WISHBONE_INTERFACE
`define WISHBONE_INTERFACE
interface wishbone_interface (input logic clk, logic rst);
    logic       cyc;
    logic       stb;
    logic [1:0] adr; 
    logic       we;
    logic [7:0] dat_m;
    logic [7:0] dat_s;
    logic       ack;
    logic       inta;
endinterface
`endif
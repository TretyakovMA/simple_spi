`ifndef SIMPLE_SPI_SCOREBOARD
`define SIMPLE_SPI_SCOREBOARD
class simple_spi_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(simple_spi_scoreboard)

    `uvm_analysis_imp_decl(_SPI)
    `uvm_analysis_imp_decl(_WB)
    uvm_analysis_imp_SPI #(spi_transaction, simple_spi_scoreboard) spi_imp;
    uvm_analysis_imp_WB  #(wishbone_transaction, simple_spi_scoreboard) wb_imp;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new



    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        spi_imp = new("spi_imp", this);
        wb_imp  = new("wb_imp", this);
    endfunction: build_phase

    function void write_SPI(spi_transaction t);
        `uvm_info(get_type_name(), {"get: ", t.convert2string}, UVM_LOW)
    endfunction: write_SPI

    function void write_WB(wishbone_transaction t);
        `uvm_info(get_type_name(), {"get: ", t.convert2string}, UVM_LOW)
    endfunction: write_WB
endclass
`endif
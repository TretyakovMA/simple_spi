`ifndef SIMPLE_TEST
`define SIMPLE_TEST
class simple_test extends sequence_base_test #(
    .SEQUENCE_TYPE(configure_spe_seq),
    .SEQUENCER_TYPE(wishbone_sequencer),
    .IS_VIRTUAL_SEQUENCE(0),
    .PARENT_TYPE(base_test)
);
    `uvm_component_utils(simple_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    virtual function string get_sequencer_name();
        return "wishbone_sequencer";
    endfunction: get_sequencer_name
endclass
`endif
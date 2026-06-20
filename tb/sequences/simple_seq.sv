`ifndef SIMPLE_SEQ
`define SIMPLE_SEQ
class simple_seq extends uvm_sequence #(wishbone_transaction);
    `uvm_object_utils(simple_seq)

    function new(string name = "simple_seq");
        super.new(name);
    endfunction

    task body();
        wishbone_transaction tr;
        tr = wishbone_transaction::type_id::create("tr");
        start_item(tr);

        //assert(tr.randomize());

        tr.cyc = 1;
        tr.stb = 1;
        tr.we = 1;
        tr.adr = 0;
        tr.dat_m = 8'b0101_0000;
        
        finish_item(tr);
    endtask
endclass
`endif
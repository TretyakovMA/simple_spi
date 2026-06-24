`ifndef REG_READ_SEQ
`define REG_READ_SEQ
class reg_read_seq extends reg_base_seq;
    `uvm_object_utils(reg_read_seq)

    function new(string name = "reg_read_seq");
        super.new(name);
    endfunction: new

    task body();
        super.body();

        read_reg(reg_block_h.SPDR, status, value);
    endtask: body
endclass
`endif
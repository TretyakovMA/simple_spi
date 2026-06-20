`ifndef WISHBONE_TRANSACTION
`define WISHBONE_TRANSACTION
class wishbone_transaction extends uvm_sequence_item;
    `uvm_object_utils(wishbone_transaction)

    function new(string name = "wishbone_transaction");
		super.new(name);
	endfunction: new


    rand bit       cyc;
    rand bit       stb;
    rand bit [1:0] adr; 
    rand bit       we;
    rand bit [7:0] dat_m;

    bit [7:0]      dat_s;
    bit            ack;

    function void do_copy(uvm_object rhs);
		wishbone_transaction copied_tr;
		
		if(rhs == null)
			`uvm_fatal(get_type_name(), "Tried to copy from a null pointer")
		if(!$cast(copied_tr, rhs))
			`uvm_fatal(get_type_name(), "Tried to copy wrong type")
		
		super.do_copy(rhs);

        this.cyc   = copied_tr.cyc;
        this.stb   = copied_tr.stb;
        this.adr   = copied_tr.adr;
        this.we    = copied_tr.we;
        this.dat_m = copied_tr.dat_m;

        this.dat_s = copied_tr.dat_s;
        this.ack   = copied_tr.ack;
    endfunction: do_copy

    function wishbone_transaction clone_me();
		wishbone_transaction clone;
		uvm_object tmp;
		
		tmp = this.clone();
		$cast(clone, tmp);
		return clone;
	endfunction: clone_me

    function bit do_compare (uvm_object rhs, uvm_comparer comparer);
		wishbone_transaction compared_tr;
		bit same = 1;
		
		if(rhs == null)
			`uvm_fatal(get_type_name(), "Tried to do comparsion to a null pointer")
		if (!$cast(compared_tr, rhs)) 
            same = 0;
        

        if(this.dat_s != compared_tr.dat_s) begin
            same = 0;
            `uvm_error(get_type_name(), {"dat_s signal error:\nGet transaction:\n", compared_tr.convert2string(), "\n\nExpected:\n", this.convert2string()})
        end

        if(this.ack != compared_tr.ack) begin
            same = 0;
            `uvm_error(get_type_name(), {"ack signal error:\nGet transaction:\n", compared_tr.convert2string(), "\n\nExpected:\n", this.convert2string()})
        end

        same = super.do_compare(rhs, comparer) && same;
        return same;
    endfunction: do_compare

endclass
`endif
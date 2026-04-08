class qspi_sequence extends uvm_sequence #(qspi_item);

   `uvm_object_utils(qspi_sequence)

   function new(string name="qspi_sequence");
      super.new(name);
   endfunction

   task body();

   qspi_item tr;

   // ---------------- SPI MODE ----------------

   // Read JEDEC ID
   tr = qspi_item::type_id::create("tr");
   start_item(tr);
   tr.opcode = 8'h9F;
   tr.address = 24'h0;
   tr.write_data = 8'h00;
   tr.burst_len = 3;
   finish_item(tr);


   // Write Enable
   tr = qspi_item::type_id::create("tr");
   start_item(tr);
   tr.opcode = 8'h06;
   tr.address = 24'h0;
   tr.write_data = 8'h00;
   tr.burst_len = 0;
   finish_item(tr);


   // Page Program
   tr = qspi_item::type_id::create("tr");
   start_item(tr);
   tr.opcode = 8'h02;
   tr.address = 24'h000010;
   tr.write_data = 8'hA5;
   tr.burst_len = 1;
   finish_item(tr);


   // Wait for flash program completion ( > tPP )
   #400_000;


   // Debug: Read Status Register
   tr = qspi_item::type_id::create("tr");
   start_item(tr);
   tr.opcode = 8'h05;
   tr.address = 24'h0;
   tr.write_data = 8'h00;
   tr.burst_len = 1;
   finish_item(tr);


   // SPI Read
   tr = qspi_item::type_id::create("tr");
   start_item(tr);
   tr.opcode = 8'h03;
   tr.address = 24'h000010;
   tr.write_data = 8'h00;
   tr.burst_len = 1;
   finish_item(tr);


   // Extra safety delay
   #3_000_000;


   // ---------------- ENABLE QUAD MODE ----------------

   // Write Enable
   tr = qspi_item::type_id::create("tr");
   start_item(tr);
   tr.opcode = 8'h06;
   tr.address = 24'h0;
   tr.write_data = 8'h00;
   tr.burst_len = 0;
   finish_item(tr);


   // Write Status Register (QE = 1)
   tr = qspi_item::type_id::create("tr");
   start_item(tr);
   tr.opcode = 8'h01;
   tr.address = 24'h0;
   tr.write_data = 8'h40;   // QE bit
   tr.burst_len = 1;
   finish_item(tr);


   // Wait for status register write ( > tW )
   #2000;


   // Verify QE bit
   tr = qspi_item::type_id::create("tr");
   start_item(tr);
   tr.opcode = 8'h05;
   tr.address = 24'h0;
   tr.write_data = 8'h00;
   tr.burst_len = 1;
   finish_item(tr);


   // ---------------- QUAD MODE ----------------

   // Write Enable
   tr = qspi_item::type_id::create("tr");
   start_item(tr);
   tr.opcode = 8'h06;
   tr.address = 24'h0;
   tr.write_data = 8'h00;
   tr.burst_len = 0;
   finish_item(tr);


   // Quad Page Program
   tr = qspi_item::type_id::create("tr");
   start_item(tr);
   tr.opcode = 8'h38;
   tr.address = 24'h000020;
   tr.write_data = 8'hA5;
   tr.burst_len = 1;
   finish_item(tr);


   // Wait for quad program completion
   #400_000;


   // Quad Read
   tr = qspi_item::type_id::create("tr");
   start_item(tr);
   tr.opcode = 8'hEB;
   tr.address = 24'h000020;
   tr.write_data = 8'h00;
   tr.burst_len = 1;
   finish_item(tr);


   endtask

endclass

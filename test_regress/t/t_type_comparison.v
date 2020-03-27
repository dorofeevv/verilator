// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed into the Public Domain, for any use,
// without warranty, 2020 by Todd Strader.

module foo
   #(parameter type a_type = logic,
     parameter type b_type = int)
   ();

   initial begin
      if (type(a_type) != type(logic[7:0])) begin
         $display("%%Error: a_type is wrong");
         $stop();
      end

      if (type(b_type) != type(real)) begin
         $display("%%Error: b_type is wrong");
         $stop();
      end

      if (type(a_type) == type(logic)) begin
         $display("%%Error: a_type is the default value");
         $stop();
      end

      if (type(b_type) == type(int)) begin
         $display("%%Error: b_type is the default value");
         $stop();
      end

      if (type(a_type) == type(b_type)) begin
         $display("%%Error: a_type equals b_type");
         $stop();
      end

      $write("*-* All Finished *-*\n");
      $finish;
   end

endmodule

module t();

   foo #(
      .a_type (logic[7:0]),
      .b_type (real)) the_foo ();

   // From 6.22.1 (mostly)
   typedef bit node;        // 'bit' and 'node' are matching types
   typedef node type1;
   typedef type1 type2;     // 'type1' and 'type2' are matching types

   struct packed {int A; int B;} AB1, AB2;  // AB1, AB2 have matching types
   struct packed {int A; int B;} AB3;       // the type of AB3 does not match
                                            // the type of AB1

   typedef struct packed {int A; int B;} AB_t;
   AB_t AB4; AB_t AB5;  // AB4 and AB5 have matching types
   typedef struct packed {int A; int B;} otherAB_t;
   otherAB_t AB6;       // the type of AB6 does not match the type of AB4 or AB5

   typedef bit signed [7:0] BYTE;   // matches the byte type
   /* verilator lint_off LITENDIAN */
   typedef bit signed [0:7] ETYB;   // does not match the byte type
   /* verilator lint_on LITENDIAN */

   typedef byte MEM_BYTES [256];
   typedef bit signed [7:0] MY_MEM_BYTES [256];     // MY_MEM_BYTES matches
                                                    // MEM_BYTES
   typedef logic [1:0] [3:0] NIBBLES;
   typedef logic [7:0] MY_BYTE; // MY_BYTE and NIBBLES are not matching types
   typedef logic MD_ARY [][2:0];
   typedef logic MD_ARY_TOO [][0:2]; // Does not match MD_ARY

   typedef byte signed MY_CHAR; // MY_CHAR matches the byte type

   // TODO -- this (6.22.1 h)
   //import the_pkg::*;

   initial begin
      if (type(bit) != type(node)) $stop();
      if (type(type1) != type(type2)) $stop();
      if (type(AB1) != type(AB2)) $stop();
      if (type(AB3) == type(AB1)) $stop();
      // TODO -- the rest
      // TODO -- case equal/not equal, ===, !===
   end


endmodule
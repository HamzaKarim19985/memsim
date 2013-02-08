
with Ada.Text_IO; use Ada.Text_IO;

package body Memory.Trace is

   function Create_Trace(mem : Memory_Pointer) return Trace_Pointer is
      result : constant Trace_Pointer := new Trace_Type;
   begin
      result.mem := mem;
      return result;
   end Create_Trace;

   procedure Start(mem : in out Trace_Type) is
   begin
      if mem.mem /= null then
         Start(mem.mem.all);
         mem.time := mem.mem.time;
      end if;
   end Start;

   procedure Commit(mem    : in out Trace_Type;
                    cycles : out Time_Type) is
   begin
      if mem.mem /= null then
         Commit(mem.mem.all, cycles);
         mem.time := mem.mem.time;
      else
         cycles := 0;
      end if;
   end Commit;

   function Get_Hex(value : Address_Type) return String is
      result   : String(1 .. 16);
      left     : Address_Type := value;
      index    : Natural := 16;
      hex      : constant String := "0123456789abcdef";
   begin
      loop
         result(index) := hex(Natural(left mod 16) + 1);
         index := index - 1;
         left := left / 16;
         exit when left = 0;
      end loop;
      return result(index + 1 .. 16);
   end Get_Hex;

   procedure Read(mem      : in out Trace_Type;
                  address  : in Address_Type;
                  size     : in Positive) is

      astr : constant String := Get_Hex(address);
      sstr : constant String := Get_Hex(Address_Type(size));

   begin
      Put_Line("R" & astr & ":" & sstr);
      if mem.mem /= null then
         Read(mem.mem.all, address, size);
         mem.time := mem.mem.time;
      end if;
   end Read;

   procedure Write(mem     : in out Trace_Type;
                   address : in Address_Type;
                   size    : in Positive) is

      astr : constant String := Get_Hex(address);
      sstr : constant String := Get_Hex(Address_Type(size));

   begin
      Put_Line("W" & astr & ":" & sstr);
      if mem.mem /= null then
         Write(mem.mem.all, address, size);
         mem.time := mem.mem.time;
      end if;
   end Write;

   procedure Idle(mem      : in out Trace_Type;
                  cycles   : in Time_Type) is

      cstr : constant String := Get_Hex(Address_Type(cycles));

   begin
      Put_Line("I" & cstr);
      if mem.mem /= null then
         Idle(mem.mem.all, cycles);
         mem.time := mem.mem.time;
      end if;
   end Idle;

end Memory.Trace;

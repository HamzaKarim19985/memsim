
with Memory.RAM;     use Memory.RAM;
with Memory.Split;   use Memory.Split;
with Memory.Join;    use Memory.Join;

with Ada.Text_IO; use Ada.Text_IO;

package body Test.Split is

   procedure Run_Tests is

      ram   : constant RAM_Pointer  := Create_RAM(latency   => 100,
                                                  word_size => 8);
      mon1  : constant Monitor_Pointer := new Monitor_Type;
      mon2  : constant Monitor_Pointer := new Monitor_Type;
      join1 : constant Join_Pointer    := Create_Join;
      join2 : constant Join_Pointer    := Create_Join;
      split : Split_Pointer;

   begin

      Set_Memory(mon1.all, join1);
      Set_Memory(mon2.all, join2);
      split := Create_Split(ram, mon1, mon2, 256);

      Check(Get_Time(ram.all) = 0, "split1");
      Check(Get_Writes(ram.all) = 0, "split2");

      Read(split.all, 0, 8);
      Check(mon1.reads = 1, "split3");
      Check(mon2.reads = 0, "split4");

      Read(split.all, 256, 8);
      Check(mon1.reads = 1, "split5");
      Check(mon2.reads = 1, "split6");

      Write(split.all, 256, 8);
      Check(mon1.writes = 0, "split7");
      Check(mon2.writes = 1, "split8");

      Write(split.all, 0, 8);
      Check(mon1.writes = 1, "split9");
      Check(mon2.writes = 1, "split10");

      Idle(split.all, 10);
      Check(mon1.cycles = 10, "split11");
      Check(mon2.cycles = 10, "split12");

      Read(split.all, 252, 8);
      Check(mon1.reads = 2, "split13");
      Check(mon2.reads = 2, "split14");

      Read(split.all, Address_Type(0) - 4, 8);
Put_Line("1: " & Natural'Image(mon1.reads));
Put_Line("2: " & Natural'Image(mon2.reads));
      Check(mon1.reads = 3, "split15");
      Check(mon2.reads = 4, "split16");

      Destroy(Memory_Pointer(split));

   end Run_Tests;

end Test.Split;

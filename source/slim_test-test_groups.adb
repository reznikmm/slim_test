--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

with Slim_Test.Execution_Time;

package body Slim_Test.Test_Groups is

   procedure Insert
     (Self : in out Test_Group;
      Key  : String;
      Item : not null Test_Routine) is
   begin
      Self.Last := Self.Last + 1;
      Self.List (Self.Last) := (Key'Address, Key'Length, Item);
   end Insert;

   function Name (Self : Test_Group; Index : Positive) return String is
      subtype Slice is String (1 .. Self.List (Index).Name_Length);
      Result : Slice
        with Import, Address => Self.List (Index).Name;
   begin
      return Result;
   end Name;

   procedure Run
     (Self   : Test_Group;
      Result : out Slim_Test.Results.Result_Array) is
   begin
      for J in Self.List'Range loop
         declare
            use type Slim_Test.Execution_Time.Time;
            Item  renames Self.List (J);
            Start : constant Slim_Test.Execution_Time.Time :=
              Slim_Test.Execution_Time.Clock;
         begin
            Item.Routine (Result (J));

            Slim_Test.Results.Set_Execution_Time
              (Result (J),
               Slim_Test.Execution_Time.Clock - Start);
         end;
      end loop;
   end Run;

end Slim_Test.Test_Groups;

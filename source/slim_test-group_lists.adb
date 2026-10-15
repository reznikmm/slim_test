--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

package body Slim_Test.Group_Lists is

   function First_Index
     (Self : Group_List; Index : Positive) return Positive
   is
      Result : Positive := 1;
   begin
      for J in 1 .. Index - 1 loop
         Result := Result + Self.List (J).Group.Length;
      end loop;

      return Result;
   end First_Index;

   function Group_Name (Self : Group_List; Index : Positive) return String is
      subtype Slice is String (1 .. Self.List (Index).Name_Length);
      Result : Slice
        with Import, Address => Self.List (Index).Name;
   begin
      return Result;
   end Group_Name;

   procedure Insert
     (Self : in out Group_List;
      Key  : String;
      Item : not null Slim_Test.Groups.Test_Group_Access) is
   begin
      Self.Last := Self.Last + 1;
      Self.List (Self.Last) := (Key'Address, Key'Length, Item);
   end Insert;

   procedure Run
     (Self   : Group_List;
      Result : out Slim_Test.Results.Result_Array)
   is
      Last : Natural := 0;
   begin
      for J in Self.List'Range loop
         declare
            Item renames Self.List (J);
            Output : Slim_Test.Results.Result_Array renames
              Result (Last + 1 .. Last + Item.Group.Length);
         begin
            Slim_Test.Groups.Run (Item.Group.all, Output);
            Last := Output'Last;
         end;
      end loop;
   end Run;

   function Test_Name (Self : Group_List; Index : Positive) return String is
      First : Positive := 1;
   begin
      for J in 1 .. Self.Length loop
         declare
            Group : constant Slim_Test.Groups.Test_Group_Access :=
              Self.List (J).Group;
         begin
            if Index in First .. First + Group.Length - 1 then
               return Group_Name (Self, J) & "."
                 & Slim_Test.Groups.Name (Group.all, Index - First + 1);
            end if;

            First := First + Group.Length;
         end;
      end loop;

      return "<?>";
   end Test_Name;

end Slim_Test.Group_Lists;

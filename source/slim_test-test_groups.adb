--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

package body Slim_Test.Test_Groups is

   procedure Insert
     (Self : in out Test_Group;
      Key  : String;
      Item : not null Test_Routine) is
   begin
      Self.Last := Self.Last + 1;
      Self.List (Self.Last) :=
        (Key'Address, Key'Length, Item, Result => <>);
   end Insert;

   procedure Run (Self : in out Test_Group) is
   begin
      for Item of Self.List loop
         begin
            Item.Routine (Item.Result);
         end;

         if Slim_Test.Results.Is_Failed (Item.Result) then
            Self.Failed := Self.Failed + 1;
         end if;
      end loop;
   end Run;

end Slim_Test.Test_Groups;

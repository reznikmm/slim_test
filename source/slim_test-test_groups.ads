--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

with Slim_Test.Results;
with System;

package Slim_Test.Test_Groups is
   pragma Pure;

   type Test_Routine is access
     procedure (Result : in out Slim_Test.Results.Result);

   type Test_Group (<>) is private
     with Aggregate =>
       (Empty     => Test_Group_Stub,
        Add_Named => Insert);

   function Test_Group_Stub (Length : Natural) return Test_Group;

   procedure Insert
     (Self : in out Test_Group;
      Key  : String;
      Item : not null Test_Routine);

   procedure Run (Self : in out Test_Group);

   function Failed (Self : Test_Group) return Natural;

private

   type Test_Item is record
      Name        : System.Address;
      Name_Length : Natural;
      Routine     : Test_Routine;
      Result      : Slim_Test.Results.Result;
   end record;

   type Test_Item_Array is array (Positive range <>) of Test_Item;

   type Test_Group (Length : Natural) is record
      Last   : Natural := 0;
      Failed : Natural := 0;
      List   : Test_Item_Array (1 .. Length);
   end record;

   function Test_Group_Stub (Length : Natural) return Test_Group is
     (Length => Length, others => <>);

   function Failed (Self : Test_Group) return Natural is
     (Self.Failed);

end Slim_Test.Test_Groups;

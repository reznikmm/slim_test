--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

with Slim_Test.Results;
with System;

package Slim_Test.Groups is

   type Test_Routine is access
     procedure (Result : in out Slim_Test.Results.Result);

   type Test_Group (Length : Natural) is private
     with Aggregate =>
       (Empty     => Test_Group_Stub,
        Add_Named => Insert);
   --  Test group is set of test routines with corresponding names.
   --
   --  Aggregate aspect let you construct the group with named aggegate:
   --
   --     G : Test_Group := ["T1" => P1'Access, "T2" => P2'Access];
   --

   procedure Run
     (Self   : Test_Group;
      Result : out Slim_Test.Results.Result_Array)
        with Pre => Result'Length = Self.Length;
   --
   --  Run each test of the group and populate Result

   function Name (Self : Test_Group; Index : Positive) return String;
   --  Return test name of given index

   --  Syntax sugar for creating and filling a new test group.

   function Test_Group_Stub (Length : Natural) return Test_Group;

   procedure Insert
     (Self : in out Test_Group;
      Key  : String;
      Item : not null Test_Routine);

   type Test_Group_Access is access constant Test_Group;

private

   type Test_Item is record
      Name        : System.Address;
      Name_Length : Natural;
      Routine     : Test_Routine;
   end record;

   type Test_Item_Array is array (Positive range <>) of Test_Item;

   type Test_Group (Length : Natural) is record
      Last    : Natural := 0;
      List    : Test_Item_Array (1 .. Length);
   end record;

   function Test_Group_Stub (Length : Natural) return Test_Group is
     (Length => Length, others => <>);

end Slim_Test.Groups;

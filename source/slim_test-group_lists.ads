--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

with Slim_Test.Groups;
with Slim_Test.Results;
with System;

package Slim_Test.Group_Lists is

   type Group_List (Length : Natural) is private
     with
       Aggregate =>
         (Empty     => Group_List_Stub,
          Add_Named => Insert);
   --  Test group list is set of test groups with corresponding names.
   --
   --  First two aspects let you construct the list with named aggegate:
   --
   --     List : Group_List := ["G1" => G1'Access, "G2" => G2'Access];
   --

   procedure Run
     (Self   : Group_List;
      Result : out Slim_Test.Results.Result_Array)
        with Pre => Result'First = 1 and Result'Last = Last_Index (Self);
   --
   --  Run each test of the group and populate Result

   function Group_Name (Self : Group_List; Index : Positive) return String;
   --  Return test group name of given index

   function Group
     (Self  : Group_List;
      Index : Positive)
        return Slim_Test.Groups.Test_Group_Access;
   --  Return test group of given index

   function First_Index (Self : Group_List; Index : Positive) return Positive;
   --  Return result's first index for given group

   function Last_Index (Self : Group_List; Index : Positive) return Natural;
   --  Return result's last index for given group

   function Last_Index (Self : Group_List) return Natural;
   --  Return result's last index for the last group

   function Test_Name (Self : Group_List; Index : Positive) return String;
   --  Return test group name of given index in result

   --  Syntax sugar for creating and filling a new test group.

   function Group_List_Stub (Length : Natural) return Group_List;

   procedure Insert
     (Self : in out Group_List;
      Key  : String;
      Item : not null Slim_Test.Groups.Test_Group_Access);

private

   type Group_Item is record
      Name        : System.Address;
      Name_Length : Natural;
      Group       : Slim_Test.Groups.Test_Group_Access;
   end record;

   type Group_Item_Array is array (Positive range <>) of Group_Item;

   type Group_List (Length : Natural) is record
      Last    : Natural := 0;
      List    : Group_Item_Array (1 .. Length);
   end record;

   function Group_List_Stub (Length : Natural) return Group_List is
     (Length => Length, others => <>);

   function Group
     (Self  : Group_List;
      Index : Positive)
        return Slim_Test.Groups.Test_Group_Access is (Self.List (Index).Group);

   function Last_Index (Self : Group_List; Index : Positive) return Natural is
     (First_Index (Self, Index) + Self.List (Index).Group.Length - 1);

   function Last_Index (Self : Group_List) return Natural is
      (Last_Index (Self, Self.Length));

end Slim_Test.Group_Lists;

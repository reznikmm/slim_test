--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

with Slim_Test.Results;
with Slim_Test.Test_Groups;

generic
   Group : Slim_Test.Test_Groups.Test_Group;
package Slim_Test.Generic_Test_Group is

   procedure Run;
   --  Run all tests in the group

   function Length return Natural;
   --  Total number of tests in the group

   function Failed return Natural;
   --  Number of failed tests in the group

   function Skipped return Natural;
   --  Number of skipped tests in the group

   function Name (Index : Positive) return String;
   --  Name of the test at the given index

   function Result (Index : Positive) return Slim_Test.Results.Result;
   --  Result of the test at the given index

private

   Copy : Slim_Test.Test_Groups.Test_Group := Group;

   function Length return Natural is (Copy.Length);

   function Failed return Natural is (Slim_Test.Test_Groups.Failed (Copy));

   function Skipped return Natural is (Slim_Test.Test_Groups.Skipped (Copy));

   function Name (Index : Positive) return String is
     (Slim_Test.Test_Groups.Name (Copy, Index));

   function Result (Index : Positive) return Slim_Test.Results.Result is
     (Slim_Test.Test_Groups.Result (Copy, Index));

end Slim_Test.Generic_Test_Group;

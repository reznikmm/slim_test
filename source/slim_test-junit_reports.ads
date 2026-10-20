--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

--  Report test results in the JUnit XML format (GitLab compatible).
--
--  Each generic procedure is instantiated with Put, which is called with
--  consecutive pieces of the document, so it can write them to a file,
--  a console, etc. Suite_Name becomes the name of the test suite.

with Slim_Test.Generic_Group;
with Slim_Test.Group_Lists;
with Slim_Test.Groups;
with Slim_Test.Results;

package Slim_Test.JUnit_Reports is

   generic
      with package Group is new Slim_Test.Generic_Group (<>);
      with procedure Put (Text : String);
      Suite_Name : String := "testsuite";
   procedure Generic_Group_Report;
   --  Report results of the tests in the Group, call it after Group.Run

   generic
      with procedure Put (Text : String);
      Suite_Name : String := "testsuite";
   procedure Group_List_Report
     (List   : Slim_Test.Group_Lists.Group_List;
      Result : Slim_Test.Results.Result_Array)
        with Pre => Result'First = 1
          and Result'Last = Slim_Test.Group_Lists.Last_Index (List);
   --  Report results populated by Slim_Test.Group_Lists.Run

   generic
      with procedure Put (Text : String);
      Suite_Name : String := "testsuite";
   procedure Test_Group_Report
     (Group  : Slim_Test.Groups.Test_Group;
      Result : Slim_Test.Results.Result_Array)
        with Pre => Result'Length = Group.Length;
   --  Report results populated by Slim_Test.Groups.Run

end Slim_Test.JUnit_Reports;

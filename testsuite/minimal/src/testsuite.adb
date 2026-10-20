--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with Ada.Text_IO;

with Slim_Test.Execution_Time;
with Slim_Test.Results;
with Slim_Test.Generic_Group;
with Slim_Test.JUnit_Reports;

with Test_Init;

procedure Testsuite is
   package Tests is new Slim_Test.Generic_Group
     (["test 1" => Test_Init.Test_One'Access]);

   procedure Report is new Slim_Test.JUnit_Reports.Generic_Group_Report
     (Tests, Ada.Text_IO.Put);

   File : Ada.Text_IO.File_Type;
begin
   Tests.Run;

   Ada.Text_IO.Put_Line ("Failed:" & Tests.Failed'Image);

   for J in 1 .. Tests.Length
     when Slim_Test.Results.Is_Failed (Tests.Result (J))
   loop
      Ada.Text_IO.Put ("  ");
      Ada.Text_IO.Put
        (Slim_Test.Execution_Time.Image
           (Slim_Test.Results.Execution_Time (Tests.Result (J))));
      Ada.Text_IO.Put ("  ");
      Ada.Text_IO.Put_Line (Tests.Name (J));
   end loop;

   Ada.Text_IO.Create (File, Name => "junit-report.xml");
   Ada.Text_IO.Set_Output (File);
   Report;
   Ada.Text_IO.Close (File);
end Testsuite;

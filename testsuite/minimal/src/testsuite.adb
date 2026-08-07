--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with Ada.Text_IO;

with Slim_Test.Results;
with Slim_Test.Generic_Test_Group;

with Test_Init;

procedure Testsuite is
   package Tests is new Slim_Test.Generic_Test_Group
     (["test 1" => Test_Init.Test_One'Access]);
begin
   Tests.Run;

   Ada.Text_IO.Put_Line ("Failed:" & Tests.Failed'Image);

   for J in 1 .. Tests.Length
     when Slim_Test.Results.Is_Failed (Tests.Result (J))
   loop
      Ada.Text_IO.Put ("  ");
      Ada.Text_IO.Put
        (Slim_Test.Results.Execution_Time (Tests.Result (J))'Image);
      Ada.Text_IO.Put ("  ");
      Ada.Text_IO.Put_Line (Tests.Name (J));
   end loop;
end Testsuite;

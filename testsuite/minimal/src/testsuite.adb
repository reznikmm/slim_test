--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with Ada.Text_IO;

with Slim_Test.Results;
with Slim_Test.Test_Groups;

with Test_Init;

procedure Testsuite is
   Tests : Slim_Test.Test_Groups.Test_Group :=
     ["test 1" => Test_Init.Test_One'Access];
begin
   Slim_Test.Test_Groups.Run (Tests);

   Ada.Text_IO.Put_Line
     ("Failed:" & Slim_Test.Test_Groups.Failed (Tests)'Image);

   for J in 1 .. Tests.Length loop
      if Slim_Test.Results.Is_Failed
        (Slim_Test.Test_Groups.Result (Tests, J))
      then
         Ada.Text_IO.Put ("  ");
         Ada.Text_IO.Put_Line
           (Slim_Test.Test_Groups.Name (Tests, J));
      end if;
   end loop;
end Testsuite;

--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

with Ada.Text_IO;

with Slim_Test.Test_Groups;

with Test_Init;

procedure Embedded is
   Tests : Slim_Test.Test_Groups.Test_Group :=
     ["test 1" => Test_Init.Test_One'Access];
begin
   Slim_Test.Test_Groups.Run (Tests);

   Ada.Text_IO.Put_Line
     ("Failed:" & Slim_Test.Test_Groups.Failed (Tests)'Image);
end Embedded;

--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

package body Test_Init is

   procedure Test_One (Result : in out Slim_Test.Results.Result) is
   begin
      Slim_Test.Results.Fail (Result);
   end Test_One;

end Test_Init;

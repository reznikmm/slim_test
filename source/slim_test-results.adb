--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

package body Slim_Test.Results is

   procedure Fail (Self : out Result) is
   begin
      Self.Failed := True;
   end Fail;

end Slim_Test.Results;

--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

package Slim_Test.Results is
   pragma Pure;

   type Result is private;

   procedure Fail (Self : out Result);

   function Is_Failed (Self : Result) return Boolean;

private

   type Result is record
      Failed : Boolean := False;
   end record;

   function Is_Failed (Self : Result) return Boolean is
     (Self.Failed);

end Slim_Test.Results;

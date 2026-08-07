--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

package body Slim_Test.Execution_Time is

   function "-" (Left, Right : Time) return Time_Span is
      use type Time_Span;
   begin
      return Time_Span (Left) - Time_Span (Right);
   end "-";

begin
   System.BB.Board_Support.Initialize_Board;
end Slim_Test.Execution_Time;

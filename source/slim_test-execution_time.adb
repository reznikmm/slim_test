--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

with Ada.Real_Time;

package body Slim_Test.Execution_Time is

   function "-" (Left, Right : Time) return Time_Span is
      Span : constant Duration := Ada.Real_Time.To_Duration (Right - Left);
   begin
      return Time_Span (Span * 1000.0);
   end "-";

end Slim_Test.Execution_Time;

--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

--  I hope the user will override this package with extended project when
--  a custom implementation is required.

with Ada.Execution_Time;

package Slim_Test.Execution_Time is
   type Time is private;

   function Clock return Time;

   subtype Time_Span is Natural;

   function "-" (Left, Right : Time) return Time_Span;

private

   type Time is new Ada.Execution_Time.CPU_Time;

   function Clock return Time is (Time (Ada.Execution_Time.Clock));

end Slim_Test.Execution_Time;

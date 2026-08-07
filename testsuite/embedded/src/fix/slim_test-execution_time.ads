--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

--  I hope the user will override this package with extended project when
--  a custom implementation is required.

pragma Warnings (Off, "is an internal GNAT unit");
with System.BB.Board_Support;
pragma Warnings (On, "is an internal GNAT unit");

with Interfaces;

package Slim_Test.Execution_Time is
   type Time is private;

   function Clock return Time;

   subtype Time_Span is Interfaces.Unsigned_32;

   function "-" (Left, Right : Time) return Time_Span;

private

   type Time is new System.BB.Board_Support.Time.Timer_Interval;

   function Clock return Time is
     (Time'Mod (System.BB.Board_Support.Time.Read_Clock));

end Slim_Test.Execution_Time;

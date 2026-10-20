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

   type Time_Span is private;

   Zero : constant Time_Span;

   function "-" (Left, Right : Time) return Time_Span;

   function "+" (Left, Right : Time_Span) return Time_Span;

   function Image (Value : Time_Span) return String;
   --  Text for reports, the JUnit report uses it as time in seconds

private

   type Time is new Ada.Execution_Time.CPU_Time;

   type Time_Span is new Natural;

   Zero : constant Time_Span := 0;

   function Clock return Time is (Time (Ada.Execution_Time.Clock));

end Slim_Test.Execution_Time;

--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

with Ada.Real_Time;

package body Slim_Test.Execution_Time is

   function "+" (Left, Right : Time_Span) return Time_Span is
   begin
      return Time_Span (Natural (Left) + Natural (Right));
   end "+";

   function "-" (Left, Right : Time) return Time_Span is
      Span : constant Duration := Ada.Real_Time.To_Duration (Left - Right);
   begin
      return Time_Span (Span * 1000.0);
   end "-";

   function Image (Value : Time_Span) return String is
      Seconds  : constant String := Natural'Image (Natural (Value) / 1000);
      Fraction : constant String :=
        Natural'Image (1000 + Natural (Value) mod 1000);
   begin
      return Seconds (Seconds'First + 1 .. Seconds'Last)
        & "." & Fraction (Fraction'First + 2 .. Fraction'Last);
   end Image;

end Slim_Test.Execution_Time;

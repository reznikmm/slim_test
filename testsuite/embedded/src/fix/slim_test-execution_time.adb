--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

package body Slim_Test.Execution_Time is

   function "+" (Left, Right : Time_Span) return Time_Span is
      use type Interfaces.Unsigned_32;
   begin
      return Time_Span (Interfaces.Unsigned_32 (Left)
                        + Interfaces.Unsigned_32 (Right));
   end "+";

   function "-" (Left, Right : Time) return Time_Span is
      use type Interfaces.Unsigned_32;
   begin
      return Time_Span (Interfaces.Unsigned_32 (Left)
                        - Interfaces.Unsigned_32 (Right));
   end "-";

   function Image (Value : Time_Span) return String is
      Text : constant String := Interfaces.Unsigned_32'Image
        (Interfaces.Unsigned_32 (Value));
   begin
      return Text (Text'First + 1 .. Text'Last);
   end Image;

begin
   System.BB.Board_Support.Initialize_Board;
end Slim_Test.Execution_Time;

--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

package body Slim_Test.Results is

   procedure Assert (Self : in out Result; Ok : Boolean) is
   begin
      if not Ok then
         Fail (Self);
      end if;
   end Assert;

   procedure Fail (Self : in out Result) is
   begin
      Self.State := Failed;
   end Fail;

   procedure Skip (Self : in out Result) is
   begin
      Self.State := Skipped;
   end Skip;

   procedure Set_Execution_Time
     (Self  : in out Result;
      Value : Slim_Test.Execution_Time.Time_Span) is
   begin
      Self.Time := Value;
   end Set_Execution_Time;

end Slim_Test.Results;

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

   function Failed (List : Result_Array) return Natural is
      Result : Natural := 0;
   begin
      for Item of List when Is_Failed (Item) loop
         Result := Result + 1;
      end loop;

      return Result;
   end Failed;

   procedure Set_Execution_Time
     (Self  : in out Result;
      Value : Slim_Test.Execution_Time.Time_Span) is
   begin
      Self.Time := Value;
   end Set_Execution_Time;

   procedure Skip (Self : in out Result) is
   begin
      Self.State := Skipped;
   end Skip;

   function Skipped (List : Result_Array) return Natural is
      Result : Natural := 0;
   begin
      for Item of List when Is_Skipped (Item) loop
         Result := Result + 1;
      end loop;

      return Result;
   end Skipped;

end Slim_Test.Results;

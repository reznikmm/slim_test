--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

with Slim_Test.Execution_Time;

package Slim_Test.Results is

   type Result is private;

   procedure Fail (Self : in out Result);
   --  Set result to Fail

   procedure Assert (Self : in out Result; Ok : Boolean);
   --  Set result to Fail if not Ok

   procedure Set_Execution_Time
     (Self  : in out Result;
      Value : Slim_Test.Execution_Time.Time_Span);

   function Is_Failed (Self : Result) return Boolean;

   function Execution_Time
     (Self : Result) return Slim_Test.Execution_Time.Time_Span;

private

   type Result is record
      Failed : Boolean := False;
      Time   : Slim_Test.Execution_Time.Time_Span;
   end record;

   function Is_Failed (Self : Result) return Boolean is
     (Self.Failed);

   function Execution_Time
     (Self : Result) return Slim_Test.Execution_Time.Time_Span is (Self.Time);

end Slim_Test.Results;

--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

with Slim_Test.Execution_Time;

package Slim_Test.Results is

   type Result is private;

   procedure Fail (Self : in out Result);
   --  Set result to Fail

   procedure Skip (Self : in out Result);
   --  Mark test as intentionally not executed

   procedure Assert (Self : in out Result; Ok : Boolean);
   --  Set result to Fail if not Ok

   procedure Set_Execution_Time
     (Self  : in out Result;
      Value : Slim_Test.Execution_Time.Time_Span);

   function Is_Passed (Self : Result) return Boolean;
   --  True unless the test failed or was skipped

   function Is_Failed (Self : Result) return Boolean;
   --  True if the test called Fail (directly or through a failed Assert)

   function Is_Skipped (Self : Result) return Boolean;
   --  True if the test called Skip

   function Execution_Time
     (Self : Result) return Slim_Test.Execution_Time.Time_Span;

private

   type Status is (Passed, Failed, Skipped);

   type Result is record
      State : Status := Passed;
      Time  : Slim_Test.Execution_Time.Time_Span;
   end record;

   function Is_Passed (Self : Result) return Boolean is
     (Self.State = Passed);

   function Is_Failed (Self : Result) return Boolean is
     (Self.State = Failed);

   function Is_Skipped (Self : Result) return Boolean is
     (Self.State = Skipped);

   function Execution_Time
     (Self : Result) return Slim_Test.Execution_Time.Time_Span is (Self.Time);

end Slim_Test.Results;

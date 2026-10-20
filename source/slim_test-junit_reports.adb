--  SPDX-FileCopyrightText: 2026 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
------------------------------------------------------------------

with Slim_Test.Execution_Time;

package body Slim_Test.JUnit_Reports is

   generic
      with procedure Put (Text : String);
      Suite_Name : String;
      Length     : Natural;
      with function Name (Index : Positive) return String;
      with function Result
        (Index : Positive) return Slim_Test.Results.Result;
   procedure Write_Report;

   procedure Write_Report is
      use type Slim_Test.Execution_Time.Time_Span;

      procedure Put_Escaped (Text : String);

      procedure Put_Image (Image : String);

      procedure Put_Escaped (Text : String) is
      begin
         for Char of Text loop
            case Char is
               when '&'    =>
                  Put ("&amp;");

               when '<'    =>
                  Put ("&lt;");

               when '>'    =>
                  Put ("&gt;");

               when '"'    =>
                  Put ("&quot;");

               when others =>
                  Put ([Char]);
            end case;
         end loop;
      end Put_Escaped;

      procedure Put_Image (Image : String) is
      begin
         Put (Image (Image'First + 1 .. Image'Last));
      end Put_Image;

      Total_Time : Slim_Test.Execution_Time.Time_Span :=
        Slim_Test.Execution_Time.Zero;

      Failed  : Natural := 0;
      Skipped : Natural := 0;
   begin
      for Index in 1 .. Length loop
         Total_Time :=
           Total_Time + Slim_Test.Results.Execution_Time (Result (Index));

         if Slim_Test.Results.Is_Failed (Result (Index)) then
            Failed := Failed + 1;
         elsif Slim_Test.Results.Is_Skipped (Result (Index)) then
            Skipped := Skipped + 1;
         end if;
      end loop;

      Put ("<?xml version=""1.0"" encoding=""UTF-8""?>" & ASCII.LF);
      Put ("<testsuites>" & ASCII.LF);
      Put ("  <testsuite name=""");
      Put_Escaped (Suite_Name);
      Put (""" tests=""");
      Put_Image (Natural'Image (Length));
      Put (""" failures=""");
      Put_Image (Natural'Image (Failed));
      Put (""" skipped=""");
      Put_Image (Natural'Image (Skipped));
      Put (""" time=""");
      Put (Slim_Test.Execution_Time.Image (Total_Time));
      Put (""">" & ASCII.LF);

      for Index in 1 .. Length loop
         Put ("    <testcase classname=""");
         Put_Escaped (Suite_Name);
         Put (""" name=""");
         Put_Escaped (Name (Index));
         Put (""" time=""");
         Put
           (Slim_Test.Execution_Time.Image
              (Slim_Test.Results.Execution_Time (Result (Index))));
         Put ("""");

         if Slim_Test.Results.Is_Failed (Result (Index)) then
            Put (">" & ASCII.LF);
            Put ("      <failure message=""Test failed""/>" & ASCII.LF);
            Put ("    </testcase>" & ASCII.LF);
         elsif Slim_Test.Results.Is_Skipped (Result (Index)) then
            Put (">" & ASCII.LF);
            Put ("      <skipped/>" & ASCII.LF);
            Put ("    </testcase>" & ASCII.LF);
         else
            Put ("/>" & ASCII.LF);
         end if;
      end loop;

      Put ("  </testsuite>" & ASCII.LF);
      Put ("</testsuites>" & ASCII.LF);
   end Write_Report;

   procedure Generic_Group_Report is
      procedure Write is new Write_Report
        (Put        => Put,
         Suite_Name => Suite_Name,
         Length     => Group.Length,
         Name       => Group.Name,
         Result     => Group.Result);
   begin
      Write;
   end Generic_Group_Report;

   procedure Group_List_Report
     (List   : Slim_Test.Group_Lists.Group_List;
      Result : Slim_Test.Results.Result_Array)
   is
      function Test_Name (Index : Positive) return String is
        (Slim_Test.Group_Lists.Test_Name (List, Index));

      function Test_Result
        (Index : Positive) return Slim_Test.Results.Result is
          (Result (Index));

      procedure Write is new Write_Report
        (Put        => Put,
         Suite_Name => Suite_Name,
         Length     => Result'Length,
         Name       => Test_Name,
         Result     => Test_Result);
   begin
      Write;
   end Group_List_Report;

   procedure Test_Group_Report
     (Group  : Slim_Test.Groups.Test_Group;
      Result : Slim_Test.Results.Result_Array)
   is
      function Test_Name (Index : Positive) return String is
        (Slim_Test.Groups.Name (Group, Index));

      function Test_Result
        (Index : Positive) return Slim_Test.Results.Result is
          (Result (Result'First + Index - 1));

      procedure Write is new Write_Report
        (Put        => Put,
         Suite_Name => Suite_Name,
         Length     => Result'Length,
         Name       => Test_Name,
         Result     => Test_Result);
   begin
      Write;
   end Test_Group_Report;

end Slim_Test.JUnit_Reports;

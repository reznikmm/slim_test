Slim_Test
========

[![Build with Alire](https://github.com/reznikmm/slim_test/actions/workflows/alire.yml/badge.svg)](https://github.com/reznikmm/slim_test/actions/workflows/alire.yml)
[![REUSE status](https://api.reuse.software/badge/github.com/reznikmm/slim_test)](https://api.reuse.software/info/github.com/reznikmm/slim_test)

Slim_Test is a very small unit test framework for Ada 2022.

The design is intentionally minimal:

- a test is a procedure that receives a `Slim_Test.Results.Result`
- a test suite is a container aggregate of named tests in the form
  ```ada
    ["test name" => Test'Access]
  ```
- test suite can be wrapped into a generic package,
  so you don't need to pass the container around
- you run whole test group with `Run` in one call
- after running the suite you can enumerate over results to find
  successed, failed, skipped tests.
- each test result includes `Execution_Time`

There is no generated harness and no assertion DSL. You write ordinary Ada
procedures and make test report yourself.

## Contents

- [API Summary](#api-summary)
- [Requirements](#requirements)
- [Minimal Example](#minimal-example)
- [JUnit Report For GitLab](#junit-report-for-gitlab)
- [Example Projects](#example-projects)
- [Customizing Execution_Time](#customizing-execution_time)
- [Using In Your Project](#using-in-your-project)
- [Build And Run](#build-and-run)
- [Repository Layout](#repository-layout)
- [Status](#status)
- [Maintainer](#maintainer)
- [License](#license)

## API Summary

Main packages:

- `Slim_Test.Results` contains `Result` type and its operations:
   - `Fail` marks a test as failed
   - `Skip` marks a test as intentionally not executed
   - `Assert` marks a test as failed unless a condition holds
   - `Is_Passed` checks whether a test neither failed nor was skipped
   - `Is_Failed` checks whether a test failed
   - `Is_Skipped` checks whether a test was skipped
   - `Set_Execution_Time` stores measured execution time in a test result
   - `Execution_Time` returns measured execution time from a test result
- `Slim_Test.Generic_Group`
   - primary high-level API for running tests
   - provides `Run`, `Length`, `Failed`, `Skipped`, `Name`, `Result`
- `Slim_Test.Groups`
   - the API with explicit result array, uses `Test_Group` type
- `Slim_Test.Group_Lists`
   - a named list of test groups, run with one call into a `Result_Array`
- `Slim_Test.JUnit_Reports`
   - generic procedures that write test results as a JUnit XML report:
     `Generic_Group_Report`, `Group_List_Report`, `Test_Group_Report`
- `Slim_Test.Execution_Time`
   - abstraction for time source and time delta type (`Time_Span`, `Zero`,
     `"+"`, `Image`)
   - default implementation measures CPU time and prints it in seconds

## Requirements

- [Alire](https://alire.ada.dev/)
- GNAT toolchain compatible with Ada 2022

## Minimal Example

The minimal example in `testsuite/minimal/` uses Slim_Test like this.

Define a test procedure in a package or as standalone procedure:

```ada
with Slim_Test.Results;

package Test_Init is

   procedure Test_One (Result : in out Slim_Test.Results.Result);

end Test_Init;
```

```ada
package body Test_Init is

   procedure Test_One (Result : in out Slim_Test.Results.Result) is
   begin
      Slim_Test.Results.Fail (Result);
   end Test_One;

end Test_Init;
```

Build a group of named tests and instantiate `Slim_Test.Generic_Group`:

```ada
with Ada.Text_IO;
with Slim_Test.Results;
with Slim_Test.Generic_Group;
with Slim_Test.Groups;
with Test_Init;

procedure Testsuite is
   package Tests is new Slim_Test.Generic_Group
      (["test 1" => Test_Init.Test_One'Access]);
begin
   Tests.Run;

   Ada.Text_IO.Put_Line ("Failed:" & Tests.Failed'Image);
   Ada.Text_IO.Put_Line ("Skipped:" & Tests.Skipped'Image);

   for J in 1 .. Tests.Length
      when Slim_Test.Results.Is_Failed (Tests.Result (J))
   loop
      Ada.Text_IO.Put ("  ");
      Ada.Text_IO.Put
        (Slim_Test.Execution_Time.Image
           (Slim_Test.Results.Execution_Time (Tests.Result (J))));
      Ada.Text_IO.Put ("  ");
      Ada.Text_IO.Put_Line (Tests.Name (J));
   end loop;
end Testsuite;
```

If you want a test to fail only when a condition is false, write
that condition directly, or use `Assert`:

```ada
procedure Test_Addition (Result : in out Slim_Test.Results.Result) is
begin
   if 2 * 2 /= 4 then
      Slim_Test.Results.Fail (Result);
   end if;
end Test_Addition;
```

```ada
procedure Test_Addition (Result : in out Slim_Test.Results.Result) is
begin
   Slim_Test.Results.Assert (Result, 2 + 2 = 4);
end Test_Addition;
```

If a test cannot run at all (missing hardware, unsupported configuration,
a command-line option that was not given), call `Skip` instead of `Fail`:

```ada
procedure Test_Requires_Device (Result : in out Slim_Test.Results.Result) is
begin
   if Device_Present then
      Slim_Test.Results.Assert (Result, Device_Check);
   else
      Slim_Test.Results.Skip (Result);
   end if;
end Test_Requires_Device;
```

A skipped test is neither passed nor failed: `Is_Skipped` is true for it,
`Is_Passed` and `Is_Failed` are false, and it is counted in `Skipped`
rather than `Failed` by the test group.

## JUnit Report For GitLab

`Slim_Test.JUnit_Reports` has generic procedures that write test results
as JUnit XML, one for each way to run tests:

- `Generic_Group_Report` for a `Slim_Test.Generic_Group` instance
- `Test_Group_Report (Group, Result)` for `Slim_Test.Groups`
- `Group_List_Report (List, Result)` for `Slim_Test.Group_Lists`

They have no dependencies: the generic formal `Put (Text : String)`
receives pieces of the document, so you decide where they go (a file,
console, UART...). The optional formal `Suite_Name` (`"testsuite"` by
default) names the test suite. Failed tests get `<failure>`, skipped tests
get `<skipped/>`, and execution time is reported with
`Slim_Test.Execution_Time.Image`.

```ada
with Ada.Text_IO;
with Slim_Test.Generic_Group;
with Slim_Test.JUnit_Reports;
with Test_Init;

procedure Testsuite is
   package Tests is new Slim_Test.Generic_Group
     (["test 1" => Test_Init.Test_One'Access]);

   procedure Report is new Slim_Test.JUnit_Reports.Generic_Group_Report
     (Tests, Ada.Text_IO.Put);

   File : Ada.Text_IO.File_Type;
begin
   Tests.Run;

   Ada.Text_IO.Create (File, Name => "junit-report.xml");
   Ada.Text_IO.Set_Output (File);
   Report;
   Ada.Text_IO.Close (File);
end Testsuite;
```

Then publish the file as a GitLab test report in `.gitlab-ci.yml`:

```yaml
test:
  script:
    - alr -C testsuite/minimal run
  artifacts:
    when: always
    reports:
      junit: testsuite/minimal/junit-report.xml
```

`when: always` keeps the report when the job fails. GitLab shows the results
in the merge request widget and the pipeline's **Tests** tab. Make the
executable exit with a non-zero status when `Failed` is not zero if you also
want the job itself to fail.

## Example Projects

Two example projects are included under `testsuite/`:

- `testsuite/minimal/` is the smallest host-side executable example.
- `testsuite/embedded/` shows the same pattern in a cross-project configured
   for `arm-eabi` with the `light-tasking-stm32f4` runtime and a custom
   `Slim_Test.Execution_Time` override.

## Customizing Execution_Time

`Slim_Test.Execution_Time` is intentionally replaceable.

- The package declares the private `Time_Span` type with the operations
  the framework needs: `Zero`, `"+"`, `"-"` (on `Time`) and `Image`.
  You choose the representation (seconds, CPU ticks, ...) and what `Image`
  prints.
- `Image` is used for console output and as the `time` attribute in
  the JUnit report, so return seconds from it if you want GitLab to show
  correct durations.
- By default (`source/slim_test-execution_time.*`) `Image` prints elapsed
  CPU time in seconds with millisecond precision, like `0.012`.
  The embedded example prints timer ticks.
- To use board- or platform-specific timing, provide your own
  `slim_test-execution_time.ads` and `slim_test-execution_time.adb`.
- Point `SLIM_TEST_FIX` to the directory with replacement units.

The root crate exposes this through `alire.toml`:

- `[gpr-externals] SLIM_TEST_FIX = ""`

The embedded example configures it with environment settings:

- `[environment] SLIM_TEST_FIX.prepend = "${CRATE_ROOT}/src/fix"`

Reference implementation is in:

- `testsuite/embedded/src/fix/slim_test-execution_time.ads`
- `testsuite/embedded/src/fix/slim_test-execution_time.adb`

## Using In Your Project

Add Slim_Test as a dependency:

```shell
alr with slim_test
```

Then:

1. Create one or more test procedures with the profile
   `procedure (Result : in out Slim_Test.Results.Result)`.
2. Instantiate `Slim_Test.Generic_Group` with a named aggregate.
3. Call `Run` on the instantiated package.
4. Read `Failed`, and optionally iterate `1 .. Length` with
   `Name` and `Result` for per-test reporting.

Example with multiple tests:

```ada
package Tests is new Slim_Test.Generic_Group
  (["addition"       => Test_Math.Test_Addition'Access,
    "multiplication" => Test_Math.Test_Multiplication'Access,
    "parsing"        => Test_Parse.Test_Parse'Access]);
```

You can inspect each test result after `Run`:

```ada
Tests.Run;

for Index in 1 .. Tests.Length loop
   declare
      Name   : constant String :=
        Tests.Name (Index);

      Result : constant Slim_Test.Results.Result :=
        Tests.Result (Index);
   begin
      if Slim_Test.Results.Is_Failed (Result) then
         Ada.Text_IO.Put_Line (Name & ": FAILED");
      elsif Slim_Test.Results.Is_Skipped (Result) then
         Ada.Text_IO.Put_Line (Name & ": SKIPPED");
      else
         Ada.Text_IO.Put_Line (Name & ": PASSED");
      end if;
   end;
end loop;
```

Low-level alternative (without `Generic_Group`):

```ada
declare
   Group : Slim_Test.Groups.Test_Group :=
     ["addition" => Test_Math.Test_Addition'Access];

   Result : Slim_Test.Results.Result_Array (1 .. Tests.Length);

begin
   Slim_Test.Groups.Run (Group, Result);
   Ada.Text_IO.Put_Line ("Failed:" & Slim_Test.Results.Failed (Result)'Image);
end;
```

## Build And Run

From repository root:

```sh
alr build
```

Run the minimal example:

```sh
alr -C testsuite/minimal run
```

Or use the crate test action:

```sh
alr test
```

Build the embedded cross-project example:

```sh
alr -C testsuite/embedded build
```

Run both examples using the testsuite make target:

```sh
make -C testsuite
```

## Repository Layout

```text
.
├── source/        # Slim_Test library sources
├── testsuite/
│   ├── minimal/   # Smallest runnable example
│   └── embedded/  # Embedded project example
├── alire.toml     # Crate metadata and test action
└── AGENTS.md      # Repository-specific instructions for coding agents
```

## Status

Right now Slim_Test is intentionally tiny. It gives you:

- a common result type for tests, with Passed/Failed/Skipped status
- a container for named tests
- sequential execution
- failed and skipped test counters

It does not currently provide filtering, per-test output, fixtures, or exception reporting.

## Maintainer

[Max Reznik](https://github.com/reznikmm)

## License

Licensed under Apache-2.0 WITH LLVM-exception. See `LICENSES/` and `REUSE.toml`.


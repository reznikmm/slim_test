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
- after running the suite you can enumerate the results with `Length`,
  `Name`, and `Result` functions
- each test result includes `Execution_Time`

There is no generated harness and no assertion DSL. You write ordinary Ada
procedures and make test report yourself.

## API Summary

Main packages:

- `Slim_Test.Results` contains `Result` type and its operations:
   - `Fail` marks a test as failed
   - `Is_Failed` checks whether a test failed
   - `Set_Execution_Time` stores measured execution time in a test result
   - `Execution_Time` returns measured execution time from a test result
- `Slim_Test.Generic_Test_Group`
   - primary high-level API for running tests
   - provides `Run`, `Length`, `Failed`, `Name`, `Result`
- `Slim_Test.Test_Groups`
   - the same API as `Generic_Test_Group` but using `Test_Group` type
- `Slim_Test.Execution_Time`
   - abstraction for time source and time delta type
   - default implementation returns elapsed time in milliseconds

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

Build a group of named tests and instantiate `Slim_Test.Generic_Test_Group`:

```ada
with Ada.Text_IO;
with Slim_Test.Results;
with Slim_Test.Generic_Test_Group;
with Slim_Test.Test_Groups;
with Test_Init;

procedure Testsuite is
   package Tests is new Slim_Test.Generic_Test_Group
      (["test 1" => Test_Init.Test_One'Access]);
begin
   Tests.Run;

   Ada.Text_IO.Put_Line ("Failed:" & Tests.Failed'Image);

   for J in 1 .. Tests.Length
      when Slim_Test.Results.Is_Failed (Tests.Result (J))
   loop
      Ada.Text_IO.Put ("  ");
      Ada.Text_IO.Put
        (Slim_Test.Results.Execution_Time (Tests.Result (J))'Image);
      Ada.Text_IO.Put ("  ");
      Ada.Text_IO.Put_Line (Tests.Name (J));
   end loop;
end Testsuite;
```

If you want a test to fail only when a condition is false, write
that condition directly:

```ada
procedure Test_Addition (Result : in out Slim_Test.Results.Result) is
begin
   if 2 + 2 /= 4 then
      Slim_Test.Results.Fail (Result);
   end if;
end Test_Addition;
```

## Example Projects

Two example projects are included under `testsuite/`:

- `testsuite/minimal/` is the smallest host-side executable example.
- `testsuite/embedded/` shows the same pattern in a cross-project configured
   for `arm-eabi` with the `light-tasking-stm32f4` runtime and a custom
   `Slim_Test.Execution_Time` override.

## Customizing Execution_Time

`Slim_Test.Execution_Time` is intentionally replaceable.

- By default (`source/slim_test-execution_time.*`) elapsed time is reported
  in milliseconds.
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
2. Instantiate `Slim_Test.Generic_Test_Group` with a named aggregate.
3. Call `Run` on the instantiated package.
4. Read `Failed`, and optionally iterate `1 .. Length` with
   `Name` and `Result` for per-test reporting.

Example with multiple tests:

```ada
package Tests is new Slim_Test.Generic_Test_Group
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
      else
         Ada.Text_IO.Put_Line (Name & ": PASSED");
      end if;
   end;
end loop;
```

Low-level alternative (without `Generic_Test_Group`):

```ada
declare
   Group : Slim_Test.Test_Groups.Test_Group :=
     ["addition" => Test_Math.Test_Addition'Access];
begin
   Slim_Test.Test_Groups.Run (Group);
   Ada.Text_IO.Put_Line ("Failed:" & Slim_Test.Test_Groups.Failed (Group)'Image);
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

- a common result type for tests
- a container for named tests
- sequential execution
- a failed test counter

It does not currently provide assertions, filtering, per-test output, fixtures, or exception reporting.

## Maintainer

[Max Reznik](https://github.com/reznikmm)

## License

Licensed under Apache-2.0 WITH LLVM-exception. See `LICENSES/` and `REUSE.toml`.


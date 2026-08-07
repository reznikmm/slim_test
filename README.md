Slim_Test
========

[![Build with Alire](https://github.com/reznikmm/slim_test/actions/workflows/alire.yml/badge.svg)](https://github.com/reznikmm/slim_test/actions/workflows/alire.yml)
[![REUSE status](https://api.reuse.software/badge/github.com/reznikmm/slim_test)](https://api.reuse.software/info/github.com/reznikmm/slim_test)

Slim_Test is a very small unit test framework for Ada 2022.

The design is intentionally minimal:

- a test is a procedure that receives a `Slim_Test.Results.Result`
- a test fails only when it explicitly calls `Slim_Test.Results.Fail`
- a test suite is a `Slim_Test.Test_Groups.Test_Group`
- running the suite gives you the number of failed tests

There is no generated harness and no assertion DSL. You write ordinary Ada procedures and mark failure yourself.

## API Summary

The current public API is small:

- `Slim_Test.Results.Fail` marks a test as failed
- `Slim_Test.Results.Is_Failed` checks whether a result is failed
- `Slim_Test.Test_Groups.Test_Group` stores named test procedures
- `Slim_Test.Test_Groups.Run` executes all tests in a group
- `Slim_Test.Test_Groups.Failed` returns the number of failed tests

## Requirements

- [Alire](https://alire.ada.dev/)
- GNAT toolchain compatible with Ada 2022

## Minimal Example

The testsuite in `testsuite/` uses Slim_Test like this.

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

Build a group of named tests and run it:

```ada
with Ada.Text_IO;
with Slim_Test.Test_Groups;
with Test_Init;

procedure Testsuite is
	Tests : Slim_Test.Test_Groups.Test_Group :=
	  ["test 1" => Test_Init.Test_One'Access];
begin
	Slim_Test.Test_Groups.Run (Tests);

	Ada.Text_IO.Put_Line
	  ("Failed:" & Slim_Test.Test_Groups.Failed (Tests)'Image);
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

## Using In Your Project

Add Slim_Test as a dependency:

```shell
alr with slim_test
```

Then:

1. Create one or more test procedures with the profile
   `procedure (Result : in out Slim_Test.Results.Result)`.
2. Put those procedures into a `Slim_Test.Test_Groups.Test_Group`
   aggregate with human-readable names.
3. Call `Slim_Test.Test_Groups.Run`.
4. Check `Slim_Test.Test_Groups.Failed` and decide how your test
   runner should report failure.

Example with multiple tests:

```ada
Tests : Slim_Test.Test_Groups.Test_Group :=
  ["addition"        => Test_Math.Test_Addition'Access,
	"multiplication" => Test_Math.Test_Multiplication'Access,
	"parsing"        => Test_Parse.Test_Parse'Access];
```

## Build And Run

From repository root:

```sh
alr build
```

Run the example testsuite:

```sh
alr -C testsuite run
```

Or use the crate test action:

```sh
alr test
```

## Repository Layout

```text
.
├── source/       # Slim_Test library sources
├── testsuite/    # Minimal example of how to define and run tests
├── alire.toml    # Crate metadata and test action
└── AGENTS.md     # Repository-specific instructions for coding agents
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


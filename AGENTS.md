# AGENTS.md

## Purpose

Slim_Test is a very small Ada 2022 unit test framework.

The core model is intentionally minimal:

- a test is a procedure with the profile
  `procedure (Result : in out Slim_Test.Results.Result)`
- a test fails only when it calls `Slim_Test.Results.Fail`
- tests are collected in `Slim_Test.Test_Groups.Test_Group`
- `Slim_Test.Test_Groups.Run` executes the group
- `Slim_Test.Test_Groups.Failed` returns the failed count

## Repository Map

```text
.
├── source/       # Library units: Slim_Test, Slim_Test.Results, Slim_Test.Test_Groups
├── testsuite/    # Minimal example crate showing how to define and run tests
├── config/       # Generated Alire configuration for the root crate; do not edit manually
├── alire.toml    # Root crate metadata and test action
├── README.md     # User-facing overview and usage example
└── AGENTS.md     # Repository-specific instructions for coding agents
```

Important source files:

- `source/slim_test.ads`: root package
- `source/slim_test-results.ads|adb`: test result state and failure marking
- `source/slim_test-test_groups.ads|adb`: named test container and runner
- `testsuite/src/testsuite.adb`: smallest runnable usage example

## Ground Rules

- Don't suppress exception with `null;` exception handler
   (one exception is `Libadalang.Common.Property_Error`).
- Don't introduce extra (sub-)type conversions, like Integer to Natural.
- Preserve existing style and naming conventions in nearby code. Don't use abbreviations.
- Keep the framework small. Do not add abstractions, containers, or features unless the task requires them.
- Do not edit generated files in `config/`, `testsuite/config/`, `.obj/`, or `.lib/` unless the task is explicitly about generated build configuration.

## Build And Test Commands

Run from repository root unless noted otherwise.

- Compile core library:
  - `alr build`
- Compile/check one file (`<unit>.adb`):
  - `alr exec -- gprbuild -q -f -c -u -gnatc -P slim_test.gpr <unit>.adb '-cargs:ada' -gnatef`
- Fix code style warnings, force code style after edit:
  - `alr exec -- gnatformat --charset=utf-8 --no-subprojects -P slim_test.gpr`
- Build and run testsuite:
  - `alr -C testsuite/ run`
- Run the root test action:
  - `alr test`

Current validation note:

- If `alr -C testsuite/ run` fails because `testsuite/config/testsuite_config.gpr`
  still imports `trendy_test.gpr`, treat that as a repository configuration issue,
  not as proof that source changes are wrong.

## Change Workflow For Agents

1. Read relevant package spec/body before editing. Read `*.adb` only if reading of corresponding `*.ads` is not enough.
2. Implement the smallest viable patch.
3. Re-run compile check for touched units.
4. Run targeted runtime/test command when behavior changes.
5. Report exactly what changed and what was validated.

For documentation work:

1. Prefer describing the actual current API and behavior over aspirational features.
2. Use the example in `testsuite/` as the source of truth for usage.
3. Keep examples minimal and directly runnable.

## Ada-Specific Notes

- Use predefined Ada container packages
  (for example, `Ada.Containers.Hashed_Sets`). Don't use Indefinite containers.
- Use Ada 2022 syntax if you can.
- Prefer package specs as the authoritative API surface; treat bodies as implementation details.
- Avoid adding inline comments unless the code would otherwise be hard to parse.

## Output And Error Handling Expectations

- Diagnostics should be actionable and include path/context when possible.
- When tests or builds fail due to repository setup issues, say so explicitly and separate that from your own changes.

## When Unsure

- Prefer conservative changes.
- Ask for clarification before large architectural rewrites.
- Document assumptions in the final update.

# Windows Development (MSVC)

This template supports building and testing natively on Windows with MSVC.
Linux remains the primary development environment (via devcontainers), but
the Windows build is a required CI check and works locally.

## Prerequisites

1. **Visual Studio** (Community edition is fine) with the
   **"Desktop development with C++"** workload — provides MSVC, CMake,
   and the Windows SDK.

2. **Git** — [git-scm.com](https://git-scm.com/download/win)

3. **vcpkg** — follow the [official install guide](https://learn.microsoft.com/en-us/vcpkg/get_started/get-started).
   The `VCPKG_ROOT` environment variable must be set — the CMake preset
   uses it to locate the vcpkg toolchain file.

## Installing CppUTest

```powershell
vcpkg install cpputest
```

## Building and testing

```powershell
cmake --preset msvc-debug
cmake --build --preset msvc-debug --target junit
```

In VS Code, **Ctrl+Shift+B** runs the build and test cycle automatically.

## Running tests with ctest

```powershell
ctest --preset msvc-debug
```

## What's not available on Windows

The following presets are Linux-only and won't appear on Windows:

- `sanitize` — AddressSanitizer / UBSan (GCC/Clang only)
- `coverage` — lcov/genhtml code coverage
- `tidy` — clang-tidy static analysis
- `cppcheck` — cppcheck static analysis
- BDD tests (Behave/Gherkin via Docker)

These all run in CI on Linux containers. Windows CI runs the `msvc-debug`
build and test only.

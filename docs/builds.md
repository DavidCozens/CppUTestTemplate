# Building and Testing

All builds use CMake presets. Output goes to `build/<preset>/`.

## TDD loop — `debug`

The everyday build for writing and running tests.

```bash
cmake --preset debug
cmake --build --preset debug --target junit
```

In VS Code, **Ctrl+Shift+B** runs the build and test and reports pass/fail in the terminal.

## Clang build — `clang-debug`

Builds with Clang 19 as a second compiler, catching portability issues not caught by GCC.
Run from the host terminal via Docker Compose:

```bash
docker compose -f .devcontainer/docker-compose.yml run --rm clang cmake --preset clang-debug
docker compose -f .devcontainer/docker-compose.yml run --rm clang cmake --build --preset clang-debug --target junit
```

## Sanitizers — `sanitize`

Catches memory errors, use-after-free, and undefined behaviour at runtime.

```bash
cmake --preset sanitize
cmake --build --preset sanitize --target junit
```

## Coverage — `coverage`

Generates an HTML coverage report for the library source.

```bash
cmake --preset coverage
cmake --build --preset coverage --target coverage
```

Open `build/coverage/coverage_report/index.html` to view results.
The CI gate is 90% line and branch. The target is 100%.

## Static analysis — `tidy`

Runs clang-tidy on all source files. All warnings are errors.
Checks are configured in [.clang-tidy](../.clang-tidy).

```bash
cmake --preset tidy
cmake --build --preset tidy
```

## cppcheck — `cppcheck`

Runs cppcheck static analysis on all source files.

```bash
cmake --preset cppcheck
cmake --build --preset cppcheck
```

## Release — `release`

Optimised build with no instrumentation. Used for the install target.

```bash
cmake --preset release
cmake --build --preset release --target junit
```

## Installing the library

```bash
cmake --preset release
cmake --build --preset release
cmake --install build/release --prefix /your/install/path
```

This installs the static library to `lib/` and the public headers to `include/`.

## JUnit XML output

The `junit` target runs the tests and writes a JUnit-format XML file to the build directory.
Used by the VS Code test explorer and the CI pipeline.

```bash
cmake --build --preset debug --target junit
```

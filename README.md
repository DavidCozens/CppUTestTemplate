# CppUTestTemplate

A template for C and C++ projects using [CppUTest](https://cpputest.github.io/) as the unit test framework. It provides a ready-to-use project structure with CMake presets, VS Code integration, and a GitHub Actions CI pipeline.

The template is developed and maintained by [Cozens Software Solutions Limited](https://www.cososo.co.uk).

## What's included

- CMake build system with named presets for common workflows
- CppUTest unit tests for both C and C++ source
- VS Code tasks and launch configuration wired to the build presets
- GitHub Actions CI running build/test, sanitizers, coverage, and static analysis in parallel
- Code coverage reporting with lcov/genhtml
- Static analysis with clang-tidy
- AddressSanitizer and UndefinedBehaviourSanitizer support
- Install rules for the library and public headers

## Project structure

```
CppUTestTemplate/
├── Interface/        # Public headers (installed alongside the library)
├── Source/           # Library implementation (.c / .cpp)
├── Tests/            # CppUTest test files
├── CMakeLists.txt    # Root build definition
└── CMakePresets.json # Named build presets
```

Replace the example source files in `Interface/`, `Source/`, and `Tests/` with your own code. The build system picks up all `.c` / `.cpp` files automatically via `file(GLOB ...)`.

## Prerequisites

The intended environment is the [davidcozens/cpputest](https://hub.docker.com/repository/docker/davidcozens/cpputest) Docker container, which has all dependencies pre-installed. A `.devcontainer` configuration is included for use with VS Code Dev Containers or GitHub Codespaces.

If building outside the container you will need:
- CMake 3.25+
- A C11/C++17 compiler
- CppUTest
- lcov and genhtml (for the coverage preset)
- clang-tidy (for the tidy preset)

## Builds

All builds use CMake presets. Output goes to `build/<preset>/`.

### TDD loop — `debug`

The everyday build for writing and running tests.

```bash
cmake --preset debug
cmake --build --preset debug && ctest --preset debug
```

In VS Code, **Ctrl+Shift+B** runs this and reports pass/fail in the terminal.

### Sanitizers — `sanitize`

Catches memory errors, use-after-free, and undefined behaviour at runtime.

```bash
cmake --preset sanitize
cmake --build --preset sanitize && ctest --preset sanitize
```

### Coverage — `coverage`

Generates an HTML coverage report for the library source.

```bash
cmake --preset coverage
cmake --build --preset coverage --target coverage
```

Open `build/coverage/coverage_report/index.html` in a browser to view the results.

### Static analysis — `tidy`

Runs clang-tidy on all source files as part of the build. All warnings are treated as errors. Checks are configured in [.clang-tidy](.clang-tidy).

```bash
cmake --preset tidy
cmake --build --preset tidy
```

### JUnit XML output

The `junit` target runs the tests and writes a JUnit-format XML file to the build directory. This is used by the VS Code test explorer and the CI pipeline.

```bash
cmake --build --preset debug --target junit
```

## CI

GitHub Actions runs four jobs in parallel on every push and pull request to `main`:

| Job | Preset | Reported in GitHub |
|---|---|---|
| Build and test | `debug` | Test results annotated on PR |
| Sanitizers | `sanitize` | Test results annotated on PR |
| Coverage | `coverage` | Summary in Actions UI + downloadable HTML artifact |
| Static analysis | `tidy` | Pass/fail check with errors in job log |

## Installing the library

```bash
cmake --preset release
cmake --build --preset release
cmake --install build/release --prefix /your/install/path
```

This installs the static library to `lib/` and the public headers to `include/`.

## License

Copyright 2026 Cozens Software Solutions Limited.

Licensed under the [PolyForm Noncommercial License 1.0.0](LICENSE.md). Free for noncommercial, personal, educational, and government use.

For commercial licensing enquiries, please use the contact form at [cososo.co.uk](https://www.cososo.co.uk/#contact).

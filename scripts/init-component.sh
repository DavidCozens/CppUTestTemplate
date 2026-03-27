#!/bin/bash
# init-component.sh <ComponentName>
#
# Run once after cloning CppUTestTemplate to rename the project and replace the
# example source files with a failing stub ready for TDD.
#
# ComponentName must be PascalCase, e.g. LedDriver, MotorController.

set -euo pipefail

COMPONENT="${1:-}"

if [[ -z "$COMPONENT" ]]; then
    echo "Usage: $0 <ComponentName>"
    echo "  e.g. $0 LedDriver"
    exit 1
fi

if ! [[ "$COMPONENT" =~ ^[A-Z][A-Za-z0-9]*$ ]]; then
    echo "Error: ComponentName must be PascalCase with no spaces or underscores (e.g. LedDriver)"
    exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Initialising component: $COMPONENT"

# --- CMakeLists.txt: rename project ---------------------------------------
sed -i "s/project(Example /project($COMPONENT /" "$ROOT/CMakeLists.txt"
echo "  Updated CMakeLists.txt"

# --- .vscode/launch.json: update test binary path -------------------------
sed -i "s/Tests\/ExampleTests/Tests\/${COMPONENT}Tests/" "$ROOT/.vscode/launch.json"
echo "  Updated .vscode/launch.json"

# --- .devcontainer/devcontainer.json: update name and workspaceFolder -----
sed -i "s/\"name\": \"CppUTestTemplate\"/\"name\": \"$COMPONENT\"/" "$ROOT/.devcontainer/devcontainer.json"
sed -i "s|/workspaces/CppUTestTemplate|/workspaces/$COMPONENT|g" "$ROOT/.devcontainer/devcontainer.json"
echo "  Updated .devcontainer/devcontainer.json"

# --- .devcontainer/docker-compose.yml: update volume mount and working_dir -
sed -i "s|/workspaces/CppUTestTemplate|/workspaces/$COMPONENT|g" "$ROOT/.devcontainer/docker-compose.yml"
echo "  Updated .devcontainer/docker-compose.yml"

# --- README.md: update title and one-liner --------------------------------
sed -i "s/^# CppUTestTemplate$/# $COMPONENT/" "$ROOT/README.md"
sed -i "s/\[component description\]/[TODO: describe $COMPONENT here]/" "$ROOT/README.md"
echo "  Updated README.md"

# --- Remove example source files ------------------------------------------
rm -f "$ROOT/Interface/ExampleC.h" "$ROOT/Interface/ExampleCpp.h"
rm -f "$ROOT/Source/ExampleC.c" "$ROOT/Source/ExampleCpp.cpp"
rm -f "$ROOT/Tests/ExampleCTests.cpp" "$ROOT/Tests/ExampleCppTests.cpp"
echo "  Removed example source, header, and test files"

# --- Source/CMakeLists.txt: replace source file list ----------------------
sed -i "/^set(SOURCES/,/^)/{ /ExampleC\.c/d; /ExampleCpp\.cpp/d; /^set(SOURCES/a\\    ${COMPONENT}.c
}" "$ROOT/Source/CMakeLists.txt"
echo "  Updated Source/CMakeLists.txt"

# --- Tests/CMakeLists.txt: replace test file list -------------------------
sed -i "/^set(TEST_SOURCES/,/^)/{ /ExampleCTests\.cpp/d; /ExampleCppTests\.cpp/d; /^set(TEST_SOURCES/a\\    ${COMPONENT}Test.cpp
}" "$ROOT/Tests/CMakeLists.txt"
echo "  Updated Tests/CMakeLists.txt"

# --- Create stub header ---------------------------------------------------
cat > "$ROOT/Interface/${COMPONENT}.h" << EOF
#ifndef ${COMPONENT^^}_H
#define ${COMPONENT^^}_H

#ifdef __cplusplus
extern "C"
{
#endif

    void ${COMPONENT}_Create(void);
    void ${COMPONENT}_Destroy(void);

#ifdef __cplusplus
}
#endif

#endif /* ${COMPONENT^^}_H */
EOF
echo "  Created Interface/${COMPONENT}.h"

# --- Create stub source ---------------------------------------------------
cat > "$ROOT/Source/${COMPONENT}.c" << EOF
#include "${COMPONENT}.h"

void ${COMPONENT}_Create(void)
{
}

void ${COMPONENT}_Destroy(void)
{
}
EOF
echo "  Created Source/${COMPONENT}.c"

# --- Create failing test --------------------------------------------------
cat > "$ROOT/Tests/${COMPONENT}Test.cpp" << EOF
#include "CppUTest/TestHarness.h"
#include "${COMPONENT}.h"

// clang-format off
TEST_GROUP(${COMPONENT})
{
    void setup() override
    {
        ${COMPONENT}_Create();
    }

    void teardown() override
    {
        ${COMPONENT}_Destroy();
    }
};
// clang-format on

TEST(${COMPONENT}, NeedsWork)
{
    FAIL("${COMPONENT} - start here");
}
EOF
echo "  Created Tests/${COMPONENT}Test.cpp"

echo ""
echo "Done. Next steps:"
echo "  1. cmake --preset \$BUILD_PRESET && cmake --build --preset \$BUILD_PRESET --target junit"
echo "     (expect one failing test — that is correct)"
echo "  2. Begin TDD: make the failing test pass, then write the next test"

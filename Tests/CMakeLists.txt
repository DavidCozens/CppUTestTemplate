file(GLOB TEST_SOURCES CONFIGURE_DEPENDS *.cpp)

add_executable(${PROJECT_NAME}Tests ${TEST_SOURCES})

target_link_libraries(${PROJECT_NAME}Tests PRIVATE ${PROJECT_NAME} CppUTest CppUTestExt pthread)

# Standard CppUTest console output via ctest -V
add_test(NAME ${PROJECT_NAME}Tests COMMAND ${PROJECT_NAME}Tests)

# JUnit XML output for CI and the VS Code test explorer.
# Uses a cmake script so test failures (non-zero exit) don't abort the target.
add_custom_target(junit
    COMMAND ${CMAKE_COMMAND}
        -DEXECUTABLE=$<TARGET_FILE:${PROJECT_NAME}Tests>
        -DDIR=${CMAKE_BINARY_DIR}
        -P ${CMAKE_CURRENT_SOURCE_DIR}/run_junit.cmake
    DEPENDS ${PROJECT_NAME}Tests
    COMMENT "Running tests with JUnit XML output"
)

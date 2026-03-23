# Runs the test executable with JUnit XML output.
# Test failures are expected - we want the XML written regardless of pass/fail.
execute_process(
    COMMAND ${EXECUTABLE} -ojunit
    WORKING_DIRECTORY ${DIR}
)

#include "CppUTest/TestHarness.h"
#include "ExampleC.h"

TEST_GROUP(FirstTestGroup){};

TEST(FirstTestGroup, FirstTest)
{
    LONGS_EQUAL(42, answer());
}

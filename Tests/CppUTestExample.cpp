#include "CppUTest/TestHarness.h"
#include "Example.h"

TEST_GROUP(FirstTestGroup)
{
};

TEST(FirstTestGroup, FirstTest)
{
   LONGS_EQUAL(42, Example().answer());
}


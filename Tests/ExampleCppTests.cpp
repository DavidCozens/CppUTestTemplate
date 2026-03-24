#include "CppUTest/TestHarness.h"
#include "ExampleCpp.h"

TEST_GROUP(AdderGroup){};

TEST(AdderGroup, AddsTwoAndThreeToFive)
{
    LONGS_EQUAL(5, add(2, 3));
}

TEST(AdderGroup, AddsOneAndOneToTwo)
{
    LONGS_EQUAL(2, add(1, 1));
}

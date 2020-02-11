#include "unity_fixture.h"
#include "unity.h"

TEST_GROUP(MOD);

TEST_SETUP(MOD){
}

TEST_TEAR_DOWN(MOD){
}

TEST(MOD,FAILEDTEST){
    TEST_ASSERT_EQUAL(0,1);
}

#include <gtest/gtest.h>
#include "demo.h"

TEST(DemoTest, Init) {
	// 1. Setup
	Demo dut(100);

	// 2. Execute

	// 3. Verify
	EXPECT_FALSE(dut.periodElapsed());
}

TEST(DemoTest, Update) {
	// 1. Setup
	Demo dut(100);

	// 2. Execute & verify
	EXPECT_FALSE(dut.periodElapsed());
	dut.update(99);
	EXPECT_FALSE(dut.periodElapsed());
	dut.update(100);
	EXPECT_TRUE(dut.periodElapsed());
	dut.update(101);
	EXPECT_FALSE(dut.periodElapsed());
	dut.update(200);
	EXPECT_TRUE(dut.periodElapsed());
}
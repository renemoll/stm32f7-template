enable_testing()

add_executable(recorder_test
	test_compiler_status.cpp
	test_demo.cpp
)
target_link_libraries(recorder_test
	recorder_lib
	GTest::gtest_main
)
bob_configure_test(recorder_test)

include(GoogleTest)
gtest_discover_tests(recorder_test)

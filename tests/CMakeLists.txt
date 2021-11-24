enable_testing()

add_executable(recorder_test
	test_demo.cpp
)

target_link_libraries(recorder_test
	recorder_lib
	gtest_main
)

include(GoogleTest)
gtest_discover_tests(recorder_test)

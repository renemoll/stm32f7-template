enable_testing()

add_executable(recorder_test
	test_demo.cpp
)

target_link_libraries(recorder_test
	recorder_lib
	gtest_main
)

set_target_properties(recorder_test
	PROPERTIES
		C_CLANG_TIDY ""
		CXX_CLANG_TIDY ""
)

include(GoogleTest)
gtest_discover_tests(recorder_test)

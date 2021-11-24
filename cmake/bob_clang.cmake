if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
	option(BOB_CLANG_TIDY "Enable clang-tidy." ON)
	if (${BOB_CLANG_TIDY})
		message(STATUS "Enabling 'clang-tidy'")
		set(CMAKE_C_CLANG_TIDY "clang-tidy")
		set(CMAKE_CXX_CLANG_TIDY "clang-tidy")
	endif()

	# option(BOB_CPPCHECK "Enable cppcheck." ON)
	# if (${BOB_CPPCHECK})
	# 	message(STATUS "Enabling 'cppcheck'")
	# 	set(CMAKE_C_CPPCHECK "cppcheck;--std=c11")
	# 	set(CMAKE_CXX_CPPCHECK "cppcheck;--std=c++20")
	# endif()

	# message(STATUS "Enabling 'cpplint'")
	# set(CMAKE_C_CPPLINT "python -m cpplint")
	# set(CMAKE_CXX_CPPLINT "cpplint")

	# message(STATUS "Enabling 'include what you use'")
	# set(CMAKE_C_INCLUDE_WHAT_YOU_USE "")
	# set(CMAKE_CXX_INCLUDE_WHAT_YOU_USE "")

	# message(STATUS "Enabling 'link what you use'")
	# set(CMAKE_LINK_WHAT_YOU_USE "")

	# option(BOB_SANITIZE_MEMORY "Enable the memory sanitizer." OFF)
	# if (${BOB_SANITIZE_MEMORY})
	# 	add_compile_options(
	# 		-fsanitize=memory
	# 		-fno-optimize-sibling-calls
	# 		-fsanitize-memory-track-origins=2
	# 		-fsanitize-memory-use-after-dtor
	# 	)
	# endif()

	# option(BOB_SANITIZE_UB "Enable the undefined behavior sanitizer." OFF)
	# if (${BOB_SANITIZE_UB})
	# 	add_compile_options(
	# 		-fsanitize=undefined
	# 	)
	# endif()

	# option(BOB_SANITIZE_ADDRESS "Enable the address sanitizer." OFF)
	# if (${BOB_SANITIZE_ADDRESS})
	# 	add_compile_options(
	# 		-fsanitize=address
	# 		-fno-optimize-sibling-calls
	# 	)
	# endif()

	# option(BOB_SANITIZE_ADDRESS "Enable the memory leak sanitizer." OFF)
	# if (${BOB_SANITIZE_ADDRESS})
	# 	add_compile_options(
	# 		-fsanitize=leak
	# 	)
	# endif()
endif()

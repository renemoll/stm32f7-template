include(FetchContent)

FetchContent_Declare(
	googletest
	URL https://github.com/google/googletest/archive/16f637fbf4ffc3f7a01fa4eceb7906634565242f.zip
)

# For Windows: Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

if (NOT ${CMAKE_CROSSCOMPILING})
	FetchContent_MakeAvailable(googletest)
endif()

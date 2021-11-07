#
# Meet Bob: my collection of build tools
#

include(cmake/bob_clang.cmake)
include(cmake/bob_options.cmake)

function(bob_configure_target target)
	# Todo:
	# - Add stack protector and buffer overflow detection?
	bob_configure_options(${target})

	if((CMAKE_CXX_COMPILER_ID STREQUAL "GNU") OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang"))
		# Compiler warnings
		target_compile_options(${target}
			PRIVATE
				-Wall
				-Wextra
				-Werror
				-Wconversion
				-Wsign-conversion
				-Wdouble-promotion
				-Wfloat-equal
				$<$<CXX_COMPILER_ID:GNU>:-Warith-conversion>
				$<$<AND:$<CXX_COMPILER_ID:GNU>,$<COMPILE_LANGUAGE:CXX>>:-Wsuggest-override>
				-Wshadow
				$<$<CXX_COMPILER_ID:Clang>:-Wshadow-all>
				$<$<CXX_COMPILER_ID:GNU>:-Wduplicated-branches>
				$<$<CXX_COMPILER_ID:GNU>:-Wduplicated-cond>
				-Wswitch-enum
				-Wnull-dereference
				-Wpedantic
				-Wvla
				-Wcast-qual
				-Wpointer-arith
				-Wwrite-strings
				-Wcast-align
				$<$<CXX_COMPILER_ID:GNU>:-Wredundant-decls>
				-Wformat=2
				$<$<CXX_COMPILER_ID:GNU>:-Wformat-truncation>
				-Wundef
		)

		# Code generation options
		target_compile_options(${target}
			PRIVATE
				$<$<COMPILE_LANGUAGE:CXX>:-fdiagnostics-show-template-tree>
				-fno-common
				# -fomit-frame-pointer (conflicts with sanitizers)
				$<$<CXX_COMPILER_ID:GNU>:-fstack-usage>
				-fwrapv
				$<$<COMPILE_LANGUAGE:ASM>:"-x assembler-with-cpp">
		)
	else()
		message(FATAL_ERROR "Unsupported compiler")
	endif()

	set_target_properties(${target}
		PROPERTIES
			DEBUG_POSTFIX "d"
			RELWITHDEBINFO_POSTFIX "rd"
	)
endfunction()
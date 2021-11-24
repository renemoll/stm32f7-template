#
# Meet Bob: my collection of build tools
#

include(cmake/bob_clang.cmake)
include(cmake/bob_options.cmake)

if((CMAKE_CXX_COMPILER_ID STREQUAL "GNU") OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang"))
	add_compile_options(
		$<$<CONFIG:DEBUG>:-g3>		# Generate as much debug information as available for debug builds.
	#	$<$<CONFIG:DEBUG>:-Og>		# Optimize for debugging in debug builds.
		$<$<CONFIG:RELEASE>:-O3>	# Heavy optimization for release builds.
		# GCC: Os?
		# Clang: Oz?
	)
else()
	message(FATAL_ERROR "Unsupported compiler")
endif()

add_compile_definitions(
	$<$<CONFIG:DEBUG>:DEBUG>	# Generate a DEBUG define for debug builds.
)

function(bob_configure_target target)
	# Todo:
	# - Add stack protector and buffer overflow detection?
	bob_configure_options(${target})

	if((CMAKE_CXX_COMPILER_ID STREQUAL "GNU") OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang"))
		# Compiler warnings
		target_compile_options(${target}
			PRIVATE
				-Wall												# Enable warnings for common coding mistakes or potential errors.
				-Wextra												# Extensions for -Wall.
				-Werror												# Treat warnings as errors to fail the build in case of warnings.
				-Wpedantic											# Warn for now standard C++.
				-Wconversion										# Warn about implicit type conversions which (may) change the value.
				-Wsign-conversion									# Warn about implicit sign conversions.
				-Wdouble-promotion									# Warn about floats being implictly converted to doubles.
				-Wfloat-equal										# Warn about floatint point values used in equality tests.
				$<$<CXX_COMPILER_ID:GNU>:-Warith-conversion>		# Warn about implicit type conversions during arithmitic operations.
				-Wpointer-arith										# Warn when sizeof(void) is used (directly or indirectly).
				$<$<COMPILE_LANGUAGE:CXX>:-Wold-style-cast>			# Warn about C-style casts.
				-Wcast-qual											# Warn when casting removes a type qualifier from a pointer.
				$<$<AND:$<CXX_COMPILER_ID:GNU>,$<COMPILE_LANGUAGE:CXX>>:-Wuseless-cast>		# Warn about casting to the same type.
				-Wcast-align										# Warn when casting a pointers changes the alignment of the pointee.
				$<$<COMPILE_LANGUAGE:C>:-Wbad-function-cast>		# Warn about casts to function pointers.
				$<$<COMPILE_LANGUAGE:CXX>:-Wnon-virtual-dtor>		# Warn about base classes without virtual destructors.
				$<$<AND:$<CXX_COMPILER_ID:GNU>,$<COMPILE_LANGUAGE:CXX>>:-Wsuggest-override>	# Warn when a method overwriting a virtual method is not marked with override.
				-Wshadow											# Warn about duplicated variable names
				$<$<CXX_COMPILER_ID:Clang>:-Wshadow-all>
				$<$<COMPILE_LANGUAGE:CXX>:-Woverloaded-virtual>		# Warn when a derived function hides a virtual function of the base class.
				$<$<CXX_COMPILER_ID:GNU>:-Wduplicated-branches>		# Warn about identifcal branches in if-else expressions.
				$<$<CXX_COMPILER_ID:GNU>:-Wduplicated-cond>			# Warn about duplicated conditions in if-else expressions.
				$<$<CXX_COMPILER_ID:GNU>:-Wredundant-decls>			# Warn about multiple declarations within the same scope.
				-Wswitch-enum										# Warn about switch statements not using all possible enum values.
				-Wimplicit-fallthrough								# Warn about implicit, un-annotated, fallthroughs.
				-Wnull-dereference									# Warn about possible null pointer dereference code paths.
				-Wvla												# Warn about variable-length arrays being used.
				-Wwrite-strings										# Warn when attempting to write to a string constant.
				-Wformat=2											# Verify printf/scanf/.. arguments and format strings match.
				$<$<CXX_COMPILER_ID:GNU>:-Wformat-truncation=2>		# Warn when the output of sprintf/... might be truncated.
				-Wundef												# Warn when undefined macros are used (implicit conversion to 0.)
				$<$<CXX_COMPILER_ID:GNU>:-Wlogical-op>				# Warn about potential errors with logical operations.
				$<$<COMPILE_LANGUAGE:C>:-Wstrict-prototypes>		# Warn when a function declaration misses argument types.
				-Wunused											# Warn about any unused parameter/function/variable/etc...
				$<$<CXX_COMPILER_ID:GNU>:-Wmisleading-indentation>	# Warn about indentation giving the impression of scope.
		)

		# Code generation options
		target_compile_options(${target}
			PRIVATE
				# $<$<COMPILE_LANGUAGE:ASM>:"-x assembler-with-cpp">
				$<$<CXX_COMPILER_ID:GNU>:-fstack-usage>						# Generate stack depth information.
				$<$<CXX_COMPILER_ID:GNU>:-fvar-tracking-assignments>		# Attempt to improve debugging by annotating variable assignment.
				$<$<COMPILE_LANGUAGE:CXX>:-fdiagnostics-show-template-tree>	# Print template structures in a tree structure.
				-fno-common			# Warn when global variables are not unique (and unintentionaly merged.)
				# -fomit-frame-pointer (conflicts with sanitizers)
				-fwrapv				# Assume signed arithmatic may wrap around.
		)

		target_link_options(${target}
			PRIVATE
				LINKER:--fatal-warnings
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
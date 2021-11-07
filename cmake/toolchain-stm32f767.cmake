set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Compiler selection
find_program(CROSS_GCC_PATH "arm-none-eabi-gcc" PATH "/opt/gcc-arm-none-eabi-10.3-2021.10/bin")
get_filename_component(TOOLCHAIN ${CROSS_GCC_PATH} PATH)

set(CMAKE_C_COMPILER ${TOOLCHAIN}/arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN}/arm-none-eabi-g++)
set(TOOLCHAIN_SIZE ${TOOLCHAIN}/arm-none-eabi-size CACHE STRING "arm-none-eabi-size")

# CMAKE configuration
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Compiler configuration
set(ARM_API -mcpu=cortex-m7 -mfloat-abi=hard -mfpu=fpv5-d16 -mthumb -mabi=aapcs)
add_compile_options(
	${ARM_API}
	--specs=nano.specs				# newlib
	# Sectioning
	-ffunction-sections
	-fdata-sections
	$<$<CONFIG:DEBUG>:-gdwarf>
)

add_link_options(
	${ARM_API}
	# -nostartfiles
	--specs=nano.specs
	--specs=nosys.specs
	LINKER:--gc-sections
	LINKER:--build-id
	LINKER:--cref
)
# linker:-–specs rdimon.specs -> semihosting (do I really want this?)

add_compile_definitions(
	STM32F767xx
	USE_FULL_LL_DRIVER
)

function(bob_firmware_image target)
	set(LINKER_SCRIPTS
		${CMAKE_SOURCE_DIR}/src/system/memory.ld
		${CMAKE_SOURCE_DIR}/src/system/sections.ld
	)

	target_link_options(${target} PRIVATE
		-T${CMAKE_SOURCE_DIR}/src/system/memory.ld
		-T${CMAKE_SOURCE_DIR}/src/system/sections.ld
		LINKER:--print-memory-usage
		LINKER:-Map=$<TARGET_FILE:${target}>.map
	)

	set_target_properties(${target}
		PROPERTIES
			SUFFIX .elf
		LINK_DEPENDS "${LINKER_SCRIPTS}"
	)

	add_custom_command(
		TARGET ${target}
  		POST_BUILD
  		COMMAND ${CMAKE_OBJCOPY} -O ihex $<TARGET_FILE:${target}>
			${CMAKE_CURRENT_BINARY_DIR}/$<TARGET_NAME:${target}>.hex
	)

	add_custom_command(
		TARGET ${target}
  		POST_BUILD
  		COMMAND ${CMAKE_OBJCOPY} -I elf32-littlearm -O binary $<TARGET_FILE:${target}>
			${CMAKE_CURRENT_BINARY_DIR}/$<TARGET_NAME:${target}>.bin
	)

	add_custom_command(
		TARGET ${target}
		POST_BUILD
		COMMAND ${TOOLCHAIN_SIZE} --format=berkeley $<TARGET_FILE:${target}>
			> ${CMAKE_CURRENT_BINARY_DIR}/$<TARGET_NAME:${target}>.bsz
	)
	add_custom_command(
		TARGET ${target}
		POST_BUILD
		COMMAND ${TOOLCHAIN_SIZE} --format=sysv -x $<TARGET_FILE:${target}>
				>${CMAKE_CURRENT_BINARY_DIR}/$<TARGET_NAME:${target}>.ssz
	)
endfunction()

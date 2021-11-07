
add_library(recorder_lib
	demo.cpp
)
target_include_directories(recorder_lib
	PUBLIC
		${PROJECT_SOURCE_DIR}/include/
	PRIVATE
		${PROJECT_BINARY_DIR}
)
bob_configure_target(recorder_lib)

if (CMAKE_CROSSCOMPILING)
	add_library(stm32f7_system OBJECT
		${stm32cubef7_SOURCE_DIR}/Drivers/CMSIS/Device/ST/STM32F7xx/Source/Templates/system_stm32f7xx.c
		${stm32cubef7_SOURCE_DIR}/Drivers/CMSIS/Device/ST/STM32F7xx/Source/Templates/gcc/startup_stm32f767xx.s
	)
	target_include_directories(stm32f7_system
		PUBLIC
			${stm32cubef7_SOURCE_DIR}/Drivers/CMSIS/Core/Include
			${stm32cubef7_SOURCE_DIR}/Drivers/CMSIS/Device/ST/STM32F7xx/Include
			${stm32cubef7_SOURCE_DIR}/Drivers/STM32F7xx_HAL_Driver/Inc
	)

	add_executable(recorder_app
		${stm32cubef7_SOURCE_DIR}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_ll_gpio.c
		${stm32cubef7_SOURCE_DIR}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_ll_utils.c
		build_id.cpp
		main.cpp
	)
	target_link_libraries(recorder_app
		PUBLIC
			recorder_lib
		PRIVATE
			stm32f7_system
	)
	target_include_directories(recorder_app
		PUBLIC
			${PROJECT_BINARY_DIR}
	)
	target_compile_options(recorder_app
		PRIVATE
			# STM32 HAL code does not comply with my coding style, so removing a number of checks.
			$<$<AND:$<CXX_COMPILER_ID:GNU>,$<COMPILE_LANGUAGE:CXX>>:-Wno-volatile>
			-Wno-unused-parameter
	)
	target_compile_features(recorder_app
		PUBLIC
			cxx_std_20
	)

	bob_configure_target(recorder_app)
	bob_firmware_image(recorder_app)
endif()
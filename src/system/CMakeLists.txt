
if (${CMAKE_CROSSCOMPILING})
	# Create an "object" library to preserve the weak symbols used for IRQ handlers.
	add_library(stm32f7_system OBJECT
		${stm32cubef7_SOURCE_DIR}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_ll_utils.c
		clock.cpp
		reset_handler.s
		vector_table.cpp
		system.cpp
	)
	target_include_directories(stm32f7_system
		PUBLIC
			${stm32cubef7_SOURCE_DIR}/Drivers/CMSIS/Core/Include
			${stm32cubef7_SOURCE_DIR}/Drivers/CMSIS/Device/ST/STM32F7xx/Include
			${stm32cubef7_SOURCE_DIR}/Drivers/STM32F7xx_HAL_Driver/Inc
	)
	target_compile_features(stm32f7_system
		PRIVATE
			cxx_relaxed_constexpr
			cxx_std_20
	)
	bob_configure_target(stm32f7_system)
	target_compile_options(stm32f7_system
		PRIVATE
			$<$<AND:$<CXX_COMPILER_ID:GNU>,$<COMPILE_LANGUAGE:CXX>>:-Wno-volatile>
			$<$<AND:$<CXX_COMPILER_ID:GNU>,$<COMPILE_LANGUAGE:CXX>>:-Wno-useless-cast>
			-Wno-unused-parameter
			$<$<COMPILE_LANGUAGE:CXX>:-Wno-old-style-cast>
			-Wno-pedantic
	)
endif()

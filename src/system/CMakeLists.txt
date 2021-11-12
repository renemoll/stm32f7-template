
if (CMAKE_CROSSCOMPILING)
	# Create an "object" library to preserve the weak symbols used for IRQ handlers.
	add_library(stm32f7_system OBJECT
		reset_handler.s
		vector_table.cpp
		system.cpp
		${stm32cubef7_SOURCE_DIR}/Drivers/CMSIS/Device/ST/STM32F7xx/Source/Templates/system_stm32f7xx.c
	)
	target_include_directories(stm32f7_system
		PUBLIC
			${stm32cubef7_SOURCE_DIR}/Drivers/CMSIS/Core/Include
			${stm32cubef7_SOURCE_DIR}/Drivers/CMSIS/Device/ST/STM32F7xx/Include
			${stm32cubef7_SOURCE_DIR}/Drivers/STM32F7xx_HAL_Driver/Inc
	)
	# bob_configure_target(stm32f7_system)
endif()

include(FetchContent)

# BEWARE: I forked this repository to reduce the repo size and improve CI speed
FetchContent_Declare(
	stm32cubef7
	URL https://github.com/renemoll/STM32CubeF7/archive/refs/heads/master.zip
)
FetchContent_MakeAvailable(stm32cubef7)

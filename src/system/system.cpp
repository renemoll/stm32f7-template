
#include "system.h"

#include <algorithm>
#include <cinttypes>

extern uint32_t __data_dest_start__;
extern uint32_t __data_dest_end__;
extern uint32_t __data_src__;

extern uint32_t __bss_start__;
extern uint32_t __bss_end__;

extern int main();

namespace
{
void copy_data_section()
{
	const auto count = (&__data_dest_end__ - &__data_dest_start__);
	std::copy(&__data_src__, &__data_src__ + count, &__data_dest_start__);
}

void zero_bss_section()
{
	std::fill(&__bss_start__, &__bss_end__, 0u);
}
}

/*
 * Enable caches
 * Enable FPU
 * Enable prefetch?
 * Enable TCM
 */

void __initialize_platform()
{
	/*
	 * Reset clocks
	 */

	// Enable FPU when the compiler is configured to use it.
#if (__FPU_PRESENT == 1) && (__FPU_USED == 1)
	SCB->CPACR |= ((3UL << 10*2)|(3UL << 11*2));
#endif

/*
#if defined(USER_VECT_TAB_ADDRESS)
	SCB->VTOR = VECT_TAB_BASE_ADDRESS | VECT_TAB_OFFSET;
#endif
*/
}

void __prepare_environment()
{
	/*
	 * Copy from FLASH to RAM - data section
	 * Fill bss
	 * Call constructors
	 */
	copy_data_section();
	zero_bss_section();

	//!\todo constructors
}

void __start()
{
	/*
	 * Call to main
	 * Handle return from main
	 */
	main();
}
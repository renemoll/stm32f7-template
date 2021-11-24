
#include "config.h"

#include <stm32f7xx.h>
#include <stm32f7xx_ll_bus.h>
#include <stm32f7xx_ll_gpio.h>

#include "demo.h"

Demo g_demo(500000);

void initGpio()
{
	LL_AHB1_GRP1_EnableClock(LL_AHB1_GRP1_PERIPH_GPIOB);

	LL_GPIO_InitTypeDef init = {};
	LL_GPIO_StructInit(&init);
	init.Pin = LL_GPIO_PIN_7;
	init.Mode = LL_GPIO_MODE_OUTPUT;
	LL_GPIO_Init(GPIOB, &init);
	LL_GPIO_ResetOutputPin(GPIOB, LL_GPIO_PIN_7);
}

/*
 * NUCLEO-F767ZI has a blue LED on PB7, we will be toggling that LED at 10Hz.
 */
int main()
{
	initGpio();

	while(true) {
		if (g_demo.periodElapsed()) {
			LL_GPIO_TogglePin(GPIOB, LL_GPIO_PIN_7);
		}
	}
}

extern "C" {
void SysTick_Handler()
{
	static uint32_t count = 0;
	++count;
	g_demo.update(count);
}
}
# STM32F7 template


# How to build

> python build.py

Note: this system uses Docker images to build the source code.

## Host build

## Target build

> python .\build.py --container stm32




# Wishlist

* Have a look at [https://interrupt.memfault.com/blog/static-analysis-with-codechecker](Firmware Static Analysis with CodeChecker).
* Have a look at cppcheck.
* Checkout [puncover](https://github.com/HBehrens/puncover) for code size analysis.
* Checkout [clang-blueprint](https://github.com/johnthagen/clang-blueprint)
* Checkout [cmake-scripts](https://github.com/StableCoder/cmake-scripts)
* Valgrind
* code coverage

# todo

* import demo application
* selectivly git clone (specific folders...)
* split toolchain file into stm32f7 family and specific MCU
![Host workflow](https://github.com/renemoll/stm32f7-template/actions/workflows/build-host.yml/badge.svg)
![Target workflow](https://github.com/renemoll/stm32f7-template/actions/workflows/build-target.yml/badge.svg)

# STM32F7 template


# How to build

All build options are available through the provided build script: `build.py`. 

The build system supports using containers to provide the required toolchain, current support:
* Host build using Clang: `python build.py --container host`
* Target build using `arm-gcc-none-eabi`: `python build.py --container stm32`

> To use your local toolchain, simply remove the `--container` flag.

# Wishlist

* Have a look at [Firmware Static Analysis with CodeChecker](https://interrupt.memfault.com/blog/static-analysis-with-codechecker).
* Have a look at cppcheck.
* Checkout [puncover](https://github.com/HBehrens/puncover) for code size analysis.
* Checkout [clang-blueprint](https://github.com/johnthagen/clang-blueprint)
* Checkout [cmake-scripts](https://github.com/StableCoder/cmake-scripts)
* Valgrind
* code coverage

# Todo

* import demo application
* split toolchain file into stm32f7 family and specific MCU

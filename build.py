import argparse
import enum
import subprocess
import pathlib


class Target(enum.Enum):
	LINUX = 1
	STM32 = 2

	def __str__(self):
		return self.name.lower()


def build_system_cmd(folder):
	return ["cmake",
		"-B", "build/{}".format(folder),
		"-S", ".",
		"-G", "Ninja",
		"-DCMAKE_BUILD_TYPE=Debug"
		# "–warn-uninitialized"
		# "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
	]

def build_project_cmd(folder):
	return ["cmake", "--build", "build/{}".format(folder)]

def build_stm32():
	return ["-DCMAKE_TOOLCHAIN_FILE=cmake/toolchain-stm32f767.cmake"]

def build_in_docker(target):
	"""
	Todo:
	- container depends on target.
	"""
	if target == Target.STM32:
		return ["docker",
			"run",
			"--rm",
			"-v", "{}:/work/".format(cwd),
			"renemoll/builder_arm_gcc"]
	else:
		return ["docker",
			"run",
			"--rm",
			"-v", "{}:/work/".format(cwd),
			"renemoll/builder_clang"]


if __name__ == "__main__":
	"""
	Todo:
	- build folders?
	- Add ninja? (-G Ninja, what is the impact/use?)
	- clean option (cmake --build build/... --target clean)
	- build type (-DCMAKE_BUILD_TYPE=DEBUG/RELEASE, --config Debug)
	- de-couple clang-tidy from Clang build?
	  	$ cmake -G Ninja -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
		$ clang-tidy-11 -format-style=file -header-filter=. -p build
	"""
	parser = argparse.ArgumentParser(description='Bob, the build system (builder).')
	parser.add_argument('target', type=str, help='the target to build for (host/stm32)')
	parser.add_argument('--container', dest='container', action='store_const', const=True, default=False, help='build inside a Docker container')
	args = parser.parse_args()

	cwd = pathlib.Path(__file__).parent.resolve()

	target = Target.STM32 if args.target.lower() == 'stm32' else Target.LINUX
	folder = 'stm32-debug' if target == Target.STM32 else 'linux64-debug'
	cmake_target = build_stm32() if target == Target.STM32 else []
	docker = build_in_docker(target) if args.container else []

	steps = build_system_cmd(folder)
	steps = docker + steps + cmake_target
	print(" ".join(steps))
	result = subprocess.run(steps)

	steps = build_project_cmd(folder)
	steps = docker + steps
	print(" ".join(steps))
	result = subprocess.run(steps)

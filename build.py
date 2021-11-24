"""

Build my application and tests
* build for host (Linux/Windows)
* build for target

Options:
- containerized
- type (debug/release)

Open issues:
- enter gdb
- run test-cases


idea:
* rename build to bob
* introduce subcommands:
  * bob build
  * bob debug
  * bob test
"""
import argparse
import enum
import logging
import subprocess
import pathlib


class Target(enum.Enum):
	Linux = 1
	Stm32 = 2
	Gdb = 3
	Windows = 4

	def __str__(self):
		return self.name.lower()

def build_system_cmd(folder, target):
	cmd = ["cmake",
		"-B", "build/{}".format(folder),
		"-S", ".",
		"-DCMAKE_BUILD_TYPE=Debug"
		# "-DCMAKE_BUILD_TYPE=Release"
		# "–warn-uninitialized"
		# "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
	]

	if target in (Target.Linux, Target.Stm32):
		cmd += [
			"-G", "Ninja",
		]

	return cmd


def build_project_cmd(folder):
	return ["cmake", "--build", "build/{}".format(folder)]

def build_stm32():
	return ["-DCMAKE_TOOLCHAIN_FILE=cmake/toolchain-stm32f767.cmake"]

def build_in_docker(target, cwd):
	"""
	Todo:
	- container depends on target.
	"""
	if target == Target.Stm32:
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

def build_gdb():
	"""
	Todo:
	- actually enter gdb
	- lldb?
	"""
	return [
		"docker",
		"run",
		"--rm",
		"-it",
		"-v", "{}:/work/".format(cwd),
		"renemoll/builder_arm_gcc",
		"/bin/bash"
	]


def bob(args):
	cwd = pathlib.Path(__file__).parent.resolve()
	logging.debug("Determined working directory: %s", cwd)

	def determine_target(name):
		"""
		- in case no target is defined, do not specify a generator to use the system's default. Attempt to detect? (or should I solve with CMake, which may know this stuff)
		"""
		try:
			key = name.lower().capitalize()
			return Target[key]
		except:
			return Target.Linux

	target = determine_target(args.target)
	logging.debug("Determined target: %s", target)

	def determine_output_folder(target):
		"""
		Todo:
		- support build config
		"""
		lookup = {
			Target.Stm32: 'stm32-debug',
			Target.Linux: 'linux64-debug',
			Target.Windows: 'win64-debug'
		}
		return lookup[target]

	if target == Target.Gdb:
		steps = build_gdb()
		print(" ".join(steps))
		result = subprocess.run(steps)
	else:
		folder = determine_output_folder(target)
		logging.debug("Determined output folder: %s", folder)

		cmake_target = build_stm32() if target == Target.Stm32 else []
		docker = build_in_docker(target, cwd) if args.container else []

		steps = build_system_cmd(folder, target)
		steps = docker + steps + cmake_target
		print(" ".join(steps))
		result = subprocess.run(steps)

		steps = build_project_cmd(folder)
		steps = docker + steps
		print(" ".join(steps))
		result = subprocess.run(steps)

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
	- parallel build jobs
	"""
	logging.basicConfig(
		level=logging.DEBUG,
		format="%(asctime)s - %(filename)s:%(lineno)s - %(levelname)s: %(message)s",
		datefmt='%Y.%m.%d %H:%M:%S'
	)

	parser = argparse.ArgumentParser(description='Bob, the build system (builder).')
	parser.add_argument('target', type=str, help='the target to build for (linux/windows/stm32)')
	parser.add_argument('--container', dest='container', action='store_const', const=True, default=False, help='build inside a Docker container')
	args = parser.parse_args()

	bob(args)

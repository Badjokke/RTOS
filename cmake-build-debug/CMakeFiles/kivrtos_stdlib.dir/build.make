# CMAKE generated file: DO NOT EDIT!
# Generated by "MinGW Makefiles" Generator, CMake Version 3.23

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

SHELL = cmd.exe

# The CMake executable.
CMAKE_COMMAND = "C:\Program Files\JetBrains\CLion 2022.2.3\bin\cmake\win\bin\cmake.exe"

# The command to remove a file.
RM = "C:\Program Files\JetBrains\CLion 2022.2.3\bin\cmake\win\bin\cmake.exe" -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = \\wsl$$\Ubuntu\home\trefil\sem\sources

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = \\wsl$$\Ubuntu\home\trefil\sem\sources\cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/kivrtos_stdlib.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/kivrtos_stdlib.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/kivrtos_stdlib.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/kivrtos_stdlib.dir/flags.make

CMakeFiles/kivrtos_stdlib.dir/stdlib/src/memory_manager.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/flags.make
CMakeFiles/kivrtos_stdlib.dir/stdlib/src/memory_manager.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/includes_CXX.rsp
CMakeFiles/kivrtos_stdlib.dir/stdlib/src/memory_manager.cpp.obj: ../stdlib/src/memory_manager.cpp
CMakeFiles/kivrtos_stdlib.dir/stdlib/src/memory_manager.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=\\wsl$$\Ubuntu\home\trefil\sem\sources\cmake-build-debug\CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/kivrtos_stdlib.dir/stdlib/src/memory_manager.cpp.obj"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/kivrtos_stdlib.dir/stdlib/src/memory_manager.cpp.obj -MF CMakeFiles\kivrtos_stdlib.dir\stdlib\src\memory_manager.cpp.obj.d -o CMakeFiles\kivrtos_stdlib.dir\stdlib\src\memory_manager.cpp.obj -c \\wsl$$\Ubuntu\home\trefil\sem\sources\stdlib\src\memory_manager.cpp

CMakeFiles/kivrtos_stdlib.dir/stdlib/src/memory_manager.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/kivrtos_stdlib.dir/stdlib/src/memory_manager.cpp.i"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E \\wsl$$\Ubuntu\home\trefil\sem\sources\stdlib\src\memory_manager.cpp > CMakeFiles\kivrtos_stdlib.dir\stdlib\src\memory_manager.cpp.i

CMakeFiles/kivrtos_stdlib.dir/stdlib/src/memory_manager.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/kivrtos_stdlib.dir/stdlib/src/memory_manager.cpp.s"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S \\wsl$$\Ubuntu\home\trefil\sem\sources\stdlib\src\memory_manager.cpp -o CMakeFiles\kivrtos_stdlib.dir\stdlib\src\memory_manager.cpp.s

CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdbuffer.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/flags.make
CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdbuffer.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/includes_CXX.rsp
CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdbuffer.cpp.obj: ../stdlib/src/stdbuffer.cpp
CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdbuffer.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=\\wsl$$\Ubuntu\home\trefil\sem\sources\cmake-build-debug\CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdbuffer.cpp.obj"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdbuffer.cpp.obj -MF CMakeFiles\kivrtos_stdlib.dir\stdlib\src\stdbuffer.cpp.obj.d -o CMakeFiles\kivrtos_stdlib.dir\stdlib\src\stdbuffer.cpp.obj -c \\wsl$$\Ubuntu\home\trefil\sem\sources\stdlib\src\stdbuffer.cpp

CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdbuffer.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdbuffer.cpp.i"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E \\wsl$$\Ubuntu\home\trefil\sem\sources\stdlib\src\stdbuffer.cpp > CMakeFiles\kivrtos_stdlib.dir\stdlib\src\stdbuffer.cpp.i

CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdbuffer.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdbuffer.cpp.s"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S \\wsl$$\Ubuntu\home\trefil\sem\sources\stdlib\src\stdbuffer.cpp -o CMakeFiles\kivrtos_stdlib.dir\stdlib\src\stdbuffer.cpp.s

CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdfile.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/flags.make
CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdfile.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/includes_CXX.rsp
CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdfile.cpp.obj: ../stdlib/src/stdfile.cpp
CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdfile.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=\\wsl$$\Ubuntu\home\trefil\sem\sources\cmake-build-debug\CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdfile.cpp.obj"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdfile.cpp.obj -MF CMakeFiles\kivrtos_stdlib.dir\stdlib\src\stdfile.cpp.obj.d -o CMakeFiles\kivrtos_stdlib.dir\stdlib\src\stdfile.cpp.obj -c \\wsl$$\Ubuntu\home\trefil\sem\sources\stdlib\src\stdfile.cpp

CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdfile.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdfile.cpp.i"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E \\wsl$$\Ubuntu\home\trefil\sem\sources\stdlib\src\stdfile.cpp > CMakeFiles\kivrtos_stdlib.dir\stdlib\src\stdfile.cpp.i

CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdfile.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdfile.cpp.s"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S \\wsl$$\Ubuntu\home\trefil\sem\sources\stdlib\src\stdfile.cpp -o CMakeFiles\kivrtos_stdlib.dir\stdlib\src\stdfile.cpp.s

CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdmutex.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/flags.make
CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdmutex.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/includes_CXX.rsp
CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdmutex.cpp.obj: ../stdlib/src/stdmutex.cpp
CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdmutex.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=\\wsl$$\Ubuntu\home\trefil\sem\sources\cmake-build-debug\CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdmutex.cpp.obj"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdmutex.cpp.obj -MF CMakeFiles\kivrtos_stdlib.dir\stdlib\src\stdmutex.cpp.obj.d -o CMakeFiles\kivrtos_stdlib.dir\stdlib\src\stdmutex.cpp.obj -c \\wsl$$\Ubuntu\home\trefil\sem\sources\stdlib\src\stdmutex.cpp

CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdmutex.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdmutex.cpp.i"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E \\wsl$$\Ubuntu\home\trefil\sem\sources\stdlib\src\stdmutex.cpp > CMakeFiles\kivrtos_stdlib.dir\stdlib\src\stdmutex.cpp.i

CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdmutex.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdmutex.cpp.s"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S \\wsl$$\Ubuntu\home\trefil\sem\sources\stdlib\src\stdmutex.cpp -o CMakeFiles\kivrtos_stdlib.dir\stdlib\src\stdmutex.cpp.s

CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdstring.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/flags.make
CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdstring.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/includes_CXX.rsp
CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdstring.cpp.obj: ../stdlib/src/stdstring.cpp
CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdstring.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=\\wsl$$\Ubuntu\home\trefil\sem\sources\cmake-build-debug\CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdstring.cpp.obj"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdstring.cpp.obj -MF CMakeFiles\kivrtos_stdlib.dir\stdlib\src\stdstring.cpp.obj.d -o CMakeFiles\kivrtos_stdlib.dir\stdlib\src\stdstring.cpp.obj -c \\wsl$$\Ubuntu\home\trefil\sem\sources\stdlib\src\stdstring.cpp

CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdstring.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdstring.cpp.i"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E \\wsl$$\Ubuntu\home\trefil\sem\sources\stdlib\src\stdstring.cpp > CMakeFiles\kivrtos_stdlib.dir\stdlib\src\stdstring.cpp.i

CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdstring.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdstring.cpp.s"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S \\wsl$$\Ubuntu\home\trefil\sem\sources\stdlib\src\stdstring.cpp -o CMakeFiles\kivrtos_stdlib.dir\stdlib\src\stdstring.cpp.s

CMakeFiles/kivrtos_stdlib.dir/stdutils/src/oled.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/flags.make
CMakeFiles/kivrtos_stdlib.dir/stdutils/src/oled.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/includes_CXX.rsp
CMakeFiles/kivrtos_stdlib.dir/stdutils/src/oled.cpp.obj: ../stdutils/src/oled.cpp
CMakeFiles/kivrtos_stdlib.dir/stdutils/src/oled.cpp.obj: CMakeFiles/kivrtos_stdlib.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=\\wsl$$\Ubuntu\home\trefil\sem\sources\cmake-build-debug\CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building CXX object CMakeFiles/kivrtos_stdlib.dir/stdutils/src/oled.cpp.obj"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/kivrtos_stdlib.dir/stdutils/src/oled.cpp.obj -MF CMakeFiles\kivrtos_stdlib.dir\stdutils\src\oled.cpp.obj.d -o CMakeFiles\kivrtos_stdlib.dir\stdutils\src\oled.cpp.obj -c \\wsl$$\Ubuntu\home\trefil\sem\sources\stdutils\src\oled.cpp

CMakeFiles/kivrtos_stdlib.dir/stdutils/src/oled.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/kivrtos_stdlib.dir/stdutils/src/oled.cpp.i"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E \\wsl$$\Ubuntu\home\trefil\sem\sources\stdutils\src\oled.cpp > CMakeFiles\kivrtos_stdlib.dir\stdutils\src\oled.cpp.i

CMakeFiles/kivrtos_stdlib.dir/stdutils/src/oled.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/kivrtos_stdlib.dir/stdutils/src/oled.cpp.s"
	C:\PROGRA~1\JETBRA~1\CLION2~1.3\bin\mingw\bin\G__~1.EXE $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S \\wsl$$\Ubuntu\home\trefil\sem\sources\stdutils\src\oled.cpp -o CMakeFiles\kivrtos_stdlib.dir\stdutils\src\oled.cpp.s

# Object files for target kivrtos_stdlib
kivrtos_stdlib_OBJECTS = \
"CMakeFiles/kivrtos_stdlib.dir/stdlib/src/memory_manager.cpp.obj" \
"CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdbuffer.cpp.obj" \
"CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdfile.cpp.obj" \
"CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdmutex.cpp.obj" \
"CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdstring.cpp.obj" \
"CMakeFiles/kivrtos_stdlib.dir/stdutils/src/oled.cpp.obj"

# External object files for target kivrtos_stdlib
kivrtos_stdlib_EXTERNAL_OBJECTS =

libkivrtos_stdlib.a: CMakeFiles/kivrtos_stdlib.dir/stdlib/src/memory_manager.cpp.obj
libkivrtos_stdlib.a: CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdbuffer.cpp.obj
libkivrtos_stdlib.a: CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdfile.cpp.obj
libkivrtos_stdlib.a: CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdmutex.cpp.obj
libkivrtos_stdlib.a: CMakeFiles/kivrtos_stdlib.dir/stdlib/src/stdstring.cpp.obj
libkivrtos_stdlib.a: CMakeFiles/kivrtos_stdlib.dir/stdutils/src/oled.cpp.obj
libkivrtos_stdlib.a: CMakeFiles/kivrtos_stdlib.dir/build.make
libkivrtos_stdlib.a: CMakeFiles/kivrtos_stdlib.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=\\wsl$$\Ubuntu\home\trefil\sem\sources\cmake-build-debug\CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Linking CXX static library libkivrtos_stdlib.a"
	$(CMAKE_COMMAND) -P CMakeFiles\kivrtos_stdlib.dir\cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles\kivrtos_stdlib.dir\link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/kivrtos_stdlib.dir/build: libkivrtos_stdlib.a
.PHONY : CMakeFiles/kivrtos_stdlib.dir/build

CMakeFiles/kivrtos_stdlib.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles\kivrtos_stdlib.dir\cmake_clean.cmake
.PHONY : CMakeFiles/kivrtos_stdlib.dir/clean

CMakeFiles/kivrtos_stdlib.dir/depend:
	$(CMAKE_COMMAND) -E cmake_depends "MinGW Makefiles" \\wsl$$\Ubuntu\home\trefil\sem\sources \\wsl$$\Ubuntu\home\trefil\sem\sources \\wsl$$\Ubuntu\home\trefil\sem\sources\cmake-build-debug \\wsl$$\Ubuntu\home\trefil\sem\sources\cmake-build-debug \\wsl$$\Ubuntu\home\trefil\sem\sources\cmake-build-debug\CMakeFiles\kivrtos_stdlib.dir\DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/kivrtos_stdlib.dir/depend


# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.6

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /home/hari/Downloads/CLion/clion-2016.3.4/bin/cmake/bin/cmake

# The command to remove a file.
RM = /home/hari/Downloads/CLion/clion-2016.3.4/bin/cmake/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = "/home/hari/Documents/MSCourseWork/CS6690 Pattern Recognition/Assignment/4/DTW_Isolated"

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = "/home/hari/Documents/MSCourseWork/CS6690 Pattern Recognition/Assignment/4/DTW_Isolated/cmake-build-debug"

# Include any dependencies generated for this target.
include CMakeFiles/DTW_Isolated.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/DTW_Isolated.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/DTW_Isolated.dir/flags.make

CMakeFiles/DTW_Isolated.dir/main.cpp.o: CMakeFiles/DTW_Isolated.dir/flags.make
CMakeFiles/DTW_Isolated.dir/main.cpp.o: ../main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir="/home/hari/Documents/MSCourseWork/CS6690 Pattern Recognition/Assignment/4/DTW_Isolated/cmake-build-debug/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/DTW_Isolated.dir/main.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/DTW_Isolated.dir/main.cpp.o -c "/home/hari/Documents/MSCourseWork/CS6690 Pattern Recognition/Assignment/4/DTW_Isolated/main.cpp"

CMakeFiles/DTW_Isolated.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/DTW_Isolated.dir/main.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E "/home/hari/Documents/MSCourseWork/CS6690 Pattern Recognition/Assignment/4/DTW_Isolated/main.cpp" > CMakeFiles/DTW_Isolated.dir/main.cpp.i

CMakeFiles/DTW_Isolated.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/DTW_Isolated.dir/main.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S "/home/hari/Documents/MSCourseWork/CS6690 Pattern Recognition/Assignment/4/DTW_Isolated/main.cpp" -o CMakeFiles/DTW_Isolated.dir/main.cpp.s

CMakeFiles/DTW_Isolated.dir/main.cpp.o.requires:

.PHONY : CMakeFiles/DTW_Isolated.dir/main.cpp.o.requires

CMakeFiles/DTW_Isolated.dir/main.cpp.o.provides: CMakeFiles/DTW_Isolated.dir/main.cpp.o.requires
	$(MAKE) -f CMakeFiles/DTW_Isolated.dir/build.make CMakeFiles/DTW_Isolated.dir/main.cpp.o.provides.build
.PHONY : CMakeFiles/DTW_Isolated.dir/main.cpp.o.provides

CMakeFiles/DTW_Isolated.dir/main.cpp.o.provides.build: CMakeFiles/DTW_Isolated.dir/main.cpp.o


# Object files for target DTW_Isolated
DTW_Isolated_OBJECTS = \
"CMakeFiles/DTW_Isolated.dir/main.cpp.o"

# External object files for target DTW_Isolated
DTW_Isolated_EXTERNAL_OBJECTS =

DTW_Isolated: CMakeFiles/DTW_Isolated.dir/main.cpp.o
DTW_Isolated: CMakeFiles/DTW_Isolated.dir/build.make
DTW_Isolated: CMakeFiles/DTW_Isolated.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir="/home/hari/Documents/MSCourseWork/CS6690 Pattern Recognition/Assignment/4/DTW_Isolated/cmake-build-debug/CMakeFiles" --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable DTW_Isolated"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/DTW_Isolated.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/DTW_Isolated.dir/build: DTW_Isolated

.PHONY : CMakeFiles/DTW_Isolated.dir/build

CMakeFiles/DTW_Isolated.dir/requires: CMakeFiles/DTW_Isolated.dir/main.cpp.o.requires

.PHONY : CMakeFiles/DTW_Isolated.dir/requires

CMakeFiles/DTW_Isolated.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/DTW_Isolated.dir/cmake_clean.cmake
.PHONY : CMakeFiles/DTW_Isolated.dir/clean

CMakeFiles/DTW_Isolated.dir/depend:
	cd "/home/hari/Documents/MSCourseWork/CS6690 Pattern Recognition/Assignment/4/DTW_Isolated/cmake-build-debug" && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" "/home/hari/Documents/MSCourseWork/CS6690 Pattern Recognition/Assignment/4/DTW_Isolated" "/home/hari/Documents/MSCourseWork/CS6690 Pattern Recognition/Assignment/4/DTW_Isolated" "/home/hari/Documents/MSCourseWork/CS6690 Pattern Recognition/Assignment/4/DTW_Isolated/cmake-build-debug" "/home/hari/Documents/MSCourseWork/CS6690 Pattern Recognition/Assignment/4/DTW_Isolated/cmake-build-debug" "/home/hari/Documents/MSCourseWork/CS6690 Pattern Recognition/Assignment/4/DTW_Isolated/cmake-build-debug/CMakeFiles/DTW_Isolated.dir/DependInfo.cmake" --color=$(COLOR)
.PHONY : CMakeFiles/DTW_Isolated.dir/depend


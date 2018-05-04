# all dependencies that are not directly included in the cpp-wiseplat distribution are defined here
# for this to work, download the dependency via the cmake script in extdep or install them manually!

function(wsh_show_dependency DEP NAME)
	get_property(DISPLAYED GLOBAL PROPERTY WSH_${DEP}_DISPLAYED)
	if (NOT DISPLAYED)
		set_property(GLOBAL PROPERTY WSH_${DEP}_DISPLAYED TRUE)
		message(STATUS "${NAME} headers: ${${DEP}_INCLUDE_DIRS}")
		message(STATUS "${NAME} lib   : ${${DEP}_LIBRARIES}")
		if (NOT("${${DEP}_DLLS}" STREQUAL ""))
			message(STATUS "${NAME} dll   : ${${DEP}_DLLS}")
		endif()
	endif()
endfunction()

if (DEFINED MSVC)
	# by defining CMAKE_PREFIX_PATH variable, cmake will look for dependencies first in our own repository before looking in system paths like /usr/local/ ...
	# this must be set to point to the same directory as $WSH_DEPENDENCY_INSTALL_DIR in /extdep directory

	if (CMAKE_CXX_COMPILER_VERSION VERSION_LESS 19.0.0)
		set (WSH_DEPENDENCY_INSTALL_DIR "${CMAKE_CURRENT_LIST_DIR}/../extdep/install/windows/x64")
	else()
		get_filename_component(DEPS_DIR "${CMAKE_CURRENT_LIST_DIR}/../deps/install" ABSOLUTE)
		set(WSH_DEPENDENCY_INSTALL_DIR
			"${DEPS_DIR}/x64"					# Old location for deps.
			"${DEPS_DIR}/win64"					# New location for deps.
			"${DEPS_DIR}/win64/Release/share"	# LLVM shared cmake files.
		)
	endif()
	set (CMAKE_PREFIX_PATH ${WSH_DEPENDENCY_INSTALL_DIR} ${CMAKE_PREFIX_PATH})
endif()

# custom cmake scripts
set(WSH_CMAKE_DIR ${CMAKE_CURRENT_LIST_DIR})
set(WSH_SCRIPTS_DIR ${WSH_CMAKE_DIR}/scripts)

find_program(CTEST_COMMAND ctest)

#message(STATUS "CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH}")
#message(STATUS "CMake Helper Path: ${WSH_CMAKE_DIR}")
#message(STATUS "CMake Script Path: ${WSH_SCRIPTS_DIR}")
#message(STATUS "ctest path: ${CTEST_COMMAND}")

## use multithreaded boost libraries, with -mt suffix
set(Boost_USE_MULTITHREADED ON)
option(Boost_USE_STATIC_LIBS "Link Boost statically" ON)

find_package(Boost 1.54.0 QUIET REQUIRED COMPONENTS regex filesystem unit_test_framework program_options system)

wsh_show_dependency(Boost boost)

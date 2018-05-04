function(create_build_info NAME)

	# Set build platform; to be written to BuildInfo.h
	set(WSH_BUILD_OS "${CMAKE_SYSTEM_NAME}")

	if (CMAKE_COMPILER_IS_MINGW)
		set(WSH_BUILD_COMPILER "mingw")
	elseif (CMAKE_COMPILER_IS_MSYS)
		set(WSH_BUILD_COMPILER "msys")
	elseif (CMAKE_COMPILER_IS_GNUCXX)
		set(WSH_BUILD_COMPILER "g++")
	elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
		set(WSH_BUILD_COMPILER "msvc")
	elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
		set(WSH_BUILD_COMPILER "clang")
	elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "AppleClang")
		set(WSH_BUILD_COMPILER "appleclang")
	else ()
		set(WSH_BUILD_COMPILER "unknown")
	endif ()

	set(WSH_BUILD_PLATFORM "${WSH_BUILD_OS}.${WSH_BUILD_COMPILER}")

	#cmake build type may be not speCified when using msvc
	if (CMAKE_BUILD_TYPE)
		set(_cmake_build_type ${CMAKE_BUILD_TYPE})
	else()
		set(_cmake_build_type "${CMAKE_CFG_INTDIR}")
	endif()

	# Generate header file containing useful build information
	add_custom_target(${NAME}_BuildInfo.h ALL
		WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
		COMMAND ${CMAKE_COMMAND} -DWSH_SOURCE_DIR="${PROJECT_SOURCE_DIR}" -DWSH_BUILDINFO_IN="${WSH_CMAKE_DIR}/templates/BuildInfo.h.in" -DWSH_DST_DIR="${PROJECT_BINARY_DIR}/include/${PROJECT_NAME}" -DWSH_CMAKE_DIR="${WSH_CMAKE_DIR}"
		-DWSH_BUILD_TYPE="${_cmake_build_type}"
		-DWSH_BUILD_OS="${WSH_BUILD_OS}"
		-DWSH_BUILD_COMPILER="${WSH_BUILD_COMPILER}"
		-DWSH_BUILD_PLATFORM="${WSH_BUILD_PLATFORM}"
		-DPROJECT_VERSION="${PROJECT_VERSION}"
		-P "${WSH_SCRIPTS_DIR}/buildinfo.cmake"
		)
	include_directories("${PROJECT_BINARY_DIR}/include")
endfunction()

#A script for building Micromanager with CMake
PROJECT(MicroManager C CXX)
CMAKE_MINIMUM_REQUIRED(VERSION 3.0)

IF(MSVC)
  # Suppress warnings
  ADD_DEFINITIONS("/wd4996 /wd4267 /wd4291 /wd4244 /wd4800 /wd4251")
ENDIF()

#Micromanager uses Boost extensively. Here, we set some mandatory packages. 
#Other devices may require additional drivers
SET(BOOST_MANDATORY_COMPONENTS
    system
    date_time
    thread
    chrono
)

#This is my integrated development environment and should not affect other builds
#Set this to off for builds that depend on regular FIND_PACKAGE commands
SET(USE_INTEGRATED_DEV OFF CACHE BOOL "Use Integrated Build Environment?") 
IF(USE_INTEGRATED_DEV)
  SET(MODULAR_MANDATORY_LIB_LIST boost-1_55)
  IF(MSVC)
    FIND_PACKAGE(ThirdPartyLibraries_VS2015 REQUIRED)
  ELSEIF(APPLE)
    FIND_PACKAGE(ThirdPartyLibraries_MacOSX REQUIRED)
  ELSE()
    FIND_PACKAGE(ThirdPartyLibraries_Linux REQUIRED)
  ENDIF()
ELSE()
  #Detect the Boost headers and libraries. The libraries have been built as
  #shared and multithreaded. On a Mac OSX use macports to install boost. You will
  #need to set the path of the  boost libraries (or copy them to the directory
  #where mmgr is built)
  #Check if a python wrapped version of MMCore needs to be built instead
  SET(PyMMCore OFF CACHE BOOL "Build Python-wrapped MMCore")

  IF(NOT PyMMCore)
    FIND_PACKAGE(Boost REQUIRED COMPONENTS system date_time thread chrono)
  ELSE()
    FIND_PACKAGE(Boost REQUIRED COMPONENTS system date_time thread chrono python)
    FIND_PACKAGE(SWIG REQUIRED)
    INCLUDE(${SWIG_USE_FILE})
    SET(Python_ADDITIONAL_VERSIONS 3.4 3.5 3.6)
    FIND_PACKAGE(PythonLibs 3 REQUIRED)
    INCLUDE_DIRECTORIES(${PYTHON_INCLUDE_PATH})
  ENDIF()
  
  #Here, we add a global definition indicating that only dynamic linking is possible
  ADD_DEFINITIONS(-DBOOST_ALL_DYN_LINK)
  #Include the path of the boost include directory
  INCLUDE_DIRECTORIES(${Boost_INCLUDE_DIRS})
  #and the library directories
  LINK_DIRECTORIES(${Boost_LIBRARY_DIR})
ENDIF()

#We need to add the thread library if we are not under Windows. In addition
#check Micromanager's configure.ac to add stuff necessary for Apple (specifically
#SERIALFRAMEWORKS (ToDo)
SET(MISC_LIBS)
IF (NOT MSVC)
  IF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "CLang")
    SET(CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} "-std=c++11 -stdlib=libc++ -I/usr/include/libcxxabi")
    SET(CMAKE_EXE_LINKER_FLAGS ${CMAKE_EXE_LINKER_FLAGS} "-std=c++11 -stdlib=libc++ -lc++abi")
  ENDIF()
  FIND_PACKAGE (Threads REQUIRED)
  SET(MISC_LIBS ${MISC_LIBS} ${CMAKE_THREAD_LIBS_INIT})
ENDIF()

#Set a global include directory
INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR})
INCLUDE(${PROJECT_SOURCE_DIR}/cmake/MMDevice.cmake)
INCLUDE(${PROJECT_SOURCE_DIR}/cmake/MMCore.cmake)
INCLUDE(${PROJECT_SOURCE_DIR}/cmake/DeviceAdapter.cmake)
#Do not build the C++ unit tests if a python library is sought
IF(NOT PyMMCore)
  INCLUDE(${PROJECT_SOURCE_DIR}/cmake/UnitTests.cmake)
ENDIF()
INCLUDE(${PROJECT_SOURCE_DIR}/cmake/InstallMM.cmake)

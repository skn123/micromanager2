PROJECT(MicroManager C CXX)
CMAKE_MINIMUM_REQUIRED(VERSION 3.0)

IF(MSVC)
  # Suppress warning in Flann
  ADD_DEFINITIONS("/wd4996 /wd4267 /wd4291 /wd4244 /wd4800 /wd4251")
ENDIF()

SET(MODULAR_MANDATORY_LIB_LIST boost-1_55)
SET(Boost_MANDATORY_PACKAGES
    system
    date_time
    thread
)
FIND_PACKAGE(ThirdPartyLibraries_VS2013 REQUIRED)

#We need to add the thread library if we are not under Windows. In addition
#check Micromanager's configure.ac to add stuff necessary for Apple (specifically
#SERIALFRAMEWORKS
SET(MISC_LIBS)
IF (NOT MSVC)
  FIND_PACKAGE (Threads REQUIRED)
  SET(MISC_LIBS ${MISC_LIBS} ${CMAKE_THREAD_LIBS_INIT})
ENDIF()

#Set a global include directory
INCLUDE_DIRECTORIES(${PROJECT_SOURCE_DIR})
INCLUDE(${PROJECT_SOURCE_DIR}/cmake/MMDevice.cmake)
INCLUDE(${PROJECT_SOURCE_DIR}/cmake/MMCore.cmake)
INCLUDE(${PROJECT_SOURCE_DIR}/cmake/DeviceAdapter.cmake)
INCLUDE(${PROJECT_SOURCE_DIR}/cmake/UnitTests.cmake)
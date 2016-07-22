#==============================================================================#
#Adapters - A common framework for building them (Some examples)
#==============================================================================#
IF(NOT MSVC)
  SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_SOURCE_DIR}/cmake/Devices)
ENDIF()
SET(MY_ADAPTERS 
  Arduino
  #BaumerOptronic
  LabEnDMI
	LeicaDMI
	Tofra
	Ximea
	Zaber
)

SET(Device_LIB_LIST)
FOREACH(Adapter ${MY_ADAPTERS})
  SET(DeviceAdapter_${Adapter}_ENABLE OFF CACHE BOOL "Build ${Adapter} Module")
  IF(DeviceAdapter_${Adapter}_ENABLE)    
    #===========================================================================
    #Check for specific adapters
    #===========================================================================
    IF("${Adapter}" MATCHES "Ximea")
      IF(NOT USE_INTEGRATED_DEV)
        FIND_PACKAGE(XIMEA REQUIRED)
        INCLUDE_DIRECTORIES(${XIMEA_INCLUDE_DIRS})
        SET(Device_LIB_LIST ${XIMEA_LIBRARIES})
      ELSE()
        SET(NonModularLibrary_Ximea ON CACHE BOOL "Use Ximea Library" FORCE)
      ENDIF()
    ELSEIF("${Adapter}" MATCHES "BaumerOptronic")
      FIND_PACKAGE(BaumerOptronic REQUIRED)
      INCLUDE(${BAUMEROPTRONIC_USE_FILE})
    ENDIF()
    
    SET(${Adapter}_DIR ${PROJECT_SOURCE_DIR}/micromanager2/DeviceAdapters/${Adapter})
    INCLUDE_DIRECTORIES(${${Adapter}_DIR})
    FILE(GLOB ${Adapter}_SRCS  ${${Adapter}_DIR}/*.cpp ${${Adapter}_DIR}/*.h)
    ADD_LIBRARY(mmgr_dal_${Adapter} SHARED 
                                    ${${Adapter}_SRCS}
                                    $<TARGET_OBJECTS:MMDevice_DeviceAdapters>
    )
    
    IF(MSVC)
    ELSEIF(APPLE)
    ELSE()
      #ToDo; Apparently in Linux, we need to change the suffix from .so to .so.0
      SET_TARGET_PROPERTIES(mmgr_dal_${Adapter} PROPERTIES 
                                                COMPILE_FLAGS "-DMODULE_EXPORTS -fPIC -std=c++11 -stdlib=libc++ -I/usr/include/libcxxabi"
                                                DEBUG_POSTFIX "_d"
                                                SUFFIX ".so.0") 
    ENDIF()
    TARGET_LINK_LIBRARIES(mmgr_dal_${Adapter} ${Device_LIB_LIST})

    SET(INSTALL_LIBS  ${INSTALL_LIBS} mmgr_dal_${Adapter})
  ENDIF()
ENDFOREACH()

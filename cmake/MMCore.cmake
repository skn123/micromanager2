#==============================================================================#
#MMCore: This is the core plugin manager
#==============================================================================#
SET(MMCore_DIR ${PROJECT_SOURCE_DIR}/micromanager2/MMCore)
SET(MMCore_PyDir ${PROJECT_SOURCE_DIR}/micromanager2/MMCorePy_wrap)

SET(MMGR_DIRS ${MMGR_DIRS} ${MMCore_DIR})
SET(MMCore_SUBDIRS  Devices
                    LibraryInfo
                    LoadableModules
                    Logging)
SET(MMCore_SRCS)
SET(MMCore_HDRS)
FOREACH(Folder ${MMCore_SUBDIRS})
  INCLUDE_DIRECTORIES(${MMCore_DIR}/${Folder})
  FILE(GLOB Temp ${MMCore_DIR}/${Folder}/*.cpp)
  SET(MMCore_SRCS ${MMCore_SRCS} ${Temp})
  FILE(GLOB Temp ${MMCore_DIR}/${Folder}/*.h)
  SET(MMCore_HDRS ${MMCore_HDRS} ${Temp})
ENDFOREACH()

#We check if we are building this library using MSVC/Apple/Linux
IF(MSVC)
  LIST( REMOVE_ITEM MMCore_SRCS ${MMCore_DIR}/LoadableModules/LoadedModuleImplUnix.cpp )
  LIST( REMOVE_ITEM MMCore_SRCS ${MMCore_DIR}/LoadableModules/LoadedModuleImplUnix.h )
  LIST( REMOVE_ITEM MMCore_SRCS ${MMCore_DIR}/AppleHost.h )
ELSEIF(APPLE)
  LIST( REMOVE_ITEM MMCore_SRCS ${MMCore_DIR}/LoadableModules/LoadedModuleImplWindows.cpp )
  LIST( REMOVE_ITEM MMCore_SRCS ${MMCore_DIR}/LoadableModules/LoadedModuleImplWindows.h )
ELSE()
  LIST( REMOVE_ITEM MMCore_SRCS ${MMCore_DIR}/LoadableModules/LoadedModuleImplWindows.cpp )
  LIST( REMOVE_ITEM MMCore_SRCS ${MMCore_DIR}/LoadableModules/LoadedModuleImplWindows.h )
  LIST( REMOVE_ITEM MMCore_SRCS ${MMCore_DIR}/AppleHost.h )  
ENDIF()

#Add the other files here
FILE(GLOB Temp ${MMCore_DIR}/*.cpp)
SET(MMCore_SRCS ${MMCore_SRCS} ${Temp})
FILE(GLOB Temp ${MMCore_DIR}/*.h)
SET(MMCore_HDRS ${MMCore_HDRS} ${Temp})

#Check what library is required to be built
IF(NOT PyMMCore)
  #Here we build the C++ library
  ADD_LIBRARY(MMCore SHARED ${MMCore_SRCS} ${MMCore_HDRS} $<TARGET_OBJECTS:MMDevice_MMCore>)
  IF (MSVC)
    #Apparently for windows, an additional library called Iphlpapi is required"
    TARGET_LINK_LIBRARIES(MMCore ${MODULAR_LIBRARY_LIST} ${NOMMODULAR_LIBRARY_LIST} Iphlpapi)
    SET_TARGET_PROPERTIES(MMCore PROPERTIES 
                          COMPILE_FLAGS "-DMMCORE_MODULE_EXPORTS -DMODULE_EXPORTS -DBOOST_THREAD_DONT_PROVIDE_CONDITION -DMMCORE_EXPORTS"
                          DEBUG_POSTFIX "_d") 
  ELSE()
    #For *nix based system, we need to link it wil libdl"
    TARGET_LINK_LIBRARIES(MMCore ${Boost_LIBRARIES} dl)
    SET_TARGET_PROPERTIES(MMCore PROPERTIES 
                          COMPILE_FLAGS "-DMMCORE_MODULE_EXPORTS -DMODULE_EXPORTS -DBOOST_THREAD_DONT_PROVIDE_CONDITION -DMMCORE_EXPORTS -fPIC"
                          DEBUG_POSTFIX "_d") 
  ENDIF()
  
  SET(INSTALL_HDRS  ${MMCore_DIR}/PluginManager.h
                    ${MMCore_DIR}/Error.h
                    ${MMCore_DIR}/ErrorCodes.h)
  SET(INSTALL_LIBS  MMCore)
ELSE()
  #Do a swig conversion
  SET(MMCore_Py_Wrapper_In ${MMCore_PyDir}/MMCorePy.i)
  SET_SOURCE_FILES_PROPERTIES(${MMCore_Py_Wrapper_In} PROPERTIES CPLUSPLUS ON)
  #Build object files library
  ADD_LIBRARY(MMCoreObj ${MMCore_SRCS} ${MMCore_HDRS} $<TARGET_OBJECTS:MMDevice_MMCore>)
  IF (MSVC)
    SET_TARGET_PROPERTIES(MMCoreObj PROPERTIES 
                          COMPILE_FLAGS "-DMMCORE_MODULE_EXPORTS -DMODULE_EXPORTS -DBOOST_THREAD_DONT_PROVIDE_CONDITION -DMMCORE_EXPORTS") 
  ELSE()
    SET_TARGET_PROPERTIES(MMCoreObj PROPERTIES 
                          COMPILE_FLAGS "-DMMCORE_MODULE_EXPORTS -DMODULE_EXPORTS -DBOOST_THREAD_DONT_PROVIDE_CONDITION -DMMCORE_EXPORTS -fPIC"
                          DEBUG_POSTFIX "_d") 
  ENDIF()
  
  #Build the python wrapped library
  SWIG_ADD_MODULE(MMCorePy python "${MMCore_Py_Wrapper_In}")
  IF(MSVC)
    SWIG_LINK_LIBRARIES(MMCorePy MMCoreObj ${MODULAR_LIBRARY_LIST} ${NOMMODULAR_LIBRARY_LIST} Iphlpapi)
  ELSE()
    SWIG_LINK_LIBRARIES(MMCorePy MMCoreObj ${Boost_LIBRARIES} ${PYTHON_LIBRARIES} dl)
  ENDIF()
ENDIF()



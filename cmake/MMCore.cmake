#==============================================================================#
#MMCore: This is the core plugin manager
#==============================================================================#
SET(MMCore_DIR ${PROJECT_SOURCE_DIR}/micromanager2/MMCore)
SET(MMGR_DIRS ${MMGR_DIRS} ${MMCore_DIR})
SET(MMCore_SUBDIRS  Devices
                    LibraryInfo
                    LoadableModules
                    Logging)
SET(MMCore_SRCS)
FOREACH(Folder ${MMCore_SUBDIRS})
  INCLUDE_DIRECTORIES(${MMCore_DIR}/${Folder})
  FILE(GLOB Temp ${MMCore_DIR}/${Folder}/*.cpp
                 ${MMCore_DIR}/${Folder}/*.h)
  SET(MMCore_SRCS ${MMCore_SRCS} ${Temp})
ENDFOREACH()

#We check if we are building this library using MSVC
IF(MSVC)
  LIST( REMOVE_ITEM MMCore_SRCS ${MMCore_DIR}/LoadableModules/LoadedModuleImplUnix.cpp )
  LIST( REMOVE_ITEM MMCore_SRCS ${MMCore_DIR}/LoadableModules/LoadedModuleImplUnix.h )
  LIST( REMOVE_ITEM MMCore_SRCS ${MMCore_DIR}/AppleHost.h )
ENDIF()

FILE(GLOB Temp  ${MMCore_DIR}/*.cpp
                ${MMCore_DIR}/*.h)
SET(MMCore_SRCS ${MMCore_SRCS} ${Temp})

ADD_LIBRARY(MMCore SHARED ${MMCore_SRCS} $<TARGET_OBJECTS:MMDevice_MMCore>)
SET_TARGET_PROPERTIES(  MMCore PROPERTIES 
                        COMPILE_FLAGS "-DMMCORE_MODULE_EXPORTS -DMODULE_EXPORTS -DBOOST_THREAD_DONT_PROVIDE_CONDITION -DMMCORE_EXPORTS"
                        DEBUG_POSTFIX "_d") 
#Apparently for windows, an additional library called Iphlpapi is required"
IF (MSVC)
  TARGET_LINK_LIBRARIES(MMCore ${MODULAR_LIBRARY_LIST} ${NOMMODULAR_LIBRARY_LIST} Iphlpapi)
ELSE()
  TARGET_LINK_LIBRARIES(MMCore ${MODULAR_LIBRARY_LIST} ${NOMMODULAR_LIBRARY_LIST})
ENDIF()


SET(INSTALL_HDRS  ${MMCore_DIR}/PluginManager.h
                  ${MMCore_DIR}/Error.h
                  ${MMCore_DIR}/ErrorCodes.h)
SET(INSTALL_LIBS  MMCore)
#==============================================================================#
#Adapters - A common framework for building them (Some examples)
#==============================================================================#
SET(MY_ADAPTERS LeicaDMI
                Zaber
                SerialManager)

FOREACH(Adapter ${MY_ADAPTERS})
  SET(${Adapter}_DIR ${PROJECT_SOURCE_DIR}/micromanager2/DeviceAdapters/${Adapter})
  INCLUDE_DIRECTORIES(${${Adapter}_DIR})
  FILE(GLOB ${Adapter}_SRCS  ${${Adapter}_DIR}/*.cpp ${${Adapter}_DIR}/*.h)
  ADD_LIBRARY(mmgr_dal_${Adapter} SHARED 
                                  ${${Adapter}_SRCS}
                                  $<TARGET_OBJECTS:MMDevice_DeviceAdapters>
  )
  #ToDo; Apparently in Linux, we need to change the suffix from .so to .so.0
  SET_TARGET_PROPERTIES(mmgr_dal_${Adapter} PROPERTIES 
                                            COMPILE_FLAGS "-DMODULE_EXPORTS"
                                            DEBUG_POSTFIX "_d") 
  TARGET_LINK_LIBRARIES(mmgr_dal_${Adapter} ${MODULAR_LIBRARY_LIST} ${NOMMODULAR_LIBRARY_LIST})

  SET(INSTALL_LIBS  ${INSTALL_LIBS} mmgr_dal_${Adapter})
ENDFOREACH()
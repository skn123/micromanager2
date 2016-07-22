#==============================================================================#
#                  Gather all files for installation
#==============================================================================#
INSTALL( TARGETS ${INSTALL_LIBS}
         ARCHIVE DESTINATION lib
         LIBRARY DESTINATION lib
         RUNTIME DESTINATION bin
)

#We keep the directory structure of Micromanager for backward compatibility
FOREACH(MY_SUBDIR ${MMGR_DIRS})
  INSTALL(DIRECTORY ${MY_SUBDIR} 
          DESTINATION include 
          FILES_MATCHING 
          PATTERN "*.h" 
          PATTERN "*.hpp"
          PATTERN "*.hxx"
          PATTERN "*.txx"
  )    
ENDFOREACH()

#Generate two lists
SET(MMGr_LIB_Release)
SET(MMGr_LIB_Debug)
FOREACH(MyLib ${INSTALL_LIBS})
  SET(MMGr_LIB_Release ${MMGr_LIB_Release} optimized ${MyLib})
  SET(MMGr_LIB_Debug ${MMGr_LIB_Debug} debug ${MyLib}_d)
ENDFOREACH()

IF(PyMMCore)
  #We also need to install the .py files
  INSTALL(FILES ${PROJECT_BINARY_DIR}/MMCorePy.py 
                ${PROJECT_BINARY_DIR}/_MMCorePy.so 
          DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
  )
ENDIF()

#==============================================================================#
# Configure files with settings for use by the build.
#==============================================================================#
CONFIGURE_FILE(${PROJECT_SOURCE_DIR}/cmake/UseMicromanager.cmake.in
               ${CMAKE_INSTALL_PREFIX}/cmake/UseMicromanager.cmake COPYONLY IMMEDIATE)
CONFIGURE_FILE(${PROJECT_SOURCE_DIR}/cmake/MicromanagerConfig.cmake.in
               ${CMAKE_INSTALL_PREFIX}/cmake/MicromanagerConfig.cmake @ONLY IMMEDIATE)



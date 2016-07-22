SET(UT_DIR ${PROJECT_SOURCE_DIR}/UnitTest)

#-------------------------------------------------------------------------------
#List out all the unit test modules
#-------------------------------------------------------------------------------
ADD_EXECUTABLE(SerialManagerTest ${UT_DIR}/SerialManagerTest.cpp)
TARGET_LINK_LIBRARIES(SerialManagerTest MMCore)

IF(USE_INTEGRATED_DEV)
  ADD_CUSTOM_COMMAND(
    TARGET ZaberTest  
    POST_BUILD 
    COMMAND ${CMAKE_COMMAND} 
           -DTARGETDIR=$<TARGET_FILE_DIR:SerialManagerTest> 
           -DRELEASE_LIBS=${RELEASE_LIBS_TO_BE_COPIED}
           -DDEBUG_LIBS=${DEBUG_LIBS_TO_BE_COPIED}
           -DCFG=${CMAKE_CFG_INTDIR} -P "${LIBRARY_ROOT}/PostBuild.cmake"
  ) 
ENDIF()
